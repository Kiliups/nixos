{ pkgs, host, ... }:
{
  programs.git = {
    enable = true;
    includes = [
      {
        condition = "gitdir:${host.dirs.projects}/";
        path = "~/.config/git/work.inc";
      }
      {
        condition = "gitdir:${host.dirs.private}/";
        path = "~/.config/git/private.inc";
      }
    ];
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  home = {
    packages = with pkgs; [
      gh
    ];

    file = {
      ".config/git/work.inc".text = ''
        [user]
          name = ${host.name}
          email = ${host.email}
        [core]
          hooksPath = ~/.config/git/hooks/work
      '';

      ".config/git/private.inc".text = ''
        [user]
          name = ${host.privateName}
          email = ${host.privateEmail}
      '';

      ".config/git/hooks/work/prepare-commit-msg" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          [[ "$2" == "" || "$2" == "message" ]] || exit 0

          branch_name=$(git rev-parse --abbrev-ref HEAD)
          [[ "$branch_name" != "HEAD" ]] || exit 0

          commit_message=$(<"$1")
          [[ "$commit_message" == "[$branch_name]"* ]] || printf '[%s] %s\n' "$branch_name" "$commit_message" > "$1"
        '';
      };
    };
  };
}
