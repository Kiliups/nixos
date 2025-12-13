{ pkgs, ... }:
{
  imports = [
    ../common.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "laptop";

  services.fwupd.enable = true;
}
