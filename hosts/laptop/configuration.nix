{ pkgs, ... }:
{
  imports = [
    ../common.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "rivendell";

  programs.hyprland = {
    enable = true;
  };

  services.fprintd.enable = true;

  # to fix sddm problems:
  security.pam.services.login.fprintAuth = false;

  services.fwupd.enable = true;

  services.ollama = {
    enable = true;
  };

  # eduroam setup scripts dependencies
  environment.systemPackages = with pkgs; [
    iw
    openssl
  ];
}
