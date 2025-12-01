{ pkgs, ... }:
{
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nrsuf" ''
      #!/bin/sh
      set -e

      sudo nix flake update --flake ~/.config/nixos
      sudo nixos-rebuild switch --flake ~/.config/nixos#kiliups-nixos --impure

      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      ${pkgs.flatpak}/bin/flatpak install flathub app.zen_browser.zen -y
      ${pkgs.flatpak}/bin/flatpak install flathub org.mozilla.Thunderbird -y
      ${pkgs.flatpak}/bin/flatpak update -y
    '')
  ];

  xdg.mime.defaultApplications = {
    "text/html" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/mailto" = "org.mozilla.Thunderbird.desktop";
    "message/rfc822" = "org.mozilla.Thunderbird.desktop";
  };
}
