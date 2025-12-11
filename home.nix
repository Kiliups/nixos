{ ... }:
{
  imports = [
    ./modules/dev
    ./modules/programs.nix
    ./modules/shortcuts.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "25.11";

  stylix = {
    targets = {
      zen-browser.profileNames = [ "Default Profile" ];
      vscode.enable = false;
      vim.enable = false;
      neovim.enable = false;
      qt.enable = false;
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  programs.home-manager.enable = true;
}
