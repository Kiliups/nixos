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
  };
  nixpkgs.hostPlatform = host.system;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostName;
  networking.computerName = hostName;

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    taps = [
      "michaelroosz/ssh"
      "theseal/ssh-askpass"
    ];
    casks = [
      "libsk-libfido2-install"
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
