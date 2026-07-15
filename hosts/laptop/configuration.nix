{
  hostName,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    ../../modules/linux/plasma/desktop.nix
  ];

  networking.hostName = hostName;

  programs.niri.enable = true;

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
