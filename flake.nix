{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      home-manager,
    }:
    {
      nixosConfigurations.user-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";

              users.user = {
                imports = [
                  ./home.nix
                  catppuccin.homeModules.catppuccin
                ];
              };

              users.leonie = {
                imports = [
                  ./leonie.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
            };
          }
        ];
      };
    };
}
