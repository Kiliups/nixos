{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # tools
    bruno
    dbeaver-bin
    
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
    
    # docker
    docker
    docker-compose
  ];
}
