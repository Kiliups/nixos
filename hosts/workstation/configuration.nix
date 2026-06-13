{ hostName, ... }:
{
  imports = [
    ../common.nix
  ];

  networking.hostName = hostName;

}
