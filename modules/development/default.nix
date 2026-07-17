{ config, lib, ... }:
{
  imports = [
    ./agents.nix
    ./git.nix
    ./neovim.nix
    ./shell.nix
    ./starship.nix
    ./tmux.nix
    ./vscode.nix
    ./zed.nix
    ./languages
  ];

  options.development.full.enable = lib.mkEnableOption "full development environment";

  config = lib.mkIf config.development.full.enable {
    development = {
      shell.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      lazyvim.enable = lib.mkDefault true;
      vscode.enable = lib.mkDefault true;
      zed.enable = lib.mkDefault true;
    };

    languages = {
      angular.enable = lib.mkDefault true;
      astro.enable = lib.mkDefault true;
      go.enable = lib.mkDefault true;
      java.enable = lib.mkDefault true;
      php.enable = lib.mkDefault true;
      python.enable = lib.mkDefault true;
      rust.enable = lib.mkDefault true;
      svelte.enable = lib.mkDefault true;
      typescript.enable = lib.mkDefault true;
      typst.enable = lib.mkDefault true;
      vue.enable = lib.mkDefault true;
    };
  };
}
