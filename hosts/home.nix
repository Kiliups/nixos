{ ... }:
{
  imports = [
    ../modules/linux
  ];

  home = {
    stateVersion = "26.05";
    username = "user";
    homeDirectory = "/home/user";
  };

  stylix = {
    targets = {
      zen-browser.profileNames = [ "Default Profile" ];
      vscode.enable = false;
      qt.enable = false;
    };
  };

  programs.home-manager.enable = true;
}
