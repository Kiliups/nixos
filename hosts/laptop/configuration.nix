{
  hostName,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    ../../modules/linux/kde.nix
  ];

  networking.hostName = hostName;

  programs.niri.enable = true;

  services.displayManager.defaultSession = "niri";

  xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" = "kde";

  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    ollama.enable = true;
  };

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
  ];
}
