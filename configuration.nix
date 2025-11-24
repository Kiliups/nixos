{ pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  }) { config.allowUnfree = true; };
in
{
  imports = [
    ./hardware-configuration.nix
    "${home-manager}/nixos"
  ];

  home-manager.users.kiliups = import ./home.nix;
  home-manager.extraSpecialArgs = {
    pkgs = unstable;
  };
  home-manager.backupFileExtension = "backup";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Bootloader.
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    theme = pkgs.stdenv.mkDerivation {
      name = "catppuccin-frappe";
      src = ./.config/catppuccin-frappe-grub;
      installPhase = ''
        mkdir -p $out
        cp -r * $out/
      '';
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kiliups-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ konsole ];
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.kiliups = {
    isNormalUser = true;
    description = "Kilian Mayer";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [ kdePackages.kate ];
  };
  
  # Enable Doocker
  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ kdePackages.partitionmanager ];

  system.activationScripts.nixos-config = ''
    chown -R kiliups:users /etc/nixos
    chmod -R 755 /etc/nixos
  '';

  services.flatpak.enable = true;
  system.activationScripts.zen = ''
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 
    if ! ${pkgs.flatpak}/bin/flatpak info app.zen_browser.zen >/dev/null 2>&1; then
      ${pkgs.flatpak}/bin/flatpak install -y flathub app.zen_browser.zen
    fi
    ${pkgs.flatpak}/bin/flatpak update -y
  '';

  system.stateVersion = "25.05";

}
