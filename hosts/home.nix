{ pkgs, host, ... }:
{
  imports = [
    ../modules/apps
    ../modules/linux
  ];

  home = {
    stateVersion = "26.05";
    inherit (host) username;
    homeDirectory = "/home/${host.username}";
  };

  nixpkgs.config.allowUnfree = true;

  stylix = {
    targets = {
      zen-browser.profileNames = [ "Default Profile" ];
      vscode.enable = false;
      zed.enable = false;
      qt.enable = false;
    };
  };

  programs.home-manager.enable = true;

  development.full.enable = true;

  development = {
    claude.enable = false;
    codex.enable = false;
    cursor.enable = false;
    opencode.enable = true;
  };

  languages = {
    typescript = {
      extraPackages = with pkgs; [ bun ];
    };
  };

  home.packages = with pkgs; [
    bruno
    dbeaver-bin

    # vpn
    wireguard-tools

    # image and video
    imagemagick
    ffmpeg-full

    #pdf
    poppler-utils
  ];
}
