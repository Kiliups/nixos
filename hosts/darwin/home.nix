{ pkgs, host, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  home = {
    username = host.username;
    homeDirectory = "/Users/${host.username}";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;

  stylix = {
    targets = {
      vscode.enable = false;
    };
  };

  dev = {
    shell.enable = true;
    tmux.enable = true;
    starship.enable = true;
    lazyvim.enable = true;
    vscode.enable = true;
    claude.enable = true;
    codex.enable = true;
    cursor.enable = true;
    opencode.enable = true;
    pi.enable = true;
  };

  languages = {
    angular.enable = true;
    astro.enable = true;
    java.enable = true;
    php.enable = true;
    typescript = {
      enable = true;
      packageManager = "yarn";
    };
  };

  home.packages = with pkgs; [
    spotify
    obsidian
    google-chrome
  ];
}
