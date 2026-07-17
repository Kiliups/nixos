{ lib, ... }:
{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = false;
    enableAudioWavelength = false;
    enableCalendarEvents = false;
  };

  services.upower.enable = true;

  xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" = lib.mkForce "kde";

  systemd.user.services.dms = {
    environment.DMS_DISABLE_POLKIT = "1";
    unitConfig.ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
  };
}
