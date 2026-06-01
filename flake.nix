{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
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
      ...
    }:
    let
      darwinHost = {
        kilian-mayer = {
          username = "user";
          name = "Public User";
          email = "user@example.invalid";
          system = "aarch64-darwin";
        };
      };

      mkDarwinHost =
        hostName: host:
        nix-darwin.lib.darwinSystem {
          system = host.system;
          specialArgs = {
            inherit inputs host hostName;
          };
          modules = [
            stylix.darwinModules.stylix
            ./hosts/darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup-" + toString builtins.currentTime;
                extraSpecialArgs = {
                  inherit inputs host;
                };

                users.${host.username}.imports = [
                  stylix.homeModules.stylix
                  ./hosts/darwin/home.nix
                ];
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = nixpkgs.lib.mapAttrs mkDarwinHost darwinHost;

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            stylix.nixosModules.stylix
            ./hosts/laptop/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup-" + toString builtins.currentTime;

                users.user = {
                  imports = [
                    plasma-manager.homeModules.plasma-manager
                    zen-browser.homeModules.default
                    ./hosts/laptop/home.nix
                  ];
                };
              };
            }
          ];
        };
        workstation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            stylix.nixosModules.stylix
            ./hosts/workstation/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup-" + toString builtins.currentTime;

                users.user = {
                  imports = [
                    plasma-manager.homeModules.plasma-manager
                    zen-browser.homeModules.default
                    ./hosts/home.nix
                  ];
                };
              };
            }
          ];
        };
      };
      templates = {
        python = {
          path = ./templates/python;
          description = "Python development environment with venv support";
        };
      };
    };
}
