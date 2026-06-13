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

      (lib.mkIf config.development.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          bmewburn.vscode-intelephense-client
          xdebug.php-debug
        ];
      })

      (lib.mkIf config.development.lazyvim.enable {
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
