{ pkgs, ... }:
{

  home.sessionVariables = {
    TERMINAL = "ghostty";
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };

  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        alias nx='code ~/.config/nixos'
        alias ls='eza -lh --group-directories-first --icons=auto'
        alias neofetch='fastfetch'
        alias nrs='sudo nixos-rebuild switch --flake ~/.config/nixos#kiliups-nixos --impure'
        alias nfu='sudo nix flake update --flake ~/.config/nixos'
        alias nrsu='nfu && nrs'
      '';
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      options = [ "--cmd cd" ];
    };

    git = {
      enable = true;
      settings = {
        user.name = "Kilian Mayer";
        user.email = "mayer-kilian@gmx.de";
        init.defaultBranch = "main";
      };
    };
  };

  home.packages = with pkgs; [
    ghostty

    btop
    fastfetch
    gh
    ripgrep
    eza
    fd
    tmux
  ];

  xdg.configFile."ghostty/config".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    confirm-close-surface = false 
  '';
}
