{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    spotify
    discord
    gimp
    chromium
    zapzap
    nextcloud-client
    prismlauncher # Minecraft Launcher
    teams-for-linux
    zotero
    audacity
    eduvpn-client
    localsend
  ];

  services.syncthing = {
    enable = true;
  };
}
