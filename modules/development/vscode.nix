{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    development.vscode.enable = lib.mkEnableOption "VS Code setup";

    vscode.mergedSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      internal = true;
    };
  };

  config = lib.mkIf config.development.vscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        # general/editor
        esbenp.prettier-vscode
        ms-vscode-remote.remote-ssh
        vscodevim.vim
        eamodio.gitlens

        # nix
        jnoortheen.nix-ide

        # c/c++
        ms-vscode.cpptools

        # todo
        gruntfuggly.todo-tree
      ];
      profiles.default.userSettings = config.vscode.mergedSettings;
    };

    vscode.mergedSettings = {
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
      # markdown
      "[markdown]" = {
        "editor.wordWrap" = "bounded";
        "editor.wordWrapColumn" = 100;
      };
      "files.associations" = {
        "*.svx" = "markdown";
      };

      # nix
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "nixfmt";
    };

  };
}
