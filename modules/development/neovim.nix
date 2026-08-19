{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.development.lazyvim = {
    enable = lib.mkEnableOption "Neovim as the default editor with vi and vim aliases, the complete LazyVim configuration, cargo, rustc, tree-sitter, marksman, lazygit, and lazydocker";

    config = lib.mkOption {
      type = lib.types.path;
      default = ../../config/nvim;
      description = "Complete Neovim configuration directory installed as ~/.config/nvim.";
      example = lib.literalExpression "./nvim";
    };
  };

  config = lib.mkIf config.development.lazyvim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

    };

    home = {
      packages = with pkgs; [
        cargo
        rustc
        tree-sitter
        lazygit
        lazydocker
        imagemagick
        ghostscript
      ];

      file = {
        ".config/nvim" = {
          source = config.development.lazyvim.config;
          recursive = true;
        };

        ".config/nvim/lua/plugins/marksman.lua".text = ''
          return {
            {
              "neovim/nvim-lspconfig",
              opts = {
                servers = {
                  marksman = {
                    cmd = { "${lib.getExe pkgs.marksman}", "server" },
                    mason = false,
                  },
                },
              },
            },
          }
        '';
      };
    };
  };
}
