{ pkgs, host, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  targets.darwin.copyApps.enable = false;

  home = {
    inherit (host) username;
    homeDirectory = "/Users/${host.username}";
    stateVersion = "26.11";
  };

  programs.home-manager.enable = true;
  #TODO
  programs.zsh.shellAliases.opcw = "OPENCODE_CONFIG=$HOME/.config/opencode/work.json opencode";

  nixpkgs.config.allowUnfree = true;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    targets.vscode.enable = false;
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
    pi.enable = false;
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
