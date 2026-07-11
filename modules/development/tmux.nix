{
  pkgs,
  lib,
  config,
  tpm ? null,
  ...
}:
let
  # When run outside tmux, start (or attach to) a session named after the cwd
  # and re-run the command inside it.
  bootstrapTmux = ''
    if [[ -z "''${TMUX:-}" ]]; then
      session_name="$(basename "$PWD" | tr '.:' '--')"
      if tmux has-session -t "$session_name" 2>/dev/null; then
        exec tmux attach-session -t "$session_name"
      fi
      exec tmux new-session -s "$session_name" -c "$PWD" \; send-keys "$0 $*" C-m
    fi
  '';

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
      ${bootstrapTmux}

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
      ${bootstrapTmux}

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
      ${bootstrapTmux}

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
      ${bootstrapTmux}
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
  options.development.tmux = {
    enable = lib.mkEnableOption "tmux setup";

    configSource = lib.mkOption {
      type = lib.types.path;
      default = ../../config/tmux/tmux.conf;
      description = "Path to the tmux configuration file.";
    };
  };

  config = lib.mkIf config.development.tmux.enable {
    assertions = [
      {
        assertion = tpm != null;
        message = "The tpm flake input must be set when development.tmux.enable is true.";
      }
    ];

    home = {
      packages = with pkgs; [
        tmux

        tdl
        tdlm
        tsl
        tml
      ];

      file = {
        ".tmux.conf" = {
          source = config.development.tmux.configSource;
        };

        ".tmux/plugins/tpm" = {
          source = tpm;
          recursive = true;
        };
      };
    };

  };
}
