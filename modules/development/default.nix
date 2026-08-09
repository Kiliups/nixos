{ config, lib, ... }:
{
  imports = [
    ./agents.nix
    ./git.nix
    ./herdr.nix
    ./neovim.nix
    ./shell.nix
    ./starship.nix
    ./tmux.nix
    ./vscode.nix
    ./zed.nix
    ./languages
  ];

  options.development = {
    full.enable = lib.mkEnableOption "development.git, development.shell, development.herdr, development.tmux, development.starship, development.lazyvim, development.vscode, development.zed, and every built-in language; C and Nix are enabled by default, while Claude Code, Codex, Cursor, and OpenCode remain disabled";

  };

  config = lib.mkIf config.development.full.enable {
    development = {
      git.enable = lib.mkDefault true;
      shell.enable = lib.mkDefault true;
      herdr.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      lazyvim.enable = lib.mkDefault true;
      vscode.enable = lib.mkDefault true;
      zed.enable = lib.mkDefault true;
    };
  };
}
