{ pkgs, ... }:
{
  imports = [
    ../common.nix
    ../../modules/dev/vm.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "rivendell";

  services.fprintd.enable = true;
  # to fix sddm problems:
  security.pam.services.login.fprintAuth = false;

  services.fwupd.enable = true;
}
