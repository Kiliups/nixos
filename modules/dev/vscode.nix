{
  pkgs,
  lib,
  config,
  ...
}:
let
  vsCodeSettings = {
    "catppuccin.accentColor" = "lavender";
    "editor.semanticHighlighting.enabled" = true;
    "terminal.integrated.minimumContrastRatio" = 1;
    "window.titleBarStyle" = "custom";
    "workbench.colorTheme" = "Catppuccin Macchiato";
    "workbench.iconTheme" = "catppuccin-macchiato";
    "files.autoSave" = "afterDelay";
    "editor.lineNumbers" = "relative";
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.formatOnSave" = true;
    "editor.codeActionsOnSave" = {
      "source.organizeImports" = "explicit";
    };
    "editor.formatOnPaste" = true;
    "files.associations" = {
      "*.svx" = "markdown";
    };
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
    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
      "editor.formatOnSave" = true;
    };
    "[svelte]" = {
      "editor.defaultFormatter" = "svelte.svelte-vscode";
      "editor.formatOnSave" = true;
    };
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
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };
    "[markdown]" = {
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 100;
    };
    "[typst]" = {
      "editor.formatOnSave" = true;
    };
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.formatterPath" = "nixfmt";
    "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
    "ltex.language" = "en-US";
  };
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode
      eamodio.gitlens
      github.copilot-chat
      vscjava.vscode-java-pack
      svelte.svelte-vscode
      dart-code.dart-code
      dart-code.flutter
      jnoortheen.nix-ide
      ms-vscode-remote.remote-ssh
      tomoki1207.pdf
      golang.go
      rust-lang.rust-analyzer
      ms-python.python
      ms-toolsai.datawrangler
      ms-vscode.cpptools
      vscodevim.vim
      tauri-apps.tauri-vscode
      kilocode.kilo-code
      ltex-plus.vscode-ltex-plus
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
