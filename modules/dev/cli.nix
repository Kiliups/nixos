{ pkgs, ... }:
let
  tdl = pkgs.writeShellApplication {
    name = "tdl";
    runtimeInputs = [ pkgs.tmux pkgs.coreutils ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" ]] && {
        echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"
        exit 1
      }
      [[ -z "''${TMUX:-}" ]] && {
        echo "You must start tmux to use tdl."
        exit 1
      }

      current_dir="$PWD"
      editor_pane="$TMUX_PANE"
      ai="$1"
      ai2="''${2:-}"

      tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
      tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"

      ai_pane="$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')"

      if [[ -n "$ai2" ]]; then
        ai2_pane="$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')"
        tmux send-keys -t "$ai2_pane" "$ai2" C-m
      fi

      tmux send-keys -t "$ai_pane" "$ai" C-m
      tmux send-keys -t "$editor_pane" "''${EDITOR:-nvim} ." C-m
      tmux select-pane -t "$editor_pane"
    '';
  };

  tdlm = pkgs.writeShellApplication {
    name = "tdlm";
    runtimeInputs = [ pkgs.tmux pkgs.coreutils tdl ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" ]] && {
        echo "Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]"
        exit 1
      }
      [[ -z "''${TMUX:-}" ]] && {
        echo "You must start tmux to use tdlm."
        exit 1
      }

      ai="$1"
      ai2="''${2:-}"
      base_dir="$PWD"
      first=true

      tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

      shopt -s nullglob
      for dir in "$base_dir"/*/; do
        dirpath="''${dir%/}"

        if $first; then
          tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
          first=false
        else
          pane_id="$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')"
          tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
        fi
      done
    '';
  };

  tsl = pkgs.writeShellApplication {
    name = "tsl";
    runtimeInputs = [ pkgs.tmux pkgs.coreutils ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" || -z "''${2:-}" ]] && {
        echo "Usage: tsl <pane_count> <command>"
        exit 1
      }
      [[ -z "''${TMUX:-}" ]] && {
        echo "You must start tmux to use tsl."
        exit 1
      }

      count="$1"
      cmd="$2"
      current_dir="$PWD"
      first_pane="$TMUX_PANE"
      panes=("$first_pane")

      tmux rename-window -t "$first_pane" "$(basename "$current_dir")"

      while (( ''${#panes[@]} < count )); do
        split_target="''${panes[''${#panes[@]} - 1]}"
        new_pane="$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')"
        panes+=("$new_pane")
        tmux select-layout -t "$first_pane" tiled
      done

      for pane in "''${panes[@]}"; do
        tmux send-keys -t "$pane" "$cmd" C-m
      done

      tmux select-pane -t "$first_pane"
    '';
  };
in
{
  imports = [
    ./starship.nix
  ];

  home.sessionVariables = {
    TERMINAL = "ghostty";
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
    NIX = "$HOME/.config/nixos";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        nx = "code ~/.config/nixos";
        ls = "eza -lh --group-directories-first --icons=auto";
        neofetch = "fastfetch";
        nfu = "sudo nix flake update --flake ~/.config/nixos";
        nrsu = "nfu && nrs";
      };
      initContent = ''
        nrs() {
          local host="''${1:-$(hostname)}"
          (cd ~/.config/nixos && git add -A && sudo nixos-rebuild switch --flake .#''${host} --impure)
        }
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

    git = {
      enable = true;
      settings = {
        user.name = "Kilian Mayer";
        user.email = "mayer-kilian@gmx.de";
        init.defaultBranch = "main";
      };
    };
  };

  home.packages = with pkgs; [
    ghostty

    btop
    fastfetch
    gh
    ripgrep
    eza
    fd
    tmux
    wl-clipboard
    tdl
    tdlm
    tsl
  ];

  xdg.configFile."fastfetch/config.jsonc" = {
    source = ../../config/fastfetch/config.jsonc;
  };

  home.file.".tmux/tmux.conf" = {
    source = ../../config/tmux/tmux.conf;
  };

  home.file.".tmux/plugins/tpm" = {
    source = fetchGit {
      url = "https://github.com/tmux-plugins/tpm";
      ref = "master";
    };
    recursive = true;
  };

  xdg.configFile."ghostty/config".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    confirm-close-surface = false
  '';
}
