{
  pkgs,
  lib,
  config,
  ...
}:
let
  vsCodeSettings = {
    # theme
    "catppuccin.accentColor" = "lavender";
    "workbench.colorTheme" = "Catppuccin Macchiato";
    "workbench.iconTheme" = "catppuccin-macchiato";

    # editor general
    "editor.semanticHighlighting.enabled" = true;
    "editor.lineNumbers" = "relative";
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.formatOnSave" = true;
    "editor.formatOnPaste" = true;
    "editor.codeActionsOnSave" = {
      "source.organizeImports" = "explicit";
    };

    # files
    "files.autoSave" = "afterDelay";
    "files.associations" = {
      "*.svx" = "markdown";
    };

    # go
    "[go]" = {
      "editor.defaultFormatter" = "golang.go";
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "explicit";
      };
    };
    "go.lintTool" = "golangci-lint";
    "go.lintOnSave" = "package";
    "go.lintFlags" = [ "--fast" ];
    "go.useLanguageServer" = true;

    # rust
    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
      "editor.formatOnSave" = true;
    };

    # typescript/svelte
    "[svelte]" = {
      "editor.defaultFormatter" = "svelte.svelte-vscode";
      "editor.formatOnSave" = true;
    };

    # json
    "[json]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.formatOnSave" = true;
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 100;
    };
    "[jsonc]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.formatOnSave" = true;
    };

    # nix
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.formatterPath" = "nixfmt";

    # python
    "[python]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "ms-python.black-formatter";
      "source.organizeImports" = "explicit";
    };

    # typst
    "[typst]" = {
      "editor.formatOnSave" = true;
    };

    # markdown
    "[markdown]" = {
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 100;
    };

    # ltex (grammar/spell check)
    "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
    "ltex.language" = "en-US";
  };
in
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # general/editor
      esbenp.prettier-vscode
      github.copilot-chat
      ms-vscode-remote.remote-ssh
      tomoki1207.pdf
      vscodevim.vim
      ltex-plus.vscode-ltex-plus

      # java
      vscjava.vscode-java-pack

      # typescript/svelte
      svelte.svelte-vscode

      # dart/flutter
      dart-code.dart-code
      dart-code.flutter

      # nix
      jnoortheen.nix-ide

      # go
      golang.go

      # rust
      rust-lang.rust-analyzer
      tauri-apps.tauri-vscode

      # python
      ms-python.python
      ms-python.black-formatter
      ms-toolsai.datawrangler
      ms-toolsai.jupyter

      # c/c++
      ms-vscode.cpptools

      # typst
      myriad-dreamin.tinymist
    ];
  };

  # This allows VS Code to edit it, while rebuild overwrites with defaults
  home.activation.writeVscodeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "${config.home.homeDirectory}/.config/Code/User"
        cat > "${config.home.homeDirectory}/.config/Code/User/settings.json" << 'EOF'
        ${builtins.toJSON vsCodeSettings}
    EOF
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
