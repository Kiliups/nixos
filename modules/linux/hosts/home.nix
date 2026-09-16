{
  pkgs,
  host,
  inputs,
  ...
}:
{
  imports = [
    ../../apps
    ../home/terminal.nix
    ../home/desktop
  ];

  home = {
    inherit (host) username;
    homeDirectory = "/home/${host.username}";
  };

  nixpkgs.config.allowUnfree = true;

  stylix = {
    targets = {
      zen-browser.profileNames = [ "Default Profile" ];
      vscode.enable = false;
      zed.enable = false;
    };
  };

  programs.home-manager.enable = true;

  # TODO remove pin once the opencode 1.18.30 prompt regression is fixed (anomalyco/opencode#48645)
  programs.opencode.package = inputs.nixpkgs-opencode.legacyPackages.${pkgs.system}.opencode;

  development = {
    full.enable = true;
    claude.enable = false;
    codex.enable = true;
    cursor.enable = false;
    opencode.enable = true;

    languages.typescript.packages = with pkgs; [ bun ];
  };

  home.packages = with pkgs; [
    bruno
    dbeaver-bin

    # vpn
    wireguard-tools

    # image and video
    ffmpeg-full

    #pdf
    poppler-utils

    # TODO eval
    pi-coding-agent

    # TODO eval
    t3code
  ];
}
