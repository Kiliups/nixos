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
  options.languages.python.enable = lib.mkEnableOption "Python setup";

  config = lib.mkIf config.languages.python.enable (
    lib.mkMerge [
      (lib.mkIf config.development.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          ms-python.python
          ms-python.vscode-pylance
          ms-python.black-formatter
          charliermarsh.ruff
          ms-toolsai.datawrangler
          ms-toolsai.jupyter
        ];

        vscode.mergedSettings = {
          "[python]" = {
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "ms-python.black-formatter";
            "editor.codeActionsOnSave" = {
              "source.organizeImports" = "explicit";
              "source.fixAll" = "explicit";
            };
          };
          "python.languageServer" = "Pylance";
          "python.analysis.typeCheckingMode" = "basic";
          "python.analysis.autoImportCompletions" = true;
          "python.analysis.diagnosticMode" = "workspace";
          "python.analysis.inlayHints.functionReturnTypes" = true;
          "python.analysis.inlayHints.variableTypes" = true;
        };
      })

      (lib.mkIf config.development.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/python.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.python" },
            }
          '';
        };
      })
    ]
  );
}
