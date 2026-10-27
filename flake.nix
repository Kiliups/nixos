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
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    rea = {
      url = "github:morluto/rea";
      flake = false;
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
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
      nixos-private,
      cursor-plugins,
      anthropic-skills,
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
          inherit (inputs)
            ponytail
            matt-pocock-skills
            cursor-plugins
            anthropic-skills
            rea
            llm-agents
            ;
        };
      };
      developmentCache = import ./modules/development/cache.nix;

      developmentOptionsText = import ./templates/development/modules/options.nix {
        inherit nixpkgs home-manager;
        development = developmentModule;
      };

      developmentOptions = pkgs: pkgs.writeText "DEVELOPMENT_OPTIONS.md" developmentOptionsText;

      developmentOptionsModule =
        { pkgs, ... }:
        {
          environment.systemPackages = [
            (pkgs.writeTextDir "share/doc/development/DEVELOPMENT_OPTIONS.md" developmentOptionsText)
          ];
        };

      mkHome = host: imports: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          extraSpecialArgs = { inherit host; };
          users.${host.username}.imports = [ developmentModule ] ++ imports ++ (host.homeModules or [ ]);
        };
      };

      nixosHomeModules = [
        zen-browser.homeModules.default
        ./modules/linux/hosts/home.nix
      ];

      mkDarwinHost =
        hostName: host:
        nix-darwin.lib.darwinSystem {
          inherit (host) system;
          specialArgs = { inherit host hostName; };
          modules = [
            developmentCache.darwin
            ./modules/darwin/host/configuration.nix
            developmentOptionsModule
            home-manager.darwinModules.home-manager
            (mkHome host [
              stylix.homeModules.stylix
              ./modules/darwin/host/home.nix
            ])
          ]
          ++ (host.modules or [ ]);
        };

      mkNixosHost =
        hostName: host:
        nixpkgs.lib.nixosSystem {
          inherit (host) system;
          specialArgs = { inherit host; };
          modules = [
            stylix.nixosModules.stylix
            developmentCache.nixos
            ./modules/linux/hosts/${host.type}/configuration.nix
            developmentOptionsModule
            { networking.hostName = hostName; }
            home-manager.nixosModules.home-manager
            (mkHome host nixosHomeModules)
          ]
          ++ (host.modules or [ ])
          ++ lib.optional (host.type == "laptop") nixos-hardware.nixosModules.framework-13-7040-amd;
        };

      realNixosConfigurations = nixpkgs.lib.mapAttrs mkNixosHost nixosHosts;
    in
    {
      packages = lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          development-options = developmentOptions pkgs;
          zed-editor = pkgs.callPackage ./packages/zed-editor { };
        }
      );

      homeModules = {
        development = developmentModule;
        default = developmentModule;
      };

      nixosModules.developmentCache = developmentCache.nixos;
      darwinModules.developmentCache = developmentCache.darwin;

      darwinConfigurations = nixpkgs.lib.mapAttrs mkDarwinHost darwinHosts;

      nixosConfigurations = realNixosConfigurations // {
        iso = nixpkgs.lib.nixosSystem {
          inherit (isoHost) system;
          specialArgs.host = isoHost;
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            stylix.nixosModules.stylix
            developmentCache.nixos
            ./modules/linux/hosts/common.nix
            developmentOptionsModule
            { boot.loader.timeout = lib.mkForce 10; }
            home-manager.nixosModules.home-manager
            (mkHome isoHost nixosHomeModules)
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
