{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains.phpstorm
    obsidian
    orbstack
    spotify
    code-cursor
  ];
}
