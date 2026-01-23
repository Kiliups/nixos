{ pkgs, ... }:
{
  imports = [
    ../common.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "rivendell";

  services.fprintd.enable = true;

  # to fix sddm problems:
  security.pam.services.login.fprintAuth = false;

  services.fwupd.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama;
  };

  # eduroam setup scripts dependencies
  environment.systemPackages = with pkgs; [
    iw
    openssl
  ];
}
