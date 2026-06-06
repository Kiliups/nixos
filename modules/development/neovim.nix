{
  pkgs,
  lib,
  config,
  ...
}:
let
  fileType = lib.types.submodule {
    options = {
      source = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Source path for a Neovim config file.";
      };

      text = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
        description = "Text content for a Neovim config file.";
      };
    };
  };

  extraFiles = lib.mapAttrs' (
    target: file:
    lib.nameValuePair ".config/nvim/${target}" (
      if file.source != null then { inherit (file) source; } else { inherit (file) text; }
    )
  ) config.dev.lazyvim.files;
in
{
  options.dev.lazyvim = {
    enable = lib.mkEnableOption "lazyvim setup";

    configSource = lib.mkOption {
      type = lib.types.path;
      default = ../../config/nvim;
      description = "Path to the Neovim configuration directory.";
    };

    files = lib.mkOption {
      type = lib.types.attrsOf fileType;
      default = { };
      description = "Extra files to add under the Neovim configuration directory.";
      example = {
        "lua/config/options.lua".text = ''
          vim.opt.number = true
        '';
      };
    };
  };

  config = lib.mkIf config.dev.lazyvim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        tree-sitter
      ];
    };

    home = {
      # lazygit and lazydocker for terminal git and docker management, respectively
      packages = with pkgs; [
        lazygit
        lazydocker
      ];

      activation.installLazyNvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/.local/share/nvim/lazy"
        cp -r --no-preserve=mode ${pkgs.vimPlugins.lazy-nvim} "$HOME/.local/share/nvim/lazy/lazy.nvim"
      '';

      file = {
        ".config/nvim" = {
          source = config.dev.lazyvim.configSource;
          recursive = true;
        };
      }
      // extraFiles;
    };
  };
}
