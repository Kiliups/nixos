{ config, host, ... }:
{

  programs.zsh = {
    dotDir = "${config.xdg.configHome}/zsh";
    history.path = "${config.home.homeDirectory}/.zsh_history";
    initContent = ''
      [[ -S "$SSH_AUTH_SOCK" ]] || export SSH_AUTH_SOCK="$HOME/.ssh/agent"
    '';
    envExtra = ''
      export SSH_SK_PROVIDER=/usr/local/lib/libsk-libfido2.dylib
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "~/.orbstack/ssh/config"
      "${host.dirs.workScripts}/bash/.ssh/config"
      "${host.dirs.workScripts}/bash/.ssh/includes/*.conf"
      "${host.dirs.workScripts}/bash/.ssh/departments/*.conf"
    ];
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        IdentitiesOnly = true;
        IdentityFile = "~/.ssh/id_ed25519_sk";
        UseKeychain = true;
      };
      "bitbucket.org" = {
        HostName = "ssh.bitbucket.org";
        User = host.username;
        IdentityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
