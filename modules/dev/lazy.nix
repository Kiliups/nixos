{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # general tools
      lazygit
      lazydocker

      # lua
      lua-language-server

      # nix
      nil

      # typescript
      nodePackages.typescript-language-server

      # bash
      nodePackages.bash-language-server

      # go
      gopls

      # rust
      rust-analyzer

      # java
      jdt-language-server

      # python
      pyright
    ];
  };

  # Provide lazy.nvim from the Nix store so Neovim can require it without
  # cloning into the read-only home-manager tree.
  xdg.dataFile."nvim/lazy/lazy.nvim" = {
    source = pkgs.vimPlugins.lazy-nvim;
    recursive = true;
  };

  home.file.".config/nvim" = {
    source = ../../config/nvim;
    recursive = true;
  };
}
