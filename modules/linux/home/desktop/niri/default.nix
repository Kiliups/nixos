{ lib, pkgs, ... }:
{
  imports = [
    ./config.nix
    ./mime.nix
    ./shell.nix
  ];

  home.packages = with pkgs; [
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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  xdg.configFile."niri/cfg/autostart.kdl".text = "// Session services are managed by systemd.";
}
