{ pkgs, ... }:
{
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland,x11";
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      OZONE_PLATFORM = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

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

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    desktopManager.plasma6.enable = true;
  };
}
