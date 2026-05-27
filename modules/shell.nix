{ pkgs, ... }:
{
  home.sessionVariables = {
    TERMINAL = "ghostty";
    JAVA_HOME = "${pkgs.jdk25}/lib/openjdk";
    NIX = "$HOME/.config/nixos";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        nx = "code ~/.config/nixos";
        ls = "eza -lh --group-directories-first --icons=auto";
        neofetch = "fastfetch";
        nfu = "sudo nix flake update --flake ~/.config/nixos";
        nrsu = "nfu && nrs";
        nd = "nix develop -c zsh";
      };
      initContent = ''
        nrs() {
          local host="''${1:-$(hostname)}"
          (cd ~/.config/nixos && git add -A && sudo nixos-rebuild switch --flake .#''${host} --impure)
        }
        bindkey -e

        bindkey '^[[1;5D' backward-word
        bindkey '^[[1;5C' forward-word
        bindkey '^[[5D' backward-word
        bindkey '^[[5C' forward-word
      '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
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

    btop
    fastfetch
    ripgrep
    eza
    fd
    wl-clipboard
    gh
  ];

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    confirm-close-surface = false
  '';

  xdg.configFile."fastfetch/config.jsonc" = {
    source = ../config/fastfetch/config.jsonc;
  };
}
