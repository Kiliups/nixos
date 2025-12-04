{ pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode
      eamodio.gitlens
      github.copilot
      github.copilot-chat
      vscjava.vscode-java-pack
      svelte.svelte-vscode
      dart-code.dart-code
      dart-code.flutter
      jnoortheen.nix-ide
      ms-vscode-remote.remote-ssh
      ltex-plus.vscode-ltex-plus
      james-yu.latex-workshop
      tomoki1207.pdf
      streetsidesoftware.code-spell-checker
      streetsidesoftware.code-spell-checker-german
      golang.go
      rust-lang.rust-analyzer
      ms-python.python
      ms-vscode.cpptools
      vscodevim.vim
      tauri-apps.tauri-vscode
      catppuccin.catppuccin-vsc
    ];
  };

  home.activation.vscode-settings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/Code/User
    if [ ! -f ~/.config/Code/User/settings.json ]; then
      cp ${./../../config/vscode/settings.json} ~/.config/Code/User/settings.json
      chmod 644 ~/.config/Code/User/settings.json
    fi
  '';

  xdg.dataFile."kio/servicemenus/vscode-here.desktop".text = ''
    [Desktop Entry]
    Type=Service
    X-KDE-ServiceTypes=KonqPopupMenu/Plugin
    MimeType=inode/directory;
    Actions=vscode-here;
    X-KDE-Priority=TopLevel

    [Desktop Action vscode-here]
    Name=Open VS Code here
    Name[de]=Öffne VS Code hier
    Icon=code
    Exec=code %f
  '';
}
