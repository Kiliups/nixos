{ host, pkgs, ... }:
{
  home.packages = [
    pkgs.openssh
  ];

  programs.zsh = {
    initContent = ''
      if [[ -S "$SSH_AUTH_SOCK" ]]; then
        :
      else
        export SSH_AUTH_SOCK="$HOME/.ssh/agent"
      fi
    '';
  };

  home.file.".ssh/config".text = ''
    Include ~/.orbstack/ssh/config

    Include ~/projects/work-scripts/bash/.ssh/config
    Include ~/projects/work-scripts/bash/.ssh/includes/*.conf
    Include ~/projects/work-scripts/bash/.ssh/departments/*.conf

    Host *
      AddKeysToAgent yes
      IdentitiesOnly yes
      IdentityFile ~/.ssh/id_ed25519_sk
      UseKeychain yes

    Host bitbucket.org
      User ${host.username} 
      IdentityFile ~/.ssh/id_ed25519
      AddKeysToAgent yes
      ForwardAgent yes
  '';
}
