{ pkgs, ... }:
{
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

  # lazy.nvim for managing neovim plugins
  xdg.dataFile."nvim/lazy/lazy.nvim" = {
    source = pkgs.vimPlugins.lazy-nvim;
    recursive = true;
  };

  home.file.".config/nvim" = {
    source = ../config/nvim;
    recursive = true;
  };
}
