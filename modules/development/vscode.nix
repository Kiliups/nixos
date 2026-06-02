{
  pkgs,
  lib,
  config,
  ...
}:
let
  vsCodeUserDir =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support/Code/User"
    else
      "${config.home.homeDirectory}/.config/Code/User";
in
{

  options = {
    dev.vscode.enable = lib.mkEnableOption "VS Code setup";

    vscode.mergedSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      internal = true;
    };
  };

  config = lib.mkIf config.dev.vscode.enable {
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

    # This allows VS Code to edit it, while rebuild overwrites with defaults.
    home.activation.writeVscodeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "${vsCodeUserDir}"
          cat > "${vsCodeUserDir}/settings.json" << 'EOF'
          ${builtins.toJSON config.vscode.mergedSettings}
      EOF
    '';

    # VS Code can cache a broken per-profile extension inventory in ~/.vscode/extensions
    # and then hide Nix-managed extensions until that metadata is cleared.
    home.activation.resetVscodeExtensionState = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rm -f "${config.home.homeDirectory}/.vscode/extensions/.obsolete"
      rm -f "${config.home.homeDirectory}/.vscode/extensions/extensions.json"
    '';
  };
}
