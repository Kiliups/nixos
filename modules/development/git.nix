{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.development.git.enable = lib.mkEnableOption "Git with automatic remote setup on push and the GitHub CLI, installed and configured as the credential helper for github.com and gist.github.com";

  config = lib.mkIf config.development.git.enable {
    programs.git = {
      enable = true;
      settings = {
        push.autoSetupRemote = true;
        credential."https://github.com".helper = "!gh auth git-credential";
        credential."https://gist.github.com".helper = "!gh auth git-credential";
      };
    };

    home.packages = [ pkgs.gh ];
  };
}
