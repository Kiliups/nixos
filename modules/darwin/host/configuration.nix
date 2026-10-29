{
  host,
  hostName,
  ...
}:
{
  system = {
    stateVersion = 6;
    primaryUser = host.username;
    activationScripts.postActivation.text = ''
      /nix/var/nix/profiles/default/bin/nix-env \
        --profile /nix/var/nix/profiles/system \
        --delete-generations +5
      /nix/var/nix/profiles/default/bin/nix-collect-garbage || echo "warning: garbage collection failed; continuing activation" >&2
    '';
  };
  nixpkgs.hostPlatform = host.system;
  nixpkgs.config.allowUnfree = true;
  nix.enable = false;

  networking.hostName = hostName;
  networking.computerName = hostName;

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;
  system.defaults.CustomUserPreferences."com.apple.security.authorization".ignoreArd = true;

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    taps = [
      "michaelroosz/ssh"
      "theseal/ssh-askpass"
    ];
    casks = [
      "libsk-libfido2-install"
      "vorssaint"
      "tailscale-app"
    ];
  };

  system.activationScripts.preActivation.text = ''
    [ -x /opt/homebrew/bin/brew ] || echo "Homebrew is not installed. Install it manually from https://brew.sh, then rerun darwin-rebuild." >&2
  '';

  users.users.${host.username}.home = "/Users/${host.username}";
}
