{
  pkgs,
  host,
  ...
}:
{
  programs = {
    zsh = {
      initContent = ''
        drs() {
          local host="''${2:-$(hostname)}"
          (cd $1 && git add -A && sudo darwin-rebuild switch --flake $1#''${host} --impure)
        }

        if [[ -S "$SSH_AUTH_SOCK" ]]; then
          :
        else
          export SSH_AUTH_SOCK="$HOME/.ssh/agent"
        fi
        export SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.dylib
      '';
    };

    git = {
      enable = true;
      settings = {
        user.name = host.name;
        user.email = host.email;
        init.defaultBranch = "main";
      };
    };
  };

  home.sessionVariables = {
    TERMINAL = "ghostty";
  };

  home.packages = with pkgs; [
    ghostty-bin

    gh
  ];

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    confirm-close-surface = false
  '';
}
