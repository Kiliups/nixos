{
  pkgs,
  inputs,
  host,
  ...
}:
{
  imports = [
    ../default.nix
  ];

  targets.darwin.copyApps.enable = false;
  targets.darwin.linkApps.enable = true;

  home = {
    inherit (host) username;
    homeDirectory = "/Users/${host.username}";
    stateVersion = "26.11";
  };

  programs.home-manager.enable = true;

  # TODO remove pin once the opencode 1.18.30 prompt regression is fixed (anomalyco/opencode#48645)
  programs.opencode.package = inputs.nixpkgs-opencode.legacyPackages.${pkgs.system}.opencode;

  nixpkgs.config.allowUnfree = true;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    targets = {
      neovim.enable = false;
      vscode.enable = false;
      zed.enable = false;
    };
  };

  development = {
    git.enable = true;
    shell.enable = true;
    herdr.enable = true;
    tmux.enable = true;
    starship.enable = true;

    lazyvim.enable = true;
    vscode.enable = true;
    zed.enable = true;

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
