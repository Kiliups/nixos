{ pkgs, ... }:
let
  # tdl = "tmux agent development layout for a single project"
  tdl = pkgs.writeShellApplication {
    name = "tdl";
    runtimeInputs = [
      pkgs.tmux
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" ]] && {
        echo "Usage: tdl <claude(cc)|codex(cx)|cursor-agent(ccli)|opencode(opc)|other_ai> [<second_ai>]"
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

  # tdlm = "tmux agent development layout for multiple projects in subdirectories"
  tdlm = pkgs.writeShellApplication {
    name = "tdlm";
    runtimeInputs = [
      pkgs.tmux
      pkgs.coreutils
      tdl
    ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" ]] && {
        echo "Usage: tdlm <claude(cc)|codex(cx)|cursor-agent(ccli)|opencode(opc)|other_ai> [<second_ai>]"
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

  # tsl = "tmux swarm agent layout"
  tsl = pkgs.writeShellApplication {
    name = "tsl";
    runtimeInputs = [
      pkgs.tmux
      pkgs.coreutils
    ];
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

  # tml = "tmux multi agent layout"
  tml = pkgs.writeShellApplication {
    name = "tml";
    runtimeInputs = [
      pkgs.tmux
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail
      [[ $# -eq 0 ]] && {
        echo "Usage: tml <claude(cc)|codex(cx)|cursor-agent(ccli)|opencode(opc)|other_ai> [other_ai] [other_ai] ..."
        exit 1
      }
      [[ -z "''${TMUX:-}" ]] && {
        echo "You must start tmux to use tml."
        exit 1
      }
      cmds=("$@")
      count="''${#cmds[@]}"
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
      for i in "''${!panes[@]}"; do
        cmd="''${cmds[i % count]}"
        tmux send-keys -t "''${panes[$i]}" "$cmd" C-m
      done
      tmux select-pane -t "$first_pane"
    '';
  };
in
{
  home.packages = with pkgs; [
    tmux

    tdl
    tdlm
    tsl
    tml
  ];

  programs = {
    zsh = {
      shellAliases = {
        tmlall = "tml claude codex cursor-agent";
      };
    };
  };

  home.file.".tmux/tmux.conf" = {
    source = ../config/tmux/tmux.conf;
  };

  home.file.".tmux/plugins/tpm" = {
    source = fetchGit {
      url = "https://github.com/tmux-plugins/tpm";
      ref = "master";
    };
    recursive = true;
  };
}
