{ pkgs, ... }:
{
  programs = {
    zsh = {
      shellAliases = {
        cc = "claude";
        ccli = "cursor-agent";
        cx = "codex";
        opc = "opencode";
      };
    };
  };

  home.packages = with pkgs; [
    # agents
    opencode
    cursor-cli
    claude-code
    codex

    # nix
    nixfmt
    nixd
  ];
}
