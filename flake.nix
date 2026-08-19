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
    ponytail = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
    };
    matt-pocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    cursor-plugins = {
      url = "github:cursor/plugins";
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
      cursor-plugins,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      darwinHosts = nixos-private.darwinHosts or { };
      nixosHosts = nixos-private.nixosHosts or { };
      isoHost = {
        username = "kiliups";
        name = "Kilian Mayer";
        email = "mayer-kilian@gmx.de";
        system = "x86_64-linux";
      };

      developmentModule = {
        imports = [ ./modules/development ];

        _module.args.agentSources = {
          inherit (inputs) ponytail matt-pocock-skills cursor-plugins;
        };
        _module.args.tmuxTpm = tpm;
      };

      developmentOptions =
        pkgs:
        pkgs.writeText "DEVELOPMENT_OPTIONS.md" (
          import ./templates/development/modules/options.nix {
            inherit nixpkgs home-manager;
            development = developmentModule;
          }
        );

      developmentOptionsPackage =
        pkgs:
        pkgs.runCommand "development-options" { } ''
          mkdir -p "$out/share/doc/development"
          cp ${developmentOptions pkgs} "$out/share/doc/development/DEVELOPMENT_OPTIONS.md"
        '';

      developmentOptionsModule =
        { pkgs, ... }:
        {
          environment.systemPackages = [ (developmentOptionsPackage pkgs) ];
        };

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
            developmentOptionsModule
          ]
          ++ (host.modules or [ ])
          ++ [
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs host;
                };

                users.${host.username} = {
                  imports = [
                    stylix.homeModules.stylix
                    developmentModule
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
          ]
          ++ [ roleModule ]
          ++ [ developmentOptionsModule ]
          ++ (host.modules or [ ])
          ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs host;
                };

                users.${host.username} = {
                  imports = [
                    plasma-manager.homeModules.plasma-manager
                    zen-browser.homeModules.default
                  ]
                  ++ [
                    developmentModule
                    homeRoleModule
                  ]
                  ++ (host.homeModules or [ ]);
                };
              };
            }
          ]
          ++ lib.optional (host.type == "laptop") nixos-hardware.nixosModules.framework-13-7040-amd;
        };

      realNixosConfigurations = nixpkgs.lib.mapAttrs mkNixosHost nixosHosts;
    in
    {
      packages = lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: {
        development-options = developmentOptions (import nixpkgs { inherit system; });
      });

      homeModules = {
        development = developmentModule;
        default = developmentModule;
      };

      darwinConfigurations = nixpkgs.lib.mapAttrs mkDarwinHost darwinHosts;

      nixosConfigurations = realNixosConfigurations // {
        iso = nixpkgs.lib.nixosSystem {
          inherit (isoHost) system;
          specialArgs = {
            inherit inputs;
            host = isoHost;
            hostName = "nixos-iso";
          };
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            stylix.nixosModules.stylix
            ./hosts/common.nix
            developmentOptionsModule
            { boot.loader.timeout = lib.mkForce 10; }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs;
                  host = isoHost;
                };

                users.${isoHost.username} = {
                  imports = [
                    plasma-manager.homeModules.plasma-manager
                    zen-browser.homeModules.default
                    developmentModule
                    ./hosts/home.nix
                  ];
                };
              };
            }
          ];
        };
      };

      templates = {
        development = {
          path = ./templates/development;
          description = "Home Manager flake built on the development module";
        };

        python = {
          path = ./templates/python;
          description = "Python development shell with uv";
        };
      };
    };
}
