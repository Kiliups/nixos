{ pkgs, ... }:
{
  imports = [
    ../../modules/dev
    ../../modules/programs.nix
    ../../modules/plasma.nix
    ../../modules/hypr/default.nix
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
      qt.enable = false;
    };
  };

  programs.home-manager.enable = true;
}
