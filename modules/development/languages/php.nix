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
  options.languages.php.enable = lib.mkEnableOption "PHP setup";

  config = lib.mkIf config.languages.php.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          php
        ];
      }

      (lib.mkIf config.dev.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          # TODO make platform independent
          xdebug.php-debug
        ];
      })

      (lib.mkIf config.dev.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/php.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.php" },
            }
          '';
        };
      })
    ]
  );
}
