{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    {
      nixpkgs,
      nixos-hardware,
      home-manager,
      stylix,
      zen-browser,
      plasma-manager,
      ...
    }:
    {

      nixosConfigurations = {
        rivendell = nixpkgs.lib.nixosSystem {
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
                backupFileExtension = "backup-" + builtins.toString builtins.currentTime;
                
                users.kiliups = {
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
        minas-tirith = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            stylix.nixosModules.stylix
            ./hosts/workstation/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup-" + builtins.toString builtins.currentTime;
                
                users.kiliups = {
                  imports = [
                    plasma-manager.homeModules.plasma-manager
                    zen-browser.homeModules.default
                    ./hosts/workstation/home.nix
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
