{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # tools
    postman
    dbeaver-bin
    opencode

    # javascript/ts
    bun
    nodejs

    # java
    jdk21
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

    # nix
    nixfmt
    nixd

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
  ];
}
