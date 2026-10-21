{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.development.zed;
  enabledLanguages = lib.attrValues (
    lib.filterAttrs (_: language: language.enable) config.development.languages
  );
  collectLanguage = attrPath: lib.concatMap (lib.attrByPath attrPath [ ]) enabledLanguages;
  languageSettings = lib.foldl' lib.recursiveUpdate { } (
    map (language: language.zed.settings) enabledLanguages
  );

  defaultSettings = {
    vim_mode = true;
    autosave.after_delay.milliseconds = 1000;
    relative_line_numbers = "enabled";
    format_on_save = "on";
    theme = {
      mode = "dark";
      dark = "Catppuccin Macchiato";
      light = "Catppuccin Latte";
    };
    icon_theme = "Catppuccin Macchiato";

    agent = {
      dock = "right";
      flexible = false;
      default_width = 600;
      limit_content_width = false;
      enable_feedback = false;
      expand_edit_card = false;
      expand_terminal_card = false;
      thinking_display = "always_collapsed";
      use_modifier_to_send = false;
      message_editor_min_lines = 2;
      show_turn_stats = true;
      threads_sidebar = {
        position = "left";
        default_width = 200;
      };
    };
    project_panel = {
      dock = "left";
      default_width = 200;
    };

    git_panel = {
      dock = "left";
      default_width = 200;
    };
    terminal = {
      dock = "bottom";
      default_height = 125;
      starts_open = true;
    };
    bottom_dock_layout = "full";
  };

in
{
  options.development.zed = {
    enable = lib.mkEnableOption "Zed patched to hide terminal tab headers and disable resizing, with Vim mode, a fixed hdl-style layout (editor/agent 60/40, full-width terminal below at 15% height), Herdr-style Ctrl+Space keybindings for the agent panel, sidebar, Git panel, terminal splits, closing panes, and zoom, Ctrl+Alt+H/J/K/L pane navigation shared with Herdr, mutable settings and keymaps, programs.mcp.servers integration, and enabled-language extensions and settings";

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional Zed extensions.";
      example = [ "html" ];
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Zed settings overriding the bundled and enabled-language defaults via native Nix option merging. Settings and keymaps are writable in Zed; Nix-declared values are reapplied on activation, while other edits are preserved.";
      example.vim_mode = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.callPackage ../../packages/zed-editor { };
      enableMcpIntegration = true;
      extensions = [
        "catppuccin"
        "catppuccin-icons"
      ]
      ++ collectLanguage [
        "zed"
        "extensions"
      ]
      ++ cfg.extensions;
      extraPackages = collectLanguage [
        "zed"
        "packages"
      ];
      userSettings = lib.mkMerge [
        (lib.mapAttrsRecursive (_: lib.mkDefault) (lib.recursiveUpdate defaultSettings languageSettings))
        cfg.settings
      ];
      userKeymaps = [
        {
          bindings = {
            "ctrl-space a" = "agent::ToggleFocus";
            "ctrl-space b" = "multi_workspace::ToggleWorkspaceSidebar";
            "ctrl-space e" = "project_panel::Toggle";
            "ctrl-space g" = "git_panel::Toggle";
            "ctrl-space h" = "pane::SplitHorizontal";
            "ctrl-space v" = "pane::SplitVertical";
            "ctrl-space x" = "pane::CloseAllItems";
            "ctrl-space z" = "workspace::ToggleZoom";
            "ctrl-alt-h" = "workspace::ActivatePaneLeft";
            "ctrl-alt-l" = "workspace::ActivatePaneRight";
            "ctrl-alt-k" = "workspace::ActivatePaneUp";
            "ctrl-alt-j" = "workspace::ActivatePaneDown";
          };
        }
      ];
    };
  };
}
