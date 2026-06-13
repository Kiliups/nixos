{
  pkgs,
  lib,
  config,
  ...
}:
let
  vars = import ./lib.nix;
  cfg = config.languages.typescript;
in
{
  options.languages.typescript = {
    enable = lib.mkEnableOption "TypeScript setup";

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra packages for TypeScript projects.";
      example = lib.literalExpression "with pkgs; [ bun pnpm yarn-berry ]";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [ pkgs.nodejs ] ++ cfg.extraPackages;
      }

      (lib.mkIf config.development.lazyvim.enable {
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
