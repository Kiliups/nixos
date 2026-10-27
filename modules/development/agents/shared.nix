{
  config,
  lib,
  pkgs,
  agentPackages,
  agentSources,
  anyAgentEnabled,
  ...
}:
let
  cfg = config.development.agents;
  inherit (agentSources)
    ponytail
    matt-pocock-skills
    cursor-plugins
    anthropic-skills
    rea
    ;
  cursorEnabled = config.development.cursor.enable;
  opencodeEnabled = config.development.opencode.enable;

  ponytailSkills = [
    "ponytail"
    "ponytail-review"
    "ponytail-audit"
    "ponytail-debt"
    "ponytail-gain"
    "ponytail-help"
  ];
  collectSkills =
    root:
    map (file: builtins.unsafeDiscardStringContext (lib.removePrefix "${root}/" (dirOf file))) (
      lib.filter (file: baseNameOf file == "SKILL.md") (lib.filesystem.listFilesRecursive root)
    );
  defaultSkills =
    lib.genAttrs ponytailSkills (name: "${ponytail}/skills/${name}")
    // lib.listToAttrs (
      map (name: lib.nameValuePair "matt-pocock/${name}" "${matt-pocock-skills}/skills/${name}") (
        collectSkills "${matt-pocock-skills}/skills"
      )
    )
    // {
      unslop = "${cursor-plugins}/pstack/skills/unslop";
      frontend-design = "${anthropic-skills}/skills/frontend-design";
      reverse-engineer-anything = "${rea}/.agents/skills/reverse-engineer-anything";
    };

  packageByName = {
    inherit (pkgs) nodejs;
    opencode-desktop = agentPackages.opencode2-desktop;
  };
in
{
  options.development.agents.skills = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = { };
    defaultText = lib.literalExpression ''
      {
        ponytail = "<ponytail>/skills/ponytail";
        ponytail-review = "<ponytail>/skills/ponytail-review";
        ponytail-audit = "<ponytail>/skills/ponytail-audit";
        ponytail-debt = "<ponytail>/skills/ponytail-debt";
        ponytail-gain = "<ponytail>/skills/ponytail-gain";
        ponytail-help = "<ponytail>/skills/ponytail-help";
        "matt-pocock/<category>/<skill>" = "<matt-pocock-skills>/skills/<category>/<skill>";
        unslop = "<cursor-plugins>/pstack/skills/unslop";
        frontend-design = "<anthropic-skills>/skills/frontend-design";
        reverse-engineer-anything = "<rea>/.agents/skills/reverse-engineer-anything";
      }
    '';
    description = "Complete skill set shared by Claude Code, Codex, Cursor, and OpenCode. The default contains Ponytail skills, every Matt Pocock skill, unslop, Anthropic's frontend-design, and REA's reverse-engineer-anything. Skills set here are merged into the default set, so a single entry only adds one skill. Use `lib.mkForce` to replace the default set entirely.";
    example = lib.literalExpression ''
      {
        project = ./skills/project;
      }
    '';
  };

  config = {
    development.agents.skills = defaultSkills;

    home = {
      packages = lib.optionals anyAgentEnabled (
        map (name: packageByName.${name} or agentPackages.${name}) (
          lib.filter (name: name != "opencode-desktop" || opencodeEnabled) cfg.packages
        )
        ++ lib.optional cursorEnabled agentPackages.cursor-agent
      );

      file = lib.mkIf cursorEnabled (
        {
          ".agents/AGENTS.md".text = cfg.instructions;
          ".agents/rules/ponytail.md".source = "${ponytail}/.agents/rules/ponytail.md";
        }
        // lib.mapAttrs' (
          name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }
        ) cfg.skills
        // lib.optionalAttrs (config.programs.mcp.enable && config.programs.mcp.servers != { }) {
          ".cursor/mcp.json".source = config.xdg.configFile."mcp/mcp.json".source;
        }
      );
    };
  };
}
