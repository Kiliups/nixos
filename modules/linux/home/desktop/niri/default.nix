{ lib, pkgs, ... }:
let
  arrangeDisplays = pkgs.writeShellApplication {
    name = "niri-arrange-displays";
    runtimeInputs = [
      pkgs.jq
      pkgs.niri
    ];
    text = ''
      arrange() {
        local outputs laptop laptop_width externals total_width max_height external_x laptop_x x width height name
        outputs="$(niri msg -j outputs 2>/dev/null)" || return 0
        laptop="$(printf '%s\n' "$outputs" | jq -r '
          first(to_entries[] | select(.key | startswith("eDP-")) | select(.value.logical) | .key) // empty
        ')"
        [ -n "$laptop" ] || return 0

        laptop_width="$(printf '%s\n' "$outputs" | jq -r --arg o "$laptop" '.[$o].logical.width')"
        externals="$(printf '%s\n' "$outputs" | jq -r --arg laptop "$laptop" '
          to_entries[]
          | select(.key != $laptop and .value.logical)
          | [.key, .value.logical.width, .value.logical.height]
          | @tsv
        ')"
        [ -n "$externals" ] || return 0

        total_width=0
        max_height=0
        while IFS=$'\t' read -r name width height; do
          total_width=$((total_width + width))
          [ "$height" -gt "$max_height" ] && max_height=$height
        done <<< "$externals"

        if [ "$total_width" -ge "$laptop_width" ]; then
          external_x=0
          laptop_x=$(((total_width - laptop_width) / 2))
        else
          external_x=$(((laptop_width - total_width) / 2))
          laptop_x=0
        fi

        x=$external_x
        while IFS=$'\t' read -r name width height; do
          niri msg output "$name" position set "$x" 0 >/dev/null
          x=$((x + width))
        done <<< "$externals"

        niri msg output "$laptop" position set "$laptop_x" "$max_height" >/dev/null
      }

      arrange
      niri msg -j event-stream | while read -r event; do
        printf '%s\n' "$event" | jq -e 'keys[0] | startswith("Output")' >/dev/null && arrange
      done
    '';
  };

  screenshot = pkgs.writeShellApplication {
    name = "niri-screenshot";
    runtimeInputs = with pkgs; [
      coreutils
      grim
      libnotify
      satty
      slurp
      wl-clipboard
    ];
    text = ''
      screenshots="''${NIRI_SCREENSHOT_DIR:-''${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots}"
      output="$screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"

      mkdir -p "$screenshots"
      selection="$(slurp)" || exit 0
      grim -g "$selection" "$output"
      wl-copy < "$output"

      action="$(notify-send "Screenshot saved to clipboard and file" "Click to edit" -t 10000 -i "$output" -A "default=edit" || true)"
      if [ "$action" = "default" ]; then
        satty --filename "$output" --output-filename "$output" --copy-command wl-copy --actions-on-enter save-to-clipboard --save-after-copy --app-id satty
      fi
    '';
  };
in
{
  imports = [
    ./config.nix
    ./idle.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    kooha
    screenshot
    xwayland-satellite
  ];

  systemd.user.services = {
    niri-arrange-displays = {
      Unit = {
        Description = "Arrange Niri outputs";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
      };
      Service = {
        ExecStart = lib.getExe arrangeDisplays;
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    niri-xwayland-satellite = {
      Unit = {
        Description = "XWayland support for Niri";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
      };
      Service = {
        ExecStart = lib.getExe pkgs.xwayland-satellite;
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    niri-kbuildsycoca = {
      Unit = {
        Description = "Refresh KDE application metadata for Niri";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe' pkgs.kdePackages.kservice "kbuildsycoca6"} --noincremental";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  xdg.configFile."niri/cfg/autostart.kdl".text = "// Session services are managed by systemd.";
}
