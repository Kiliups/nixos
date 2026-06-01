{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.dev.lazyvim.enable = lib.mkEnableOption "lazyvim setup";

  config = lib.mkIf config.dev.lazyvim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        # treesitter
        tree-sitter
      ];
    };

    # lazygit and lazydocker for terminal git and docker management, respectively
    home.packages = with pkgs; [
      lazygit
      lazydocker
    ];

    home.file.".config/nvim" = {
      source = ../../config/nvim;
      recursive = true;
    };
  };
}
