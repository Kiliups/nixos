{
  description = "Home Manager configuration built on the development module";

  inputs = {
    nixos.url = "github:kiliups/nixos";
    nixpkgs.follows = "nixos/nixpkgs";
    home-manager.follows = "nixos/home-manager";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nixos,
      ...
    }:
    let
      system = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      username = "me";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nixos.homeModules.development
          ./modules/home.nix
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
              stateVersion = "26.11";
            };
          }
        ];
      };

      darwinConfigurations.${username} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        specialArgs = { inherit username darwinSystem; };
        modules = [
          ./darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.users.${username} = {
              imports = [
                nixos.homeModules.development
                ./modules/home.nix
              ];

              home = {
                inherit username;
                homeDirectory = "/Users/${username}";
                stateVersion = "26.11";
              };
            };
          }
        ];
      };

      packages.${system}.development-options = nixos.packages.${system}.development-options;
      packages.${darwinSystem}.development-options = nixos.packages.${darwinSystem}.development-options;
    };
}
