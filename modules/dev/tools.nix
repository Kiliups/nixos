{ pkgs, ... }: {
  home.packages = with pkgs; [
    # tools
    code-cursor
    zed-editor
    postman
    dbeaver-bin
    opencode
    openssl

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
    nixfmt-classic
    nixd

    # mobile
    flutter

    # latex
    miktex
    ltex-ls

    #docker
    docker
    docker-compose
  ];
}
