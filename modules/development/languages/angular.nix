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

  options.languages.angular.enable = lib.mkEnableOption "Angular setup";

  config = lib.mkIf config.languages.angular.enable (
    lib.mkMerge [
      {
        languages.typescript.enable = true;

        home.packages = [ pkgs.angular-language-server ];
      }

      (lib.mkIf config.development.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          angular.ng-template
        ];
      })

      (lib.mkIf config.development.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/angular.lua" = {
          text = ''
            return {
              { import = "lazyvim.plugins.extras.lang.angular" },
            }
          '';
        };
      })
    ]
  );
}
