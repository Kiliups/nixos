{ pkgs, ... }:
{
  imports = [
    ../common.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "rivendell";

  services.fwupd.enable = true;
}
