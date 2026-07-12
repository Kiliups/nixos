{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../home.nix
    ../../modules/linux/plasma.nix
    ../../modules/linux/tiling
  ];

  services.swayidle = {
    enable = true;
    events.before-sleep = "${lib.getExe config.programs.noctalia-shell.package} ipc call lockScreen lock";
    timeouts = [
      {
        timeout = 900;
        command = "${lib.getExe config.programs.noctalia-shell.package} ipc call lockScreen lock";
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

}
