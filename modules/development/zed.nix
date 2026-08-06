{
  config,
  lib,
  ...
}:
let
  cfg = config.development.zed;
  enabledLanguages = lib.attrValues (lib.filterAttrs (_: language: language.enable) config.development.languages);
  collectLanguage = attrPath: lib.concatMap (lib.attrByPath attrPath [ ]) enabledLanguages;
  languageSettings = lib.foldl' lib.recursiveUpdate { } (
    map (language: language.zed.settings) enabledLanguages
  );

  defaultSettings = {
    base_keymap = "VSCode";
    vim_mode = true;
    relative_line_numbers = "enabled";
    autosave.after_delay.milliseconds = 1000;
    format_on_save = "on";
    auto_signature_help = true;
    inlay_hints.enabled = true;

    theme = {
      mode = "dark";
      dark = "Catppuccin Macchiato";
      light = "Catppuccin Latte";
    };
    icon_theme = "Catppuccin Macchiato";
    ui_font_size = 16;
    agent_font_size = 16;
    buffer_font_family = "JetBrainsMono Nerd Font";
    buffer_font_size = 14;
    terminal = {
      font_family = "JetBrainsMono Nerd Font Mono";
      font_size = 14;
      font_features = {
        calt = false;
        liga = false;
      };
      minimum_contrast = 1;
    };

    git.inline_blame = {
      enabled = true;
      show_commit_summary = true;
    };
    file_types.Markdown = [ "svx" ];

    languages = {
      JSON = {
        soft_wrap = "bounded";
        preferred_line_length = 100;
      };
      JSONC = {
        soft_wrap = "bounded";
        preferred_line_length = 100;
      };
      Markdown = {
        soft_wrap = "bounded";
        preferred_line_length = 100;
      };
    };
  };

in
{
  options.development.zed = {
    enable = lib.mkEnableOption "Zed with programs.mcp.servers integration; Catppuccin, Catppuccin Icons, Emmet, and TODO Highlight extensions; Vim mode, relative lines, autosave, format-on-save, inlay hints, Catppuccin themes, inline Git blame, JSON and Markdown wrapping, pane-navigation keybindings, and the extensions and settings contributed by the enabled languages";

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional Zed extensions.";
      example = [ "html" ];
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Zed settings merged after the bundled and enabled-language settings.";
      example.vim_mode = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      enableMcpIntegration = true;
      extensions = [
        "catppuccin"
        "catppuccin-icons"
        "emmet"
        "todo-highlight-language-server"
      ] ++ collectLanguage [ "zed" "extensions" ] ++ cfg.extensions;
      extraPackages = collectLanguage [ "zed" "packages" ];
      userSettings = lib.recursiveUpdate (lib.recursiveUpdate defaultSettings languageSettings) cfg.settings;
      userKeymaps = [
        {
          context = "Workspace";
          bindings = {
            alt-n = "pane::ActivateNextItem";
            alt-p = "pane::ActivatePreviousItem";
            alt-h = "workspace::ActivatePaneLeft";
            alt-l = "workspace::ActivatePaneRight";
            alt-k = "workspace::ActivatePaneUp";
            alt-j = "workspace::ActivatePaneDown";
          };
        }
      ];
    };
  };
}
