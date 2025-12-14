{ pkgs, ... }:
{
  imports = [
    ../common.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "laptop";

  services.fprintd.enable = true;
  services.fwupd.enable = true;
}
