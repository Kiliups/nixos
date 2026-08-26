{ config, host, pkgs, ... }:
{
  home.sessionVariables = {
    TERMINAL = "ghostty";
    NIXOS_FLAKE = "${config.home.homeDirectory}/.config/nixos";
  };

  programs = {
    zsh = {
      initContent = ''
        nx() {
          code "$NIXOS_FLAKE"
        }

        nfu() {
          local flake="''${1:-$NIXOS_FLAKE}"
          nix flake update --flake "$flake"
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

        bindkey '^[[1;5D' backward-word
        bindkey '^[[1;5C' forward-word
        bindkey '^[[5D' backward-word
        bindkey '^[[5C' forward-word
        bindkey '^H' backward-kill-word
        bindkey '^[[127;5u' backward-kill-word
        bindkey '^[[3;5~' kill-word
      '';
    };

    git = {
      enable = true;
      settings = {
        user.name = host.name;
        user.email = host.email;
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };

  home.packages = with pkgs; [
    ghostty

    wl-clipboard
    gh
  ];

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    confirm-close-surface = false
    keybind = ctrl+backspace=text:\x17
    clipboard-write = allow
    clipboard-read = allow
  '';
}
