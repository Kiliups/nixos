{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.development.git.enable =
    lib.mkEnableOption "Git with main as the default branch, rebasing pulls, and the GitHub CLI"
    // {
      default = true;
    };

  config = lib.mkIf config.development.git.enable {
    programs.git = {
      enable = true;
      settings = {
        core.sshCommand = "ssh -i ~/.ssh/github";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        url."git@github.com:".insteadOf = "https://github.com/";
        credential."https://github.com".helper = "!gh auth git-credential";
        credential."https://gist.github.com".helper = "!gh auth git-credential";
      };
    };

    home.packages = [ pkgs.gh ];
  };
}
