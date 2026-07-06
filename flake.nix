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
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tpm = {
      url = "github:tmux-plugins/tpm";
      flake = false;
    };
    ponytail = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
    };
    nixos-private = {
      url = "path:./private.example";
      flake = true;
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
      nixos-private,
      tpm,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      darwinHosts = nixos-private.darwinHosts or { };
      nixosHosts = nixos-private.nixosHosts or { };

      nixosRoleModules = {
        laptop = ./hosts/laptop/configuration.nix;
        workstation = ./hosts/workstation/configuration.nix;
      };

      homeRoleModules = {
        laptop = ./hosts/laptop/home.nix;
        workstation = ./hosts/workstation/home.nix;
      };

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
          ]
          ++ (host.modules or [ ])
          ++ [
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs host tpm;
                };

                users.${host.username} = {
                  imports = [
                    stylix.homeModules.stylix
                    ./hosts/darwin/home.nix
                  ]
                  ++ (host.homeModules or [ ]);
                };
              };
            }
          ];
        };

      mkNixosHost =
        hostName: host:
        let
          roleModule = nixosRoleModules.${host.type} or (throw "Unknown NixOS host type: ${host.type}");
          homeRoleModule =
            homeRoleModules.${host.type} or (throw "Unknown NixOS home host type: ${host.type}");
        in
        nixpkgs.lib.nixosSystem {
          inherit (host) system;
          specialArgs = {
            inherit inputs host hostName;
          };
          modules = [
            stylix.nixosModules.stylix
            roleModule
          ]
          ++ (host.modules or [ ])
          ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs host tpm;
                };

                users.${host.username} = {
                  imports = [
                    plasma-manager.homeModules.plasma-manager
                    zen-browser.homeModules.default
                    inputs.noctalia-shell.homeModules.default
                    homeRoleModule
                  ]
                  ++ (host.homeModules or [ ]);
                };
              };
            }
          ]
          ++ lib.optional (host.type == "laptop") nixos-hardware.nixosModules.framework-13-7040-amd;
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
          description = "Python development shell with uv";
        };
      };
    };
}
