{ pkgs, ... }:
{
  programs.zen-browser.enable = true;

  home.packages = with pkgs; [
    thunderbird
    obsidian
    spotify
    discord
    bitwarden-desktop
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
    onlyoffice-desktopeditors
    zoom-us
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";

      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
    };
  };
}
