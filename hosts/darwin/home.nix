{ pkgs, host, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  targets.darwin.copyApps.enable = true;
  targets.darwin.copyApps.enableChecks = false;

  home = {
    inherit (host) username;
    homeDirectory = "/Users/${host.username}";
    stateVersion = "26.11";
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    targets.vscode.enable = false;
    targets.zed.enable = false;
  };

  development = {
    shell.enable = true;
    tmux.enable = true;
    starship.enable = true;
    lazyvim.enable = true;
    vscode.enable = true;
    claude.enable = true;
    codex.enable = true;
    cursor.enable = true;
    opencode.enable = true;
    zed.enable = true;
  };

  languages = {
    angular.enable = true;
    astro.enable = true;
    java.enable = true;
    php.enable = true;
    typescript = {
      enable = true;
      extraPackages = with pkgs; [ yarn-berry ];
    };
  };
}
