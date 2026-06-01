{ host, hostName, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = 6;
  nixpkgs.hostPlatform = host.system;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostName;
  networking.computerName = hostName;

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  users.users.${host.username} = {
    name = host.username;
    home = "/Users/${host.username}";
  };
}
