{ ... }:
{
  imports = [
    ./modules/programs.nix
  ];

  home.username = "leonie";
  home.homeDirectory = "/home/leonie";
  home.stateVersion = "25.05";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  programs.home-manager.enable = true;
}
