{ pkgs, ... }:
{
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };

  programs = {
    zsh = {
      shellAliases = {
        nx = "code ~/.config/nixos";
        nfu = "sudo nix flake update --flake ~/.config/nixos";
        nrsu = "nfu && nrs";
      };
      initContent = ''
        nrs() {
          local host="''${1:-$(hostname)}"
          (cd ~/.config/nixos && git add -A && sudo nixos-rebuild switch --flake .#''${host} --impure)
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
        user.name = "Public User";
        user.email = "user@example.invalid";
        init.defaultBranch = "main";
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
