{ host, pkgs, ... }:
{
  imports = [ ../../terminal.nix ];

  programs = {
    zsh = {
      initContent = ''
        nx() {
          code "$NIXOS_FLAKE"
        }

        nrs() {
          local flake="''${1:-$NIXOS_FLAKE}"
          local host="''${2:-$(hostname)}"
          (
          cd "$flake"
          git add -A
          cp "$(nix build --no-link --print-out-paths .#development-options)" templates/development/DEVELOPMENT_OPTIONS.md
          git add templates/development/DEVELOPMENT_OPTIONS.md
          local private="''${NIXOS_PRIVATE_FLAKE:-path:$PWD/private}"
          sudo nixos-rebuild switch --flake ".#$host" --override-input nixos-private "$private"
          )
        }

        nrsu() {
          local flake="''${1:-$NIXOS_FLAKE}"
          local host="''${2:-$(hostname)}"
          nfu "$flake" && nrs "$flake" "$host"
        }
      '';
    };

    git = {
      enable = true;
      settings = {
        user.name = host.name;
        user.email = host.email;
      };
    };
  };

  home.packages = with pkgs; [
    ghostty

    wl-clipboard
  ];

  xdg.configFile."ghostty/config.ghostty".text = ''
    confirm-close-surface = false
    keybind = ctrl+backspace=text:\x17
    clipboard-write = allow
    clipboard-read = allow
  '';
}
