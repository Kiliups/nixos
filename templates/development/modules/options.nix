{
  nixpkgs,
  home-manager,
  development,
}:
let
  inherit (nixpkgs) lib;
  pkgs = import nixpkgs { system = "x86_64-linux"; };
  evaluated = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      development
      {
        home = {
          username = "docs";
          homeDirectory = "/tmp/docs";
          stateVersion = "26.11";
        };
      }
    ];
  };
  collect =
    prefix: options:
    lib.concatLists (
      lib.mapAttrsToList (
        name: option:
        if option._type or null == "option" then
          [
            {
              inherit option;
              name = lib.concatStringsSep "." (prefix ++ [ name ]);
            }
          ]
        else if builtins.isAttrs option then
          collect (prefix ++ [ name ]) option
        else
          [ ]
      ) options
    );
  options =
    collect [ "development" ] evaluated.options.development
    ++ collect [ "programs" "mcp" ] evaluated.options.programs.mcp;
  renderValue =
    value:
    lib.replaceStrings [ "\n  \n" ] [ "\n\n" ] (
      if value._type or null == "literalExpression" then value.text else lib.generators.toPretty { } value
    );
  renderDefault = option: renderValue (option.defaultText or option.default);
  render =
    { name, option }:
    ''
      ## `${name}`

      ${lib.replaceStrings [ "{file}" "{option}" ] [ "" "" ] option.description}

      Type: `${option.type.description}`

    ''
    + lib.optionalString (option ? defaultText || option.type.description != "absolute path") ''
      Default:

      ```nix
      ${renderDefault option}
      ```

    ''
    + lib.optionalString (option ? example) ''
      Example:

      ```nix
      ${renderValue option.example}
      ```

    '';
in
lib.removeSuffix "\n" (
  ''
    # Development options

    This file is generated from the option metadata in
    [`kiliups/nixos`](https://github.com/kiliups/nixos/tree/main/modules/development).
    Do not edit it manually.

    Set options in your Home Manager configuration:

    ```nix
    {
      development.shell.enable = true;
      development.herdr.config = builtins.readFile ./herdr.toml;
      development.tmux.config = builtins.readFile ./tmux.conf;
      development.lazyvim.config = ./nvim;
      development.agents.packages = [ "agent-browser" ];
      development.agents.skills = {
        project = ./skills/project;
      };
      development.languages.go.enable = false;
    }
    ```

    ## MCP server integration

    Enabling any AI agent also enables Home Manager's shared MCP registry.
    Define servers once under `programs.mcp.servers`; Claude Code, Codex, and
    OpenCode receive them automatically. Zed also receives them when
    `development.zed.enable` is enabled. Cursor CLI is not currently connected
    to the shared registry and requires its own MCP configuration.
  ''
  + lib.concatMapStrings render options
)
