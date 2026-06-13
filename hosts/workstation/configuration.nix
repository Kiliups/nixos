{ hostName, ... }:
{
  imports = [
    ../common.nix
    ../../modules/linux/kde.nix
  ];

  networking.hostName = hostName;
}
