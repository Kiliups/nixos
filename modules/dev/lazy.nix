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

  home.file.".config/nvim" = {
    source = ../../config/nvim;
    recursive = true;
  };
}
