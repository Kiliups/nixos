{ pkgs, ... }:
{
  imports = [
    ../home.nix
    ../../modules/apps
    ../../modules/linux/tiling
  ];

  development.full.enable = true;

  development = {
    claude.enable = false;
    codex.enable = false;
    cursor.enable = false;
    opencode.enable = true;
    pi.enable = true;
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
