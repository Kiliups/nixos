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
  options.languages.go.enable = lib.mkEnableOption "Go setup";

  config = lib.mkIf config.languages.go.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          go
          golangci-lint
        ];
      }

      (lib.mkIf config.development.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          golang.go
        ];

        vscode.mergedSettings = {
          "[go]" = {
            "editor.defaultFormatter" = "golang.go";
            "editor.formatOnSave" = true;
            "editor.codeActionsOnSave" = {
              "source.organizeImports" = "explicit";
            };
          };
          "go.lintTool" = "golangci-lint";
          "go.lintOnSave" = "package";
          "go.lintFlags" = [ "--fast" ];
          "go.useLanguageServer" = true;
        };
      })

      (lib.mkIf config.development.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/go.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.go" },
            }
          '';
        };
      })
    ]
  );
}
