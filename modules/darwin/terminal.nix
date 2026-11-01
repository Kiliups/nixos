{ pkgs, ... }:
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
    '';
  };

  home.packages = [ pkgs.ghostty-bin ];

  xdg.configFile."ghostty/config.ghostty".text = ''
    macos-option-as-alt = false
  '';
}
