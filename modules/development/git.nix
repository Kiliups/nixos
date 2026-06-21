_: {
  programs.git.settings = {
    push.autoSetupRemote = true;
    credential."https://github.com".helper = "!gh auth git-credential";
    credential."https://gist.github.com".helper = "!gh auth git-credential";
  };
}
