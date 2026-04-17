{pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    spotify
    chromium
  ];
}