{ username, darwinSystem, ... }:
{
  system = {
    primaryUser = username;
    stateVersion = 6;
  };

  nixpkgs = {
    hostPlatform = darwinSystem;
    config.allowUnfree = true;
  };

  nix.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  users.users.${username}.home = "/Users/${username}";
}
