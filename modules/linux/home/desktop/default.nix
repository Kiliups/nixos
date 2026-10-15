{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./config.nix
    ./mime.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
    kdePackages.kirigami.unwrapped
    kdePackages.qqc2-desktop-style
    kooha
    satty
  ];

  systemd.user.services = {
    niri-kbuildsycoca = {
      Unit = {
        Description = "Refresh KDE application metadata for Niri";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
      };
      Service = {
        Type = "oneshot";
        Environment = "XDG_MENU_PREFIX=plasma-";
        ExecStart = "${lib.getExe' pkgs.kdePackages.kservice "kbuildsycoca6"} --noincremental";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  gtk.enable = true;

  stylix = {
    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    targets = {
      kde.enable = false;
      qt.enable = false;
      zed.enable = false;
    };
  };

  qt = {
    enable = true;
    platformTheme = {
      name = "kde";
      package = [
        pkgs.kdePackages.plasma-integration
        pkgs.kdePackages.plasma-integration.qt5
      ];
    };
    style.name = "breeze";
    kde.settings.kdeglobals = {
      General.ColorScheme = "BreezeDark";
      Icons.Theme = config.gtk.iconTheme.name;
    };
  };

  xdg.configFile."niri/cfg/autostart.kdl".text = "// Session services are managed by systemd.";
}
