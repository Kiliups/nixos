{ pkgs, ... }:
{
  programs.zsh.shellAliases = {
    cc = "claude";
    ccli = "cursor-agent";
    cx = "codex";
    opc = "opencode";
  };

  home.packages = with pkgs; [
    # agents
    opencode
    cursor-cli
    claude-code
    codex
    pi-coding-agent

    # nix
    nixfmt
    nixd

    # tools
    bruno
    dbeaver-bin

    # javascript/ts
    bun
    nodejs

    # java
    jdk25
    maven
    gradle

    # go
    go
    golangci-lint

    # rust
    cargo
    rustc
    rustfmt
    clippy

    # c/c++
    gcc
    gdb

    # mobile
    flutter

    # language tool
    ltex-ls-plus

    # typst
    typst
    tinymist

    # docker
    docker
    docker-compose

    # vpn
    wireguard-tools

    # image and video
    imagemagick
    ffmpeg-full

    #pdf
    poppler-utils
  ];
}
