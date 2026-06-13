{ hostName, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];

  networking.hostName = hostName;

  boot = {
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.udev.log_level=3"
    ];
    loader.timeout = 0;
  };

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
