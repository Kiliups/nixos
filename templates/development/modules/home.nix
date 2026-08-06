{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  development = {
    git.enable = true;

    shell.enable = true;
    starship.enable = true;

    herdr.enable = true;
    tmux.enable = true;

    lazyvim.enable = true;
    vscode.enable = false;
    zed.enable = false;

    claude.enable = true;
    codex.enable = true;
    cursor.enable = true;
    opencode.enable = true;

    languages = {
      angular.enable = true;
      astro.enable = true;
      c.enable = true;
      java.enable = true;
      nix.enable = true;
      php.enable = true;

      typescript = {
        enable = true;
        packages = with pkgs; [ yarn-berry ];
      };
    };
  };
}
