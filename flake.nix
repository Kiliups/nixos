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
            home-manager.users.user = {
              imports = [
                ./home.nix
                catppuccin.homeModules.catppuccin
              ];
            };
            home-manager.users.leonie = {
              imports = [
                ./leonie.nix
                catppuccin.homeModules.catppuccin
              ];
            };
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
