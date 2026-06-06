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

    home.activation.installLazyNvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.local/share/nvim/lazy"
      cp -r --no-preserve=mode ${pkgs.vimPlugins.lazy-nvim} "$HOME/.local/share/nvim/lazy/lazy.nvim"
    '';

    home.file.".config/nvim" = {
      source = ../../config/nvim;
      recursive = true;
    };
  };
}
