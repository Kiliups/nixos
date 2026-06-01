{ host, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = 6;
  nixpkgs.hostPlatform = host.system;

  networking.hostName = host.username;
  networking.computerName = host.username;

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${host.username} = {
    name = host.username;
    home = "/Users/${host.username}";
  };
}
