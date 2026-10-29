{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    TERMINAL = "ghostty";
    NIXOS_FLAKE = "${config.home.homeDirectory}/.config/nixos";
  };

  programs.zsh.initContent = ''
    nfu() {
      local flake="''${1:-$NIXOS_FLAKE}"
      nix flake update --flake "$flake" || return
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        brew update && brew upgrade
      ''}
    }
  '';

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
  '';
}
