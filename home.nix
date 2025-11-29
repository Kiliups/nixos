{ pkgs, ... }:
{
  imports = [
    ./modules/dev/index.nix
    ./modules/programs.nix
  ];
  nixpkgs.config.allowUnfree = true;

  catppuccin.enable = true;
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "lavender";
  catppuccin.vscode.enable = false;

  home.packages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "macchiato" ];
      accents = [ "lavender" ];
    })
  ];

  home.username = "kiliups";
  home.homeDirectory = "/home/kiliups";
  home.stateVersion = "25.05";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  programs.home-manager.enable = true;
}
