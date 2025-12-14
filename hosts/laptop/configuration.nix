{ pkgs, ... }:
{
  imports = [
    ../common.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "rivendell";

  services.fprintd.enable = true;
  services.fwupd.enable = true;
}
