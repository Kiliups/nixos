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
        ];
      }

      (lib.mkIf config.dev.vscode.enable {
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

      (lib.mkIf config.dev.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/typst.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.typst" },
            }
          '';
        };
      })
    ]
  );
}
