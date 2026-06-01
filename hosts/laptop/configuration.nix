{ pkgs, ... }:
{
  imports = [
    ../common.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "laptop";

  programs.niri = {
    enable = true;
  };

  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    ollama.enable = true;
  };

  # to fix sddm problems:
  security.pam.services.login.fprintAuth = false;

  # eduroam setup scripts dependencies
  environment.systemPackages = with pkgs; [
    iw
    openssl
  ];
}
