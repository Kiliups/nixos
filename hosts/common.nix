{ host, pkgs, ... }:
{
  boot.loader = {
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

  nixpkgs.config.allowUnfree = true;

  system = {
    autoUpgrade = {
      enable = true;
      dates = "daily";
      flake = "/home/${host.username}/.config/nixos";
      flags = [
        "--update-input"
        "nixpkgs"
        "--override-input"
        "nixos-private"
        "path:/home/${host.username}/.config/nixos/private"
      ];
      allowReboot = false;
    };

    stateVersion = "25.11";
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    image = ../config/wallpaper.png;
    polarity = "dark";
    targets = {
      grub.enable = false;
      kmscon.enable = false;
    };
  };

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openvpn ];
  };

  networking.firewall.checkReversePath = "loose";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    OZONE_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber.extraConfig."51-audio-device-priorities" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "media.class" = "Audio/Sink";
                "node.name" = "~alsa_output.*analog-stereo";
              }
              {
                "media.class" = "Audio/Source";
                "node.name" = "~alsa_input.*analog-stereo";
              }
            ];
            actions.update-props."priority.session" = 3000;
          }
        ];

        "monitor.bluez.rules" = [
          {
            matches = [
              {
                "media.class" = "Audio/Sink";
                "node.name" = "~bluez_output.*";
              }
              {
                "media.class" = "Audio/Source";
                "node.name" = "~bluez_input.*";
              }
            ];
            actions.update-props."priority.session" = 4000;
          }
        ];
      };
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
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "de_DE.UTF-8";
    extraLocaleSettings = {
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
  };

  console.keyMap = "de";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  users.users.${host.username} = {
    isNormalUser = true;
    description = host.name;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };
}
