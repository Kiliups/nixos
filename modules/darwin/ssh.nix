{ host, ... }:
{

  programs.zsh = {
    initContent = ''
      if [[ -S "$SSH_AUTH_SOCK" ]]; then
        :
      else
        export SSH_AUTH_SOCK="$HOME/.ssh/agent"
      fi
    '';
    profileExtra = ''
      export SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.dylib
    '';
  };

  home.file.".ssh/config".text = ''
    Include ~/.orbstack/ssh/config

    Include ${host.dirs.workScripts}/bash/.ssh/config
    Include ${host.dirs.workScripts}/bash/.ssh/includes/*.conf
    Include ${host.dirs.workScripts}/bash/.ssh/departments/*.conf

    Host *
      AddKeysToAgent yes
      IdentitiesOnly yes
      IdentityFile ~/.ssh/id_ed25519_sk
      UseKeychain yes

    Host bitbucket.org
      User ${host.username} 
      IdentityFile ~/.ssh/id_ed25519
      AddKeysToAgent yes
  '';
}
