{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.development.zed.enable = lib.mkEnableOption "Zed setup";

  config = lib.mkIf config.development.zed.enable {
    programs.zed-editor = {
      enable = true;
      extraPackages = with pkgs; [
        nixd
        nixfmt
      ];

      extensions = [
        "angular"
        "astro"
        "catppuccin"
        "catppuccin-icons"
        "emmet"
        "golangci-lint"
        "java"
        "ltex"
        "nix"
        "php"
        "svelte"
        "todo-highlight-language-server"
        "typst"
        "vue"
      ];

      userSettings = {
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
        buffer_font_family = "JetBrainsMono Nerd Font";
        terminal = {
          font_family = "JetBrainsMono Nerd Font Mono";
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
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];
            formatter.external = {
              command = "nixfmt";
              arguments = [ ];
            };
          };
          Go.formatter = [
            "language_server"
            { code_action = "source.organizeImports"; }
          ];
        };

        lsp.nixd.binary.path = "nixd";
      };

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
