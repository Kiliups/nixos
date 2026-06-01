{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.dev.shell.enable = lib.mkEnableOption "shell setup";

  config = lib.mkIf config.dev.shell.enable {
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

    xdg.configFile."fastfetch/config.jsonc" = {
      source = ../../config/fastfetch/config.jsonc;
    };
  };
}
