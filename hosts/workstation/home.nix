{ ... }:
{
  imports = [
    ../../modules/linux
  ];

  home.stateVersion = "26.05";
  home.username = "user";
  home.homeDirectory = "/home/user";

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
