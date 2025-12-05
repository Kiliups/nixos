{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    pomodoro = {
      url = "github:Kiliups/pomodoro-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      stylix,
      zen-browser,
      pomodoro,
      ...
    }:
    {

      nixosConfigurations.kiliups-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          stylix.nixosModules.stylix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup-" + builtins.toString builtins.currentTime;
              extraSpecialArgs = {
                inherit pomodoro;
              };

              users.kiliups = {
                imports = [
                  zen-browser.homeModules.default
                  ./home.nix
                ];
              };
            };
          }
        ];
      };
    };
}
