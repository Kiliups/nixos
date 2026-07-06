{
  hostName,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
  ];

  networking.hostName = hostName;

  programs.niri.enable = true;

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
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ffmpegthumbs
    kdePackages.filelight
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kio-extras
    kdePackages.okular
    kdePackages.partitionmanager
    kdePackages.spectacle
  ];
}
