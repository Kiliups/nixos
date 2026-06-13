{ host, ... }:
{
  imports = [
    ../modules/linux
  ];

  home = {
    stateVersion = "26.05";
    inherit (host) username;
    homeDirectory = "/home/${host.username}";
  };

  nixpkgs.config.allowUnfree = true;

  stylix = {
    targets = {
      zen-browser.profileNames = [ "Default Profile" ];
      vscode.enable = false;
      qt.enable = false;
    };
  };

  programs.home-manager.enable = true;
}
