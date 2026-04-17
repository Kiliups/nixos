{ ... }:
{
  imports = [
    ../../modules/darwin
  ];

  home.stateVersion = "26.05";
  home.username = "kilian.mayer";
  home.homeDirectory = "/Users/kilian.mayer";

  programs.home-manager.enable = true;
}
