{
  host,
  hostName,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system = {
    stateVersion = 6;
    primaryUser = host.username;
    activationScripts.postActivation.text = ''
      /nix/var/nix/profiles/default/bin/nix-env \
        --profile /nix/var/nix/profiles/system \
        --delete-generations +5
      /nix/var/nix/profiles/default/bin/nix-collect-garbage
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

  # install homebrew
  system.activationScripts.preActivation.text = ''
    if [ ! -x /opt/homebrew/bin/brew ]; then
      echo "Installing Homebrew..." >&2
      mkdir -p /opt/homebrew
      curl -fsSL https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C /opt/homebrew
      chown -R ${host.username}:admin /opt/homebrew
    fi
  '';

  users.users.${host.username} = {
    name = host.username;
    home = "/Users/${host.username}";
  };
}
