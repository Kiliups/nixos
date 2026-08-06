{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.development.languages;
  builtinLanguages = import ./builtin.nix { inherit pkgs; };
  builtinNames = lib.attrNames builtinLanguages;

  languageType = lib.types.submodule (
    { name, config, ... }:
    {
      options = {
        enable = lib.mkEnableOption config.description;

        description = lib.mkOption {
          type = lib.types.str;
          default = "the ${name} language";
          description = "What development.languages.${name}.enable installs, used as the option description.";
        };

        requires = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Other languages enabled together with this one. Only honoured for the built-in languages; custom languages should enable their dependencies directly.";
          example = [ "typescript" ];
        };

        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Packages added to PATH while this language is enabled.";
          example = lib.literalExpression "with pkgs; [ bun pnpm ]";
        };

        sessionVariables = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.oneOf [
              lib.types.str
              lib.types.path
              lib.types.int
            ]
          );
          default = { };
          description = "Environment variables set while this language is enabled.";
          example = {
            JAVA_HOME = "/run/current-system/sw/lib/openjdk";
          };
        };

        vscode = {
          extensions = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "VS Code extensions installed when this language and development.vscode are both enabled.";
            example = lib.literalExpression "[ pkgs.vscode-extensions.golang.go ]";
          };

          settings = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Settings included in VS Code's bundled configuration when this language and development.vscode are both enabled.";
            example = {
              "[go]"."editor.formatOnSave" = true;
            };
          };
        };

        zed = {
          extensions = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Zed extensions installed when this language and development.zed are both enabled.";
            example = [ "golangci-lint" ];
          };

          packages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Packages added to Zed's PATH when this language and development.zed are both enabled.";
            example = lib.literalExpression "[ pkgs.nixd ]";
          };

          settings = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
            description = "Settings included in Zed's bundled configuration when this language and development.zed are both enabled.";
            example = {
              languages.Go.formatter = [ "language_server" ];
            };
          };
        };

        lazyvim = {
          extras = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "LazyVim extras imported when this language and development.lazyvim are both enabled, without the lazyvim.plugins.extras prefix.";
            example = [ "lang.go" ];
          };

          plugins = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Additional lazy.nvim plugin specs, written as comma-terminated Lua table entries, added after the extras.";
            example = ''
              { "fatih/vim-go" },
            '';
          };
        };
      };
    }
  );

  enabledLanguages = lib.filterAttrs (_: language: language.enable) cfg;
  enabledLanguageConfigs = lib.attrValues enabledLanguages;
  collectFromEnabledLanguages =
    attrPath: lib.concatMap (lib.attrByPath attrPath [ ]) enabledLanguageConfigs;

  builtinDependencyWiring = lib.genAttrs builtinNames (
    name:
    let
      dependents = lib.filter (
        other: builtins.elem name (builtinLanguages.${other}.requires or [ ])
      ) builtinNames;
    in
    {
      enable = lib.mkIf (lib.any (other: cfg.${other}.enable) dependents) true;
    }
  );

  lazyvimFile =
    name: language:
    let
      imports = lib.concatMapStrings (
        extra: "  { import = \"lazyvim.plugins.extras.${extra}\" },\n"
      ) language.lazyvim.extras;
    in
    lib.nameValuePair ".config/nvim/lua/plugins/extras/${name}.lua" {
      text = ''
        return {
        ${imports}${language.lazyvim.plugins}}
      '';
    };
in
{
  options.development.languages = lib.mkOption {
    type = lib.types.attrsOf languageType;
    default = { };
    description = "Language toolchains, each wiring its packages, VS Code extensions and settings, Zed extensions and settings, and LazyVim extras into the enabled editors. C and Nix are enabled by default. The built-in languages are ${lib.concatStringsSep ", " builtinNames}; adding an attribute defines a new one.";
    example = lib.literalExpression ''
      {
        go.enable = true;
        typescript.packages = [ pkgs.bun ];
        elixir = {
          enable = true;
          packages = [ pkgs.elixir ];
          lazyvim.extras = [ "lang.elixir" ];
        };
      }
    '';
  };

  config = lib.mkMerge [
    {
      development.languages = lib.mkMerge [
        builtinLanguages
        builtinDependencyWiring
      ];
    }

    (lib.mkIf config.development.full.enable {
      development.languages = lib.genAttrs builtinNames (_: {
        enable = lib.mkDefault true;
      });
    })

    {
      home = {
        packages = collectFromEnabledLanguages [ "packages" ];
        sessionVariables = lib.mkMerge (map (language: language.sessionVariables) enabledLanguageConfigs);
      };
    }

    (lib.mkIf config.development.lazyvim.enable {
      home.file = lib.mkDefault (
        lib.mapAttrs' lazyvimFile (
          lib.filterAttrs (
            _: language: language.lazyvim.extras != [ ] || language.lazyvim.plugins != ""
          ) enabledLanguages
        )
      );
    })
  ];
}
