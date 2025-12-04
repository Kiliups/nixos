{ pkgs, ... }:
{
  programs.zen-browser.enable = true;

  home.packages = with pkgs; [
    thunderbird
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";

      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
    };
  };
}
