{
  pkgs,
  lib,
  config,
  ...
}:
let
  colors = config.lib.stylix.colors;
in
{
  home.packages = with pkgs; [
    networkmanagerapplet # networkmanager
    kdePackages.kwalletmanager # kwallet + secret service backend
    kdePackages.polkit-kde-agent-1 # auth dialogs in hyprland
    brightnessctl # brightness keys
    pavucontrol # audio control
  ];

  services.hyprpaper.enable = true;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = lib.mkForce [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 6;
        }
      ];

      input-field = lib.mkForce [
        {
          size = "260, 52";
          position = "0, -90";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(${colors.base05})";
          inner_color = "rgb(${colors.base00})";
          outer_color = "rgb(${colors.base0D})";
          check_color = "rgb(${colors.base0B})";
          fail_color = "rgb(${colors.base08})";
          placeholder_text = "Password...";
        }
      ];

      label = lib.mkForce [
        {
          text = "cmd[update:1000] echo -n $(date +'%H:%M')";
          position = "0, 90";
          font_size = 70;
          color = "rgb(${colors.base05})";
        }
        {
          text = "cmd[update:1000] echo -n $(date +'%A, %d %B')";
          position = "0, 35";
          font_size = 20;
          color = "rgb(${colors.base04})";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "eDP-1,preferred,1147x1440,1.33"
        "DP-3,preferred,0x0,1"
        "DP-2,preferred,0x0,1"
      ];

      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      "$reload_waybar" = "pkill waybar; waybar";

      exec-once = [
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        "${pkgs.kdePackages.kwallet}/bin/kwalletd6"
        "${pkgs.kdePackages.kwallet}/bin/ksecretd"
        "sleep 2 && nm-applet --indicator"
        "waybar"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
        "col.active_border" = "rgba(${colors.base0E}ff) rgba(${colors.base0D}ff) 45deg";
        "col.inactive_border" = "rgba(${colors.base03}aa)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.95;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "de";
        follow_mouse = 1;
        sensitivity = 0;
        repeat_rate = 35;
        repeat_delay = 200;
        touchpad = {
          natural_scroll = true;
          "tap-to-click" = true;
        };
      };

      cursor = {
        inactive_timeout = 30;
        no_hardware_cursors = true;
      };

      "$mainMod" = "SUPER";

      gesture = [
        "3, horizontal, workspace"
      ];

      bind = [
        # Core
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, M, exit," # close hyprland
        "$mainMod, V, togglefloating,"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, L, exec, hyprlock"
        "$mainMod, R, exec, $reload_waybar"
        "$mainMod, G, fullscreen, 0"
        "$mainMod, P, pseudo,"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Programs
        "$mainMod, F, exec, $fileManager"
        "$mainMod, B, exec, zen-beta"
        "$mainMod, N, exec, obsidian"
        "$mainMod, M, exec, spotify"
        "$mainMod, E, exec, thunderbird"

        # Focus
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Move windows
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # Switch workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, Tab, workspace, e+1"
        "$mainMod SHIFT, Tab, workspace, e-1"
      ];

      binde = [
        # Resize windows
        "$mainMod ALT, h, resizeactive, -40 0"
        "$mainMod ALT, l, resizeactive, 40 0"
        "$mainMod ALT, k, resizeactive, 0 -40"
        "$mainMod ALT, j, resizeactive, 0 40"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      animations = {
        enabled = false;
      };

    };
  };

}
