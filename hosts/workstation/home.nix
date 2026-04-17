{ ... }:
{
  imports = [
    ../../modules/linux
  ];

  home.stateVersion = "26.05";
  home.username = "kiliups";
  home.homeDirectory = "/home/kiliups";

  stylix = {
    targets = {
      zen-browser.profileNames = [ "Default Profile" ];
      vscode.enable = false;
      vim.enable = false;
      neovim.enable = false;
    };
  };

  programs.home-manager.enable = true;
}
