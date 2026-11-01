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
      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        brew update && brew upgrade
      ''}
    }

    eval "$(wt config shell init zsh)"
  '';

  home.packages = [ pkgs.worktrunk ];

  xdg.configFile."ghostty/config.ghostty".text = ''
    font-family = "JetBrains Mono"
    theme = "Catppuccin Macchiato"
  '';

  xdg.configFile."worktrunk/config.toml".text = ''
    worktree-path = "{{ repo_path }}/../tree/{{ repo }}-{{ branch | sanitize }}"

    [remove]
    delete-branch = false
  '';
}
