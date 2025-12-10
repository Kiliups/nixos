{ ... }:
{
  imports = [
    ./modules/dev
    ./modules/programs.nix
    ./modules/shortcuts.nix
  ];

  home.username = "kiliups";
  home.homeDirectory = "/home/kiliups";
  home.stateVersion = "25.11";

  stylix = {
    targets = {
      zen-browser.profileNames = [ "Default Profile" ];
      vscode.enable = false;
      vim.enable = false;
      neovim.enable = false;
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  programs.home-manager.enable = true;
}
