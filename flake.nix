{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    tpm = {
      url = "github:tmux-plugins/tpm";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixos-hardware,
      home-manager,
      nix-darwin,
      stylix,
      zen-browser,
      plasma-manager,
      tpm,
      ...
    }:
    let
      privateEnv = builtins.getEnv "NIXOS_PRIVATE_CONFIG";
      privatePath =
        if privateEnv != "" then
          /. + privateEnv
        else
          /. + "${builtins.getEnv "PWD"}/hosts/private.nix";
      hosts =
        if builtins.pathExists privatePath then
          import privatePath
        else
          {
            darwinHosts = { };
            nixosHosts = { };
          };
      inherit (hosts) darwinHosts nixosHosts;

      mkDarwinHost =
        hostName: host:
        nix-darwin.lib.darwinSystem {
          inherit (host) system;
          specialArgs = {
            inherit inputs host hostName;
          };
          modules = [
            stylix.darwinModules.stylix
            ./hosts/darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs host tpm;
                };

                users.${host.username} = {
                  nixpkgs.config.allowUnfree = true;
                  imports = [
                    stylix.homeModules.stylix
                    ./hosts/darwin/home.nix
                  ];
                };
              };
            }
          ];
        };

      mkNixosHost =
        hostName: host:
        nixpkgs.lib.nixosSystem {
          inherit (host) system;
          specialArgs = {
            inherit inputs host hostName;
          };
          modules = [
            stylix.nixosModules.stylix
            (
              if host.type == "laptop" then
                ./hosts/laptop/configuration.nix
              else
                ./hosts/workstation/configuration.nix
            )
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                backupFileExtension = "backup-" + toString builtins.currentTime;
                extraSpecialArgs = {
                  inherit inputs host tpm;
                };

                users.${host.username} = {
                  nixpkgs.config.allowUnfree = true;
                  imports = [
                    plasma-manager.homeModules.plasma-manager
                    zen-browser.homeModules.default
                    (if host.type == "laptop" then ./hosts/laptop/home.nix else ./hosts/home.nix)
                  ];
                };
              };
            }
          ]
          ++ nixpkgs.lib.optional (host.type == "laptop") nixos-hardware.nixosModules.framework-13-7040-amd;
        };
    in
    {
      homeModules = {
        development = ./modules/development;
      };

      darwinConfigurations = nixpkgs.lib.mapAttrs mkDarwinHost darwinHosts;

      nixosConfigurations = nixpkgs.lib.mapAttrs mkNixosHost nixosHosts;

      templates = {
        python = {
          path = ./templates/python;
          description = "Python development environment with venv support";
        };
      };
    };
}
