{ pkgs, ... }:
{
  imports = [
    ./astro.nix
    ./angular.nix
    ./go.nix
    ./java.nix
    ./php.nix
    ./python.nix
    ./rust.nix
    ./svelte.nix
    ./typescript.nix
    ./typst.nix
    ./vue.nix
  ];

  home.packages = with pkgs; [
    nixfmt
    nixd

    # c/c++
    gcc
    gdb
  ];
}
