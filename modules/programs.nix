{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    spotify
    discord
    onedrive
    gimp
    chromium
    zapzap
  ];

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };

  services.syncthing = {
    enable = true;
  };

}
