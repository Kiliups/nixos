{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  users.users."user" = {
    home = "/Users/user";
  };

  system.primaryUser = "user";

  system.stateVersion = 6;
}
