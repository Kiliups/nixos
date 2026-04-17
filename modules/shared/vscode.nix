{
  pkgs,
  lib,
  config,
  ...
}:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  vsCodeUserDir =
    if isLinux then
      "${config.home.homeDirectory}/.config/Code/User"
    else if isDarwin then
      "${config.home.homeDirectory}/Library/Application Support/Code/User"
    else
      null;
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
    "editor.fontFamily" = "JetBrainsMono Nerd Font";
    "files.autoSave" = "afterDelay";

    # astro
    "[astro]" = {
      "editor.defaultFormatter" = "astro-build.astro-vscode";
      "editor.formatOnSave" = true;
    };
    "prettier.documentSelectors" = [ "**/*.astro" ];

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

    # markdown
    "[markdown]" = {
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 100;
    };
  }
  // lib.optionalAttrs isLinux {
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

    # python
    "[python]" = {
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "ms-python.black-formatter";
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = "explicit";
        "source.fixAll" = "explicit";
      };
    };
    "python.languageServer" = "Pylance";
    "python.analysis.typeCheckingMode" = "basic";
    "python.analysis.autoImportCompletions" = true;
    "python.analysis.diagnosticMode" = "workspace";
    "python.analysis.inlayHints.functionReturnTypes" = true;
    "python.analysis.inlayHints.variableTypes" = true;

    # typst
    "[typst]" = {
      "editor.formatOnSave" = true;
    };

    # ltex (grammar/spell check)
    "ltex.language" = "en-US";
    "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
  };
in
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        # general/editor
        esbenp.prettier-vscode
        ms-vscode-remote.remote-ssh
        vscodevim.vim

        # typescript/svelte
        svelte.svelte-vscode

        # astro
        astro-build.astro-vscode

        # nix
        jnoortheen.nix-ide

        # todo
        gruntfuggly.todo-tree
      ]
      ++ lib.optionals isLinux [
        github.copilot-chat
        tomoki1207.pdf
        ltex-plus.vscode-ltex-plus
        # java
        vscjava.vscode-java-pack

        # dart/flutter
        dart-code.dart-code
        dart-code.flutter

        # go
        golang.go

        # rust
        rust-lang.rust-analyzer
        tauri-apps.tauri-vscode

        # python
        ms-python.python
        ms-python.vscode-pylance
        ms-python.black-formatter
        charliermarsh.ruff
        ms-toolsai.datawrangler
        ms-toolsai.jupyter

        # c/c++
        ms-vscode.cpptools

        # typst
        myriad-dreamin.tinymist
      ];
  };

  # This allows VS Code to edit it, while rebuild overwrites with defaults.
  home.activation.writeVscodeSettings = lib.mkIf (vsCodeUserDir != null) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${vsCodeUserDir}"
      cat > "${vsCodeUserDir}/settings.json" << 'EOF'
      ${builtins.toJSON vsCodeSettings}
      EOF
    ''
  );
}
