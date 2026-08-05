{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs) herdr;
  hdl = pkgs.writeShellApplication {
    name = "hdl";
    runtimeInputs = [
      herdr
      pkgs.coreutils
      pkgs.jq
    ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" ]] && {
        echo "Usage: hdl <claude(cc)|codex(cx)|cursor-agent(ccli)|opencode(opc)|other_ai> [<second_ai>]"
        exit 1
      }
      [[ -z "''${HERDR_ENV:-}" ]] && {
        echo "hdl must run inside Herdr"
        exit 1
      }

      current_dir="$PWD"
      editor_pane="$HERDR_PANE_ID"
      ai="$1"
      ai2="''${2:-}"

      herdr tab rename "$HERDR_TAB_ID" "$(basename "$current_dir")" >/dev/null
      herdr pane split "$editor_pane" --direction down --ratio 0.85 --cwd "$current_dir" >/dev/null
      ai_pane="$(herdr pane split "$editor_pane" --direction right --ratio 0.60 --cwd "$current_dir" | jq -er '.result.pane.pane_id')"

      if [[ -n "$ai2" ]]; then
        ai2_pane="$(herdr pane split "$ai_pane" --direction down --ratio 0.50 --cwd "$current_dir" | jq -er '.result.pane.pane_id')"
        herdr pane run "$ai2_pane" "$ai2"
      fi

      herdr pane run "$ai_pane" "$ai"
      herdr pane run "$editor_pane" "''${EDITOR:-nvim} ."
    '';
  };
  hdlm = pkgs.writeShellApplication {
    name = "hdlm";
    runtimeInputs = [
      herdr
      pkgs.coreutils
      pkgs.jq
      hdl
    ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" ]] && {
        echo "Usage: hdlm <claude(cc)|codex(cx)|cursor-agent(ccli)|opencode(opc)|other_ai> [<second_ai>]"
        exit 1
      }
      [[ -z "''${HERDR_ENV:-}" ]] && {
        echo "hdlm must run inside Herdr"
        exit 1
      }

      ai="$1"
      ai2="''${2:-}"
      base_dir="$PWD"
      first=true

      shopt -s nullglob
      for dir in "$base_dir"/*/; do
        dirpath="''${dir%/}"
        if $first; then
          herdr workspace rename "$HERDR_WORKSPACE_ID" "$(basename "$dirpath")" >/dev/null
          herdr pane run "$HERDR_PANE_ID" "cd '$dirpath' && hdl $ai $ai2"
          first=false
        else
          workspace="$(herdr workspace create --cwd "$dirpath" --label "$(basename "$dirpath")" --no-focus)"
          pane_id="$(jq -er '.result.root_pane.pane_id' <<< "$workspace")"
          herdr pane run "$pane_id" hdl "$ai" "$ai2"
        fi
      done
    '';
  };
in
{
  options.development.herdr.enable = lib.mkEnableOption "Herdr terminal multiplexer";

  config = lib.mkIf config.development.herdr.enable {
    home.packages = [
      herdr
      hdl
      hdlm
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.libnotify ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.terminal-notifier ];

    xdg.configFile."herdr/config.toml".text = ''
      onboarding = false

      [keys]
      prefix = "ctrl+space"
      detach = "prefix+d"
      rename_tab = "prefix+comma"
      focus_pane_left = ["prefix+h", "alt+left"]
      focus_pane_right = ["prefix+l", "alt+right"]
      focus_pane_up = ["prefix+k", "alt+up"]
      focus_pane_down = ["prefix+j", "alt+down"]
      previous_tab = ["prefix+p", "shift+left"]
      next_tab = ["prefix+n", "shift+right"]
      close_tab = "prefix+ampersand"
      last_pane = "prefix+semicolon"
      cycle_pane_next = "prefix+o"
      split_vertical = "prefix+%"
      split_horizontal = "prefix+\""

      [ui]
      pane_borders = true
      pane_gaps = false
      hide_tab_bar_when_single_tab = true

      [ui.toast]
      delivery = "system"
      delay_seconds = 1
    '';
  };
}
