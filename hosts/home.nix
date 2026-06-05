{ host, ... }:
{
  imports = [
    ../modules/linux
  ];

  home = {
    stateVersion = "26.11";
    inherit (host) username;
    homeDirectory = "/home/${host.username}";
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
