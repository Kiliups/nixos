{ config, pkgs, ... }:
let
  unstable = import <nixpkgs-unstable> { config = config.nixpkgs.config; };
in
{
  home.packages = with pkgs; [
    obsidian
    spotify
    discord
    unstable.onedrive
    gimp
    chromium
    zapzap
    nextcloud-client
    anki-bin
  ];

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };

}
