{
  pkgs,
  lib,
  config,
  ...
}:
let
  vars = import ./lib.nix;
  cfg = config.languages.typescript;
  packageManagerPackages = {
    bun = [ pkgs.bun ];
    yarn-berry = [ pkgs.yarn-berry ];
  };
in
{
  options.languages.typescript = {
    enable = lib.mkEnableOption "TypeScript setup";

    packageManager = lib.mkOption {
      type = lib.types.enum [
        "bun"
        "yarn-berry"
      ];
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [ pkgs.nodejs ] ++ packageManagerPackages.${cfg.packageManager};
      }

      (lib.mkIf config.dev.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/typescript.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.typescript" },
            }
          '';
        };
      })
    ]
  );
}
