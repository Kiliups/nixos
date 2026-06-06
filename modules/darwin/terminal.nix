{ pkgs, ... }:
{
  programs.zsh = {
    shellAliases = {
      gac = "git add -A && git commit";
    };
    initContent = ''
      drs() {
        local flake="''${1:-''${NIXOS_FLAKE:-$HOME/private/nixos}}"
        local host="''${2:-$(hostname)}"
        (cd "$flake" && git add -A && sudo darwin-rebuild switch --flake "path:$PWD#$host")
      }

      nfu() {
        local flake="''${1:-''${NIXOS_FLAKE:-$HOME/private/nixos}}"
        nix flake update --flake "$flake"
      }

      drsu() {
        local flake="''${1:-''${NIXOS_FLAKE:-$HOME/private/nixos}}"
        local host="''${2:-$(hostname)}"
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
    confirm-close-surface = false
  '';
}
