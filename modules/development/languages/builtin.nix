{ pkgs }:
let
  vs = pkgs.vscode-extensions;
in
{
  angular = {
    description = "angular-language-server and the typescript language; adds the Angular Language Service extension to VS Code, the Angular extension to Zed, and the LazyVim Angular extra";
    requires = [ "typescript" ];
    packages = [ pkgs.angular-language-server ];
    vscode.extensions = [ vs.angular.ng-template ];
    zed.extensions = [ "angular" ];
    lazyvim.extras = [ "lang.angular" ];
  };

  astro = {
    description = "the typescript language; adds Astro for VS Code with format-on-save and Prettier document selection, the Astro extension to Zed, and the LazyVim Astro extra";
    requires = [ "typescript" ];
    vscode = {
      extensions = [ vs.astro-build.astro-vscode ];
      settings = {
        "[astro]" = {
          "editor.defaultFormatter" = "astro-build.astro-vscode";
          "editor.formatOnSave" = true;
        };
        "prettier.documentSelectors" = [ "**/*.astro" ];
      };
    };
    zed.extensions = [ "astro" ];
    lazyvim.extras = [ "lang.astro" ];
  };

  c = {
    enable = true;
    description = "GCC and GDB; adds the Microsoft C/C++ extension to VS Code";
    packages = with pkgs; [
      gcc
      gdb
    ];
    vscode.extensions = [ vs.ms-vscode.cpptools ];
  };

  go = {
    description = "Go and golangci-lint; adds the Go extension with format-on-save, import organization, gopls, and golangci-lint settings to VS Code, the golangci-lint extension and import organization to Zed, and the LazyVim Go extra";
    packages = with pkgs; [
      go
      golangci-lint
    ];
    vscode = {
      extensions = [ vs.golang.go ];
      settings = {
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
      };
    };
    zed = {
      extensions = [ "golangci-lint" ];
      settings.languages.Go.formatter = [
        "language_server"
        { code_action = "source.organizeImports"; }
      ];
    };
    lazyvim.extras = [ "lang.go" ];
  };

  java = {
    description = "JDK 25, Maven, Gradle, and JAVA_HOME; adds the VS Code Extension Pack for Java and the Oracle Java extension, the Java extension to Zed, and the LazyVim Java extra";
    packages = with pkgs; [
      jdk25
      maven
      gradle
    ];
    sessionVariables.JAVA_HOME = "${pkgs.jdk25}/lib/openjdk";
    vscode.extensions = [
      vs.vscjava.vscode-java-pack
      vs.oracle.oracle-java
    ];
    zed.extensions = [ "java" ];
    lazyvim.extras = [ "lang.java" ];
  };

  nix = {
    enable = true;
    description = "nixd, nixfmt, and statix; adds nix-ide with nixd and nixfmt settings to VS Code, the Nix extension with nixd and nixfmt to Zed, and the LazyVim Nix extra";
    packages = with pkgs; [
      nixd
      nixfmt
      statix
    ];
    lazyvim.extras = [ "lang.nix" ];
    vscode = {
      extensions = [ vs.jnoortheen.nix-ide ];
      settings = {
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "nixfmt";
      };
    };
    zed = {
      extensions = [ "nix" ];
      packages = with pkgs; [
        nixd
        nixfmt
      ];
      settings = {
        languages.Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter.external = {
            command = "nixfmt";
            arguments = [ ];
          };
        };
        lsp.nixd.binary.path = "nixd";
      };
    };
  };

  php = {
    description = "PHP; adds Intelephense and PHP Debug to VS Code, the PHP extension to Zed, and the LazyVim PHP extra";
    packages = [ pkgs.php ];
    vscode.extensions = [
      vs.bmewburn.vscode-intelephense-client
      vs.xdebug.php-debug
    ];
    zed.extensions = [ "php" ];
    lazyvim.extras = [ "lang.php" ];
  };

  python = {
    description = "Python editor support without installing a Python interpreter: adds Python, Pylance, Black Formatter, Ruff, Data Wrangler, and Jupyter extensions with formatting, import, type-checking, and inlay-hint settings to VS Code, plus the LazyVim Python extra";
    vscode = {
      extensions = [
        vs.ms-python.python
        vs.ms-python.vscode-pylance
        vs.ms-python.black-formatter
        vs.charliermarsh.ruff
        vs.ms-toolsai.datawrangler
        vs.ms-toolsai.jupyter
      ];
      settings = {
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
      };
    };
    lazyvim.extras = [ "lang.python" ];
  };

  rust = {
    description = "cargo, rustc, rustfmt, and Clippy; adds rust-analyzer and Tauri extensions with format-on-save to VS Code and the LazyVim Rust extra";
    packages = with pkgs; [
      cargo
      rustc
      rustfmt
      clippy
    ];
    vscode = {
      extensions = [
        vs.rust-lang.rust-analyzer
        vs.tauri-apps.tauri-vscode
      ];
      settings."[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        "editor.formatOnSave" = true;
      };
    };
    lazyvim.extras = [ "lang.rust" ];
  };

  svelte = {
    description = "the typescript language; adds the Svelte for VS Code extension with format-on-save, the Svelte extension to Zed, and the LazyVim Svelte extra";
    requires = [ "typescript" ];
    vscode = {
      extensions = [ vs.svelte.svelte-vscode ];
      settings."[svelte]" = {
        "editor.defaultFormatter" = "svelte.svelte-vscode";
        "editor.formatOnSave" = true;
      };
    };
    zed.extensions = [ "svelte" ];
    lazyvim.extras = [ "lang.svelte" ];
  };

  typescript = {
    description = "Node.js, TypeScript Language Server, and the LazyVim TypeScript extra";
    packages = with pkgs; [
      nodejs
      typescript-language-server
    ];
    lazyvim.extras = [ "lang.typescript" ];
  };

  typst = {
    description = "Typst, Tinymist, LTeX LS Plus, and websocat; adds Tinymist, PDF, and LTeX Plus extensions to VS Code, the LTeX and Typst extensions to Zed, and the LazyVim Typst extra with typst-preview.nvim and Tinymist LSP configuration";
    packages = with pkgs; [
      typst
      tinymist
      ltex-ls-plus
      websocat
    ];
    vscode = {
      extensions = [
        vs.myriad-dreamin.tinymist
        vs.tomoki1207.pdf
        vs."ltex-plus".vscode-ltex-plus
      ];
      settings = {
        "[typst]"."editor.formatOnSave" = true;
        "ltex.language" = "en-US";
        "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
      };
    };
    zed.extensions = [
      "ltex"
      "typst"
    ];
    lazyvim = {
      extras = [ "lang.typst" ];
      plugins = ''
        {
          "chomosuke/typst-preview.nvim",
          opts = {
            open_cmd = 'chromium --app="%s"',
            dependencies_bin = {
              tinymist = "${pkgs.tinymist}/bin/tinymist",
              websocat = "websocat",
            },
          },
        },
        {
          "neovim/nvim-lspconfig",
          opts = {
            servers = {
              tinymist = {
                cmd = { "${pkgs.tinymist}/bin/tinymist" },
              },
            },
          },
        },
      '';
    };
  };

  vue = {
    description = "the typescript language; adds the Volar extension to VS Code, the Vue extension to Zed, and the LazyVim Vue extra";
    requires = [ "typescript" ];
    vscode.extensions = [ vs.vue.volar ];
    zed.extensions = [ "vue" ];
    lazyvim.extras = [ "lang.vue" ];
  };
}
