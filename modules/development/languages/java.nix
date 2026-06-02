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
  options.languages.java.enable = lib.mkEnableOption "Java setup";

  config = lib.mkIf config.languages.java.enable (
    lib.mkMerge [
      {
        # TODO
        home.sessionVariables = {
          JAVA_HOME = "${pkgs.jdk25}/lib/openjdk";
        };

        home.packages = with pkgs; [
          jdk25
          maven
          gradle
        ];
      }

      (lib.mkIf config.dev.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          vscjava.vscode-java-pack
          oracle.oracle-java
        ];
      })

      (lib.mkIf config.dev.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/java.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.java" },
            }
          '';
        };
      })
    ]
  );
}
