{ host, pkgs, ... }:
{
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };

  programs = {
    zsh = {
      shellAliases = { };
      initContent = ''
        nx() {
          code "''${NIXOS_FLAKE:-$HOME/.config/nixos}"
        }

        nfu() {
          local flake="''${1:-''${NIXOS_FLAKE:-$HOME/.config/nixos}}"
          nix flake update --flake "$flake"
        }

        nrs() {
          local flake="''${1:-''${NIXOS_FLAKE:-$HOME/.config/nixos}}"
          local host="''${2:-$(hostname)}"
          (cd "$flake" && git add -A && sudo nixos-rebuild switch --flake "path:$PWD#$host" --impure)
        }

        nrsu() {
          local flake="''${1:-''${NIXOS_FLAKE:-$HOME/.config/nixos}}"
          local host="''${2:-$(hostname)}"
          nfu "$flake" && nrs "$flake" "$host"
        }

        bindkey '^[[1;5D' backward-word
        bindkey '^[[1;5C' forward-word
        bindkey '^[[5D' backward-word
        bindkey '^[[5C' forward-word
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
  '';
}
