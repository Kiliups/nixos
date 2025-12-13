{ pkgs, ... }:
{
  imports = [
    ../common.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "minas-tirith";

}
