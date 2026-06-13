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
  options.languages.svelte.enable = lib.mkEnableOption "Svelte setup";

  config = lib.mkIf config.languages.svelte.enable (
    lib.mkMerge [
      {
        languages.typescript.enable = true;
      }

      (lib.mkIf config.development.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          svelte.svelte-vscode
        ];

        vscode.mergedSettings = {
          "[svelte]" = {
            "editor.defaultFormatter" = "svelte.svelte-vscode";
            "editor.formatOnSave" = true;
          };
        };
      })

      (lib.mkIf config.development.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/svelte.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.svelte" },
            }
          '';
        };
      })
    ]
  );
}
