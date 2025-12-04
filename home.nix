{ pkgs, ... }:
{
  imports = [
    ./modules/dev
    ./modules/programs.nix
  ];

  home.username = "kiliups";
  home.homeDirectory = "/home/kiliups";
  home.stateVersion = "25.11";

  stylix = {
    autoEnable = false;
    targets = {
      zen-browser.enable = true;
      zen-browser.profileNames = [ "Default Profile" ];
      gtk.enable = true;
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/ksmserverrc".text = ''
      [General]
      loginMode=emptySession

      [LegacySession: saved at previous logout]
      count=0

      [Session: saved at previous logout]
      count=0
    '';
  };

  programs.home-manager.enable = true;
}
