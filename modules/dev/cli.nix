{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        alias nx='code /etc/nixos'
        alias ls='eza -lh --group-directories-first --icons=auto'
        alias neofetch='fastfetch'
        alias nrs='sudo nixos-rebuild switch'
        alias nrsu='nrs --upgrade'
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
      userName = "Kilian Mayer";
      userEmail = "mayer-kilian@gmx.de";
      extraConfig = {
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

  home.sessionVariables = {
    TERMINAL = "ghostty";
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };

  # Ghostty configuration
  xdg.configFile."ghostty/config".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Frappe"
    confirm-close-surface = false 
  '';
}
