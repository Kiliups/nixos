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

  options.languages.vue.enable = lib.mkEnableOption "Vue setup";

  config = lib.mkIf config.languages.vue.enable (
    lib.mkMerge [
      {
        languages.typescript.enable = true;
      }

      (lib.mkIf config.development.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          vue.volar
        ];
      })

      (lib.mkIf config.development.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/vue.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.vue" },
            }
          '';
        };
      })
    ]
  );
}
