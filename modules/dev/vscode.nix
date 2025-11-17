{ pkgs, lib, ... }:
{
  programs = {
    vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
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
          # latex
          ltex-plus.vscode-ltex-plus
          james-yu.latex-workshop
          tomoki1207.pdf
          # spell checking
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-german
          golang.go
          rust-lang.rust-analyzer
          ms-python.python
          ms-vscode.cpptools
          vscodevim.vim
          tauri-apps.tauri-vscode
        ];
      };
    };
  };

  home.activation.vscode-settings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/Code/User
    if [ ! -f ~/.config/Code/User/settings.json ]; then
      cat > ~/.config/Code/User/settings.json << EOF
    {
      "files.autoSave": "afterDelay",
      "editor.defaultFormatter": "esbenp.prettier-vscode",
      "editor.formatOnSave": true,
      "editor.codeActionsOnSave": {
        "source.organizeImports": "explicit"
      },
      "editor.formatOnPaste": true,
      "[go]": {
        "editor.defaultFormatter": "golang.go",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
          "source.organizeImports": "explicit"
        }
      }, 
      "go.lintTool": "golangci-lint",
      "go.lintOnSave": "package",
      "go.lintFlags": [
        "--fast"
      ],
      "go.useLanguageServer": true,
      "[rust]": {
        "editor.defaultFormatter": "rust-lang.rust-analyzer",
        "editor.formatOnSave": true
      },
      "[svelte]": {
        "editor.defaultFormatter": "svelte.svelte-vscode",
        "editor.formatOnSave": true
      },
      "[nix]": {
        "editor.defaultFormatter": "jnoortheen.nix-ide",
        "editor.formatOnSave": true
      },
      "nix.enableLanguageServer": true,
      "nix.serverPath": "nixd",
      "nix.formatterPath": "nixfmt",
      "ltex.language": "de-DE",
      "ltex.enabled": ["latex", "markdown"],
      "ltex.ltex-ls.path": "${pkgs.ltex-ls}/bin/ltex-ls"    
    }
    EOF
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
