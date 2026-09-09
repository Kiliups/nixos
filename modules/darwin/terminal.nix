{ config, pkgs, ... }:
let
  gwt = pkgs.writeShellApplication {
    name = "gwt";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
    ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" ]] && {
        echo "Usage: gwt <ticket>"
        exit 1
      }

      cd "$(git rev-parse --show-toplevel)"
      ticket="$1"
      target="../tree/$(basename "$PWD")-$ticket"
      mkdir -p "$(dirname "$target")"

      if git show-ref --verify --quiet "refs/heads/$ticket"; then
        git worktree add "$target" "$ticket"
      else
        git fetch origin integration
        git worktree add -b "$ticket" "$target" FETCH_HEAD
      fi
    '';
  };

  gwth = pkgs.writeShellApplication {
    name = "gwth";
    runtimeInputs = [
      gwt
      pkgs.coreutils
      pkgs.git
      pkgs.herdr
      pkgs.jq
    ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" || -z "''${2:-}" ]] && {
        echo "Usage: gwth <branch> <agent>"
        exit 1
      }

      branch="$1"
      agent="$2"
      gwt "$branch"

      repo_root="$(git rev-parse --show-toplevel)"
      target="$repo_root/../tree/$(basename "$repo_root")-$branch"
      pane_id="$(herdr workspace create --cwd "$target" --label "$(basename "$target")" --focus | jq -er '.result.root_pane.pane_id')"
      herdr pane run "$pane_id" hdl "$agent"
    '';
  };

  gwtrm = pkgs.writeShellApplication {
    name = "gwtrm";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
    ];
    text = ''
      set -euo pipefail

      [[ -z "''${1:-}" ]] && {
        echo "Usage: gwtrm <ticket>"
        exit 1
      }

      cd "$(git rev-parse --show-toplevel)"
      target="../tree/$(basename "$PWD")-$1"

      git worktree remove --force "$target" 2>/dev/null || true
      rm -rf -- "$target"
    '';
  };
in
{
  programs.zsh = {
    shellAliases = {
      gac = "git add -A && git commit";
    };
    initContent = ''
      drs() {
        local flake="''${1:-$NIXOS_FLAKE}"
        local host="''${2:-$(hostname -s)}"
        (
          cd "$flake"
          git add -A
          cp "$(nix build --no-link --print-out-paths .#development-options)" templates/development/DEVELOPMENT_OPTIONS.md
          git add templates/development/DEVELOPMENT_OPTIONS.md
          local private="''${NIXOS_PRIVATE_FLAKE:-path:$PWD/private}"
          sudo darwin-rebuild switch --flake ".#$host" --override-input nixos-private "$private"
        )
      }

      nfu() {
        local flake="''${1:-$NIXOS_FLAKE}"
        nix flake update --flake "$flake"
      }

      drsu() {
        local flake="''${1:-$NIXOS_FLAKE}"
        local host="''${2:-$(hostname -s)}"
        nfu "$flake" && drs "$flake" "$host"
      }
    '';
  };

  home = {
    sessionVariables = {
      TERMINAL = "ghostty";
      NIXOS_FLAKE = "${config.home.homeDirectory}/.config/nixos";
    };

    packages = with pkgs; [
      gwt
      gwth
      gwtrm
      ghostty-bin
    ];
  };

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
  '';
}
