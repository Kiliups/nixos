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
          local flake="''${1:-.}"
          local host="''${2:-$(hostname)}"
          (cd "$flake" && git add -A && sudo darwin-rebuild switch --flake ".#''${host}" --impure)
        }

        nfu() {
          local flake="''${1:-.}"
          (cd "$flake" && nix flake update)
        }

        drsu() {
          local flake="''${1:-.}"
          local host="''${2:-$(hostname)}"
          nfu "$flake" && drs "$flake" "$host"
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

  # TODO git hooks
  # TODO ssh config
  # TODO everthing form onboarding
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
