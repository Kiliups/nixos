{
  pkgs,
  host,
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
    stateVersion = "26.11";
  };

  stylix = {
    targets = {
      rofi.enable = false;
      zen-browser.profileNames = [ "Default Profile" ];
      tmux.enable = false;
      vscode.enable = false;
      zed.enable = false;
    };
  };

  programs.home-manager.enable = true;

  development = {
    full.enable = true;
    claude.enable = true;
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
  ];
}
