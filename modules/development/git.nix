{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.development.git.enable = lib.mkEnableOption "Git and the GitHub CLI" // {
    default = true;
  };

  config = lib.mkIf config.development.git.enable {
    programs.git = {
      enable = true;
      settings = {
        push.autoSetupRemote = true;
        url."git@github.com:".insteadOf = "https://github.com/";
        credential."https://github.com".helper = "!gh auth git-credential";
        credential."https://gist.github.com".helper = "!gh auth git-credential";
      };
    };

    home.packages = [ pkgs.gh ];
  };
}
