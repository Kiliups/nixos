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
  imports = [ ./typescript.nix ];

  options.languages.astro.enable = lib.mkEnableOption "Astro setup";

  config = lib.mkIf config.languages.astro.enable (
    lib.mkMerge [
      {
        languages.typescript.enable = true;
      }

      (lib.mkIf config.dev.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          astro-build.astro-vscode
        ];

        vscode.mergedSettings = {
          "[astro]" = {
            "editor.defaultFormatter" = "astro-build.astro-vscode";
            "editor.formatOnSave" = true;
          };
          "prettier.documentSelectors" = [ "**/*.astro" ];
        };
      })

      (lib.mkIf config.dev.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/astro.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.astro" },
            }
          '';
        };
      })
    ]
  );
}
