{ ... }:
{
  imports = [
    ../../modules/dev
    ../../modules/programs.nix
    ../../modules/plasma.nix
  ];

  home.stateVersion = "25.11";
  home.username = "kiliups";
  home.homeDirectory = "/home/kiliups";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

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
