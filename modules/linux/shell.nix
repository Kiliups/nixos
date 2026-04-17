{ pkgs, ... }:
{
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
    NIX = "$HOME/.config/nixos";
  };

  programs = {
    zsh = {
      shellAliases = {
        nx = "code ~/.config/nixos";
        ls = "eza -lh --group-directories-first --icons=auto";
        neofetch = "fastfetch";
        nfu = "sudo nix flake update --flake ~/.config/nixos";
        nrsu = "nfu && nrs";
      };
      initContent = ''
        nrs() {
          local host="''${1:-$(hostname)}"
          (cd ~/.config/nixos && git add -A && sudo nixos-rebuild switch --flake .#''${host} --impure)
        }
      '';
    };
  };

  home.packages = with pkgs; [
    wl-clipboard
    gh
  ];

  xdg.configFile."fastfetch/config.jsonc" = {
    source = ../../config/fastfetch/config.jsonc;
  };
}
