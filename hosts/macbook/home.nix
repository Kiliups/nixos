{ ... }:
{
  imports = [
    ../../modules/darwin
  ];

  home.stateVersion = "26.05";
  home.username = "user";
  home.homeDirectory = "/Users/user";

  programs.home-manager.enable = true;
}
