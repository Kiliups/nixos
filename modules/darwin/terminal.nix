{
  pkgs,
  host,
  ...
}:
{
  programs = {
    zsh = {
      shellAliases = {
        gac = "git add -A && git commit";
      };
      initContent = ''
        drs() {
          local flake="''${1:-.}"
          local host="''${2:-$(hostname)}"
          (cd "$flake" && git add -A && sudo darwin-rebuild switch --flake ".#''${host}")
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
      includes = [
        {
          condition = "gitdir:~/projects/";
          path = "~/.config/git/work.inc";
        }
        {
          condition = "gitdir:~/private/";
          path = "~/.config/git/private.inc";
        }
      ];
      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };

  # TODO ssh config
  # TODO everthing form onboarding
  home = {
    sessionVariables = {
      TERMINAL = "ghostty";
    };

    packages = with pkgs; [
      ghostty-bin

      gh
    ];

    file = {
      ".config/git/work.inc".text = ''
        [user]
          name = ${host.name}
          email = ${host.email}
        [core]
          hooksPath = ~/.config/git/hooks/work
      '';

      ".config/git/private.inc".text = ''
        [user]
          name = Public User
          email = user@example.invalid
      '';

      ".config/git/hooks/work/prepare-commit-msg" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          [[ "$2" == "" || "$2" == "message" ]] || exit 0

          branch_name=$(git rev-parse --abbrev-ref HEAD)
          [[ "$branch_name" != "HEAD" ]] || exit 0

          commit_message=$(<"$1")
          [[ "$commit_message" == "[$branch_name]"* ]] || printf '[%s] %s\n' "$branch_name" "$commit_message" > "$1"
        '';
      };

      ".config/git/hooks/work/pre-push" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          if [[ ! -r /dev/tty ]]; then
            echo "Push cancelled. no interactive terminal available." >&2
            exit 1
          fi

          printf "formatted and linted? [y/N] " > /dev/tty
          read -r answer < /dev/tty
          case "$answer" in
            [yY]|[yY][eE][sS])
              exit 0
              ;;
            *)
              echo "Push cancelled. formatting/linting first."
              exit 1
              ;;
          esac
        '';
      };
    };
  };

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    confirm-close-surface = false
  '';
}
