{ pkgs, ... }:
{
  boot = {
    # boot
    loader = {
      systemd-boot = {
        configurationLimit = 5;
        enable = false;
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        theme = ../config/catppuccin-macchiato-grub-theme;
        splashImage = ../config/catppuccin-macchiato-grub-theme/background.png;
      };

      efi.canTouchEfiVariables = true;
    };

    # kernel
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # nix settings
  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flake = "~/.config/nixos";
    flags = [
      "--recreate-lock-file"
    ];
    allowReboot = false;
  };

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

  system.stateVersion = "25.11";

  # theming
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    image = ../config/wallpaper.png;
    polarity = "dark";
    targets = {
      grub.enable = false;
    };
  };

  # I/O
  networking.networkmanager.enable = true;

  security.pam.services.sddm.kwallet.enable = true;

  environment = {
    # Fix scaling for vscode
    sessionVariables = {
      NIXOS_OZONE_WL = "1";

      # GTK apps
      GDK_BACKEND = "wayland,x11,*";

      # Qt apps
      QT_QPA_PLATFORM = "wayland;xcb";
      # SDL apps
      SDL_VIDEODRIVER = "wayland,x11";

      # Firefox / Mozilla
      MOZ_ENABLE_WAYLAND = "1";

      # Electron / Chromium
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      OZONE_PLATFORM = "wayland";

      # General session hint
      XDG_SESSION_TYPE = "wayland";
    };

    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      discover
    ];

    # system packages
    systemPackages = with pkgs; [
      kdePackages.partitionmanager
    ];
  };

  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing.enable = true;

    xserver.xkb = {
      layout = "de";
      variant = "";
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    desktopManager.plasma6.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Internationalization
  time.timeZone = "Europe/Berlin";
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

  console.keyMap = "de";

  # fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  users.users.user = {
    isNormalUser = true;
    description = "Public User";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
