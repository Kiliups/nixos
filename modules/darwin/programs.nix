{ pkgs, ... }:
{
  home.packages = with pkgs; [
    google-chrome
    jetbrains.phpstorm
    obsidian
    orbstack
    spotify
  ];
}
