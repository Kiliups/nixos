{ lib, pkgs, ... }:
let
  dms = lib.getExe pkgs.dms-shell;
  lock = "${dms} ipc call lock lock";
in
{
  services.swayidle = {
    enable = true;
    events.before-sleep = lock;
    timeouts = [
      {
        timeout = 900;
        command = lock;
      }
      {
        timeout = 1800;
        command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
        resumeCommand = "${lib.getExe pkgs.niri} msg action power-on-monitors";
      }
      {
        timeout = 3600;
        command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
      }
      {
        timeout = 14400;
        command = "${lib.getExe' pkgs.systemd "systemctl"} poweroff";
      }
    ];
  };

  systemd.user.services.swayidle.Unit.ConditionEnvironment = lib.mkForce [
    "WAYLAND_DISPLAY"
    "XDG_CURRENT_DESKTOP=niri"
  ];
}
