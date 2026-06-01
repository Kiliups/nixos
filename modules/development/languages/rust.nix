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
  options.languages.rust.enable = lib.mkEnableOption "Rust setup";

  config = lib.mkIf config.languages.rust.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          # rust
          cargo
          rustc
          rustfmt
          clippy
        ];
      }

      (lib.mkIf config.dev.vscode.enable {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          rust-lang.rust-analyzer
          tauri-apps.tauri-vscode
        ];

        vscode.mergedSettings = {
          "[rust]" = {
            "editor.defaultFormatter" = "rust-lang.rust-analyzer";
            "editor.formatOnSave" = true;
          };
        };
      })

      (lib.mkIf config.dev.lazyvim.enable {
        home.file."${vars.nvimPluginDir}/rust.lua" = {
          text = ''
            return   {
                { import = "lazyvim.plugins.extras.lang.rust" },
            }
          '';
        };
      })
    ]
  );
}
