{ pkgs, ... }:
{
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      discover
    ];

    systemPackages = with pkgs; [
      kdePackages.partitionmanager
      kdePackages.kate
    ];
  };

  security.pam.services.sddm.kwallet.enable = true;

  services.desktopManager.plasma6.enable = true;
}
