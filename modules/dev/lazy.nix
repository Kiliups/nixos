{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      lazygit
      lazydocker

      # lsp servers
      lua-language-server
      nil
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      gopls
      rust-analyzer
      jdt-language-server
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
