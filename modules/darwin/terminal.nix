{ pkgs, ... }:
let
  herdrWorktree = pkgs.writeShellApplication {
    name = "herdr-worktree";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.herdr
      pkgs.jq
    ];
    text = ''
      set -euo pipefail

      agent="''${1:-''${HERDR_AGENT:-opc}}"
      pane_id="$(herdr workspace create --cwd "$PWD" --label "$(basename "$PWD")" --focus | jq -er '.result.root_pane.pane_id')"
      herdr pane run "$pane_id" hdl "$agent"
    '';
  };
in
{
  imports = [ ../terminal.nix ];

  programs.zsh = {
    shellAliases = {
      gac = "git add -A && git commit";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
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

      drsu() {
        local flake="''${1:-$NIXOS_FLAKE}"
        local host="''${2:-$(hostname -s)}"
        nfu "$flake" && drs "$flake" "$host"
      }

      eval "$(wt config shell init zsh)"
    '';
  };

  home.packages = with pkgs; [
    worktrunk
    ghostty-bin
  ];

  xdg.configFile."ghostty/config.ghostty".text = ''
    macos-option-as-alt = false
  '';

  xdg.configFile."worktrunk/config.toml".text = ''
    worktree-path = "{{ repo_path }}/../tree/{{ repo }}-{{ branch | sanitize }}"

    [post-start]
    herdr = "${herdrWorktree}/bin/herdr-worktree"

    [remove]
    delete-branch = false
  '';
}
