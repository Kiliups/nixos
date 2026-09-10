{
  lib,
  pkgs,
  ...
}:
let
  webapp = import ./webapps.nix { inherit pkgs lib; };
  adguard = "bgnkhhnnamicmpeenaelnjfhikgbkllg";
in
{
  programs.chromium = {
    enable = true;
    extensions = [ adguard ];
  };

  home.packages = with pkgs; [
    obsidian
    spotify
    (webapp {
      name = "GitHub";
      url = "https://github.com";
    })
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
