{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    spotify
    chromium
    discord
    gimp
    zapzap
    nextcloud-client
    audacity
    localsend
    onlyoffice-desktopeditors
    zoom-us
  ];

}
