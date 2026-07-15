{ pkgs, ... }:
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

      ticket="$1"
      repo_root="$(git rev-parse --show-toplevel)"
      common_dir="$(git rev-parse --path-format=absolute --git-common-dir)"
      repo_dir="$(dirname "$common_dir")"
      target="$(dirname "$repo_dir")/$(basename "$repo_dir")-$ticket"

      if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$ticket"; then
        git -C "$repo_root" worktree add "$target" "$ticket"
      else
        git -C "$repo_root" fetch origin integration
        git -C "$repo_root" worktree add -b "$ticket" "$target" FETCH_HEAD
      fi
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

      ticket="$1"
      repo_root="$(git rev-parse --show-toplevel)"
      common_dir="$(git rev-parse --path-format=absolute --git-common-dir)"
      repo_dir="$(dirname "$common_dir")"
      target="$(dirname "$repo_dir")/$(basename "$repo_dir")-$ticket"

      git -C "$repo_root" worktree remove "$target"
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
        local flake="''${1:-''${NIXOS_FLAKE:-$HOME/.config/nixos}}"
        local host="''${2:-$(hostname -s)}"
        (
          cd "$flake"
          git add -A
          local private="''${NIXOS_PRIVATE_FLAKE:-path:$PWD/private}"
          sudo darwin-rebuild switch --flake ".#$host" --override-input nixos-private "$private"
        )
      }

      nfu() {
        local flake="''${1:-''${NIXOS_FLAKE:-$HOME/.config/nixos}}"
        nix flake update --flake "$flake"
      }

      drsu() {
        local flake="''${1:-''${NIXOS_FLAKE:-$HOME/.config/nixos}}"
        local host="''${2:-$(hostname -s)}"
        nfu "$flake" && drs "$flake" "$host"
      }
    '';
  };

  home = {
    sessionVariables = {
      TERMINAL = "ghostty";
    };

    packages = with pkgs; [
      gwt
      gwtrm
      ghostty-bin
    ];
  };

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    macos-option-as-alt = true
  '';
}
