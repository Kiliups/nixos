{ config, pkgs, ... }:
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
  ];

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };

}
