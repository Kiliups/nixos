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

  # clone LazyVim configuration
  home.activation.installLazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    NVIM_DIR="$HOME/.config/nvim"

    # Only clone if directory doesn't exist
    if [ ! -d "$NVIM_DIR" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/LazyVim/starter "$NVIM_DIR"
      $DRY_RUN_CMD rm -rf "$NVIM_DIR/.git"
      echo "LazyVim starter installed to $NVIM_DIR"
    else
      echo "LazyVim config already exists at $NVIM_DIR, skipping installation"
    fi
  '';
}
