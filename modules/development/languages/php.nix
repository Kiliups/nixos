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
          ms-php.php
          ms-php.debugger
          ms-php.intellisense
          ms-php.composer
        ];

        vscode.mergedSettings = {
          "[php]" = {
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "ms-php.php";
            "editor.codeActionsOnSave" = {
              "source.organizeImports" = "explicit";
              "source.fixAll" = "explicit";
            };
          };
          "php.languageServer" = "PHP";
          "php.analysis.typeCheckingMode" = "basic";
          "php.analysis.autoImportCompletions" = true;
          "php.analysis.diagnosticMode" = "workspace";
          "php.analysis.inlayHints.functionReturnTypes" = true;
          "php.analysis.inlayHints.variableTypes" = true;
        };
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
