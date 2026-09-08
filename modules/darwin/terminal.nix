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

      ticket="$1"
      target_ticket="''${ticket//\//-}"
      repo_root="$(git rev-parse --show-toplevel)"
      project="$(basename "$repo_root")"
      tree_dir="$(dirname "$repo_root")/tree"
      target="$tree_dir/$project-$target_ticket"

      mkdir -p "$tree_dir"

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
      target_ticket="''${ticket//\//-}"
      repo_root="$(git rev-parse --show-toplevel)"
      project="$(basename "$repo_root")"
      target="$(dirname "$repo_root")/tree/$project-$target_ticket"

      git -C "$repo_root" worktree remove --force "$target" 2>/dev/null || true
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
      gwtrm
      ghostty-bin
    ];
  };

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
  '';
}
