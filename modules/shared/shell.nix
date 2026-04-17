{ pkgs, ... }:
let
  useremail =
    if pkgs.stdenv.hostPlatform.isDarwin then "kilian.mayer@check24.de" else "mayer-kilian@gmx.de";
in
{
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
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

    git = {
      enable = true;
      settings = {
        user.name = "Kilian Mayer";
        user.email = useremail;
        init.defaultBranch = "main";
      };
    };
  };

  home.packages = with pkgs; [
    ghostty

    btop
    fastfetch
    ripgrep
    eza
    fd
  ];

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    confirm-close-surface = false
  '';
}
