{
  lib,
  config,
  pkgs,
  ...
}:
let
  defaultSettings = {
    "catppuccin.accentColor" = "lavender";
    "workbench.colorTheme" = "Catppuccin Macchiato";
    "workbench.iconTheme" = "catppuccin-macchiato";

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
    "terminal.integrated.fontFamily" =
      "JetBrainsMono Nerd Font Mono, JetBrainsMono Nerd Font, Symbols Nerd Font Mono, monospace";
    "terminal.integrated.fontLigatures.enabled" = false;
    "terminal.integrated.gpuAcceleration" = "off";
    "terminal.integrated.customGlyphs" = false;
    "terminal.integrated.minimumContrastRatio" = 1;

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
    "[markdown]" = {
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 100;
    };
    "files.associations" = {
      "*.svx" = "markdown";
    };
  };

in
{
  options.development.vscode.enable = lib.mkEnableOption "VS Code with Catppuccin theme and icon, Prettier, Remote SSH, VSCodeVim, GitLens, and Todo Tree extensions; Catppuccin Macchiato, relative line numbers, format-on-save, autosave, JSON and Markdown wrapping, and the extensions and settings contributed by the enabled languages";

  config = lib.mkIf config.development.vscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          esbenp.prettier-vscode
          ms-vscode-remote.remote-ssh
          vscodevim.vim
          eamodio.gitlens
          gruntfuggly.todo-tree
        ];
        userSettings = lib.mapAttrsRecursive (_: lib.mkDefault) defaultSettings;
      };
    };
  };
}
