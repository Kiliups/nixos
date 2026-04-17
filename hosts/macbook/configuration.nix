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

  users.users."kilian.mayer" = {
    home = "/Users/kilian.mayer";
  };

  system.primaryUser = "kilian.mayer";

  system.stateVersion = 6;
}
