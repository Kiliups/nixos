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
      threads_sidebar = {
        position = "left";
        default_width = 200;
      };
    };
    project_panel.dock = "left";

    git_panel.dock = "left";
    terminal = {
      dock = "bottom";
      default_height = 150;
    };
    bottom_dock_layout = "full";
  };

in
{
  options.development.zed = {
    enable = lib.mkEnableOption "Zed patched to hide terminal tab headers, with Vim mode, an hdl-style layout (threads left, agent right, terminal below), Herdr-style Ctrl+Space keybindings for the sidebar, Git panel, terminal splits, closing panes, and zoom, Alt+HJKL pane navigation, mutable settings and keymaps, programs.mcp.servers integration, and enabled-language extensions and settings";

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
      package = pkgs.zed-editor.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          # Hide the terminal panel tab bar.
          substituteInPlace crates/terminal_view/src/terminal_panel.rs \
            --replace-fail 'pane.set_should_display_tab_bar(|_, _| true);' \
              'pane.set_should_display_tab_bar(|_, _| false);'

          # Add breathing room above the terminal content (0.5 rem).
          sed -i '/terminal-view-container/ { N; s/\.size_full()/.pt_2().size_full()/; }' \
            crates/terminal_view/src/terminal_view.rs
        '';
      });
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
            "ctrl-space b" = "multi_workspace::ToggleWorkspaceSidebar";
            "ctrl-space e" = "workspace::ToggleLeftDock";
            "ctrl-space g" = "git_panel::ToggleFocus";
            "ctrl-space h" = "pane::SplitHorizontal";
            "ctrl-space v" = "pane::SplitVertical";
            "ctrl-space x" = "pane::CloseAllItems";
            "ctrl-space z" = "workspace::ToggleZoom";
          };
        }
        {
          context = "Workspace";
          bindings = {
            "alt-h" = "workspace::ActivatePaneLeft";
            "alt-l" = "workspace::ActivatePaneRight";
            "alt-k" = "workspace::ActivatePaneUp";
            "alt-j" = "workspace::ActivatePaneDown";
          };
        }
      ];
    };
  };
}
