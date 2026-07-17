{
  pkgs,
  lib,
  config,
  ...
}:
let
  vars = import ./lib.nix;
in
{
  options.languages.typst.enable = lib.mkEnableOption "Typst setup";

  config = lib.mkIf config.languages.typst.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          typst
          tinymist
          ltex-ls-plus
          websocat
        ];
      }

      (lib.mkIf config.development.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          myriad-dreamin.tinymist
          tomoki1207.pdf
          ltex-plus.vscode-ltex-plus
        ];

        vscode.mergedSettings = {
          "[typst]" = {
            "editor.formatOnSave" = true;
          };
          "ltex.language" = "en-US";
          "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
        };
      })

      (lib.mkIf config.development.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/typst.lua" = {
          text = ''
            return {
              { import = "lazyvim.plugins.extras.lang.typst" },
              {
                "chomosuke/typst-preview.nvim",
                opts = {
                  open_cmd = 'chromium --app="%s"',
                  dependencies_bin = {
                    -- ponytail: bypass Mason's dynamically-linked Tinymist on NixOS.
                    tinymist = "${pkgs.tinymist}/bin/tinymist",
                    websocat = "websocat",
                  },
                },
                init = function()
                  if vim.env.XDG_CURRENT_DESKTOP == "niri" then
                    vim.api.nvim_create_autocmd("BufEnter", {
                      pattern = "*.typ",
                      once = true,
                      command = "TypstPreview",
                    })
                  end
                end,
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
            }
          '';
        };
      })
    ]
  );
}
