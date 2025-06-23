{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    spotify
    discord
    onedrive
    gimp
    chromium
  ];

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };
}
