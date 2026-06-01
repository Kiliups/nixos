{ pkgs, ... }:
{
  imports = [
    ../home.nix
    ../../modules/apps
  ];

  dev = {
    shell.enable = true;
    tmux.enable = true;
    starship.enable = true;
    lazyvim.enable = true;
    vscode.enable = true;

    claude.enable = false;
    codex.enable = false;
    cursor.enable = false;
    opencode.enable = true;
    pi.enable = true;
  };

  languages = {
    angular.enable = true;
    astro.enable = true;
    go.enable = true;
    java.enable = true;
    python.enable = true;
    rust.enable = true;
    svelte.enable = true;
    typescript = {
      enable = true;
      packageManager = "bun";
    };
    typst.enable = true;
    vue.enable = true;
    php.enable = true;
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
