{
  hostName,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    ../../modules/linux/desktop/plasma.nix
  ];

  networking.hostName = hostName;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # steam and gaming
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      mangohud
      protonup-ng
    ];

    sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
