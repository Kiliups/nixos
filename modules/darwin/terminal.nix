{ pkgs, ... }:
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
      ghostty-bin
    ];
  };

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
    macos-option-as-alt = true
  '';
}
