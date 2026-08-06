{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.development.shell = {
    enable = lib.mkEnableOption "Zsh with completion, autosuggestions, syntax highlighting, fzf, direnv with nix-direnv, zoxide replacing cd, aliases for eza, fastfetch, and nix develop, plus bat, btop, fastfetch, ripgrep, eza, and fd";
  };

  config = lib.mkIf config.development.shell.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          ls = "eza -lh --group-directories-first --icons=auto";
          neofetch = "fastfetch";
          nd = "nix develop -c zsh";
        };
        initContent = ''
          bindkey -e
        '';
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = [ "--cmd cd" ];
      };
    };

    home.packages = with pkgs; [
      bat
      btop
      fastfetch
      ripgrep
      eza
      fd
    ];

    xdg.configFile = {
      "fastfetch/config.jsonc".source = ../../config/fastfetch/config.jsonc;
    };
  };
}
