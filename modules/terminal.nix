{ config, ... }:
{
  home.sessionVariables = {
    TERMINAL = "ghostty";
    NIXOS_FLAKE = "${config.home.homeDirectory}/.config/nixos";
  };

  programs.zsh.initContent = ''
    nfu() {
      local flake="''${1:-$NIXOS_FLAKE}"
      nix flake update --flake "$flake"
    }
  '';

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
  '';
}
