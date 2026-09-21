{
  pkgs,
  lib,
  config,
  agentSources ? { },
  ...
}:
let
  cfg = config.development.agents;
  ponytail = agentSources.ponytail or null;
  cursorPlugins = agentSources.cursor-plugins or null;
  anthropicSkills = agentSources."anthropic-skills" or null;
  hasSource = source: source != null;
  claudeEnabled = config.development.claude.enable;
  codexEnabled = config.development.codex.enable;
  cursorEnabled = config.development.cursor.enable;
  opencodeEnabled = config.development.opencode.enable;

  anyAgentEnabled = claudeEnabled || cursorEnabled || codexEnabled || opencodeEnabled;
  rtkEnabled = builtins.elem "rtk" cfg.packages;

  ponytailSkills = [
    "ponytail"
    "ponytail-review"
    "ponytail-audit"
    "ponytail-debt"
    "ponytail-gain"
    "ponytail-help"
  ];
  defaultSkills =
    lib.optionalAttrs (hasSource ponytail) (
      lib.genAttrs ponytailSkills (name: "${ponytail}/skills/${name}")
    )
    // lib.optionalAttrs (builtins.elem "agent-browser" cfg.packages) {
      agent-browser = "${pkgs.agent-browser}/skills/agent-browser";
    }
    // lib.optionalAttrs (hasSource cursorPlugins) {
      unslop = "${cursorPlugins}/pstack/skills/unslop";
    }
    // lib.optionalAttrs (hasSource anthropicSkills) {
      frontend-design = "${anthropicSkills}/skills/frontend-design";
    };
  cursorSkillLinks = lib.mapAttrs' (
    name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }
  ) cfg.skills;
  cursorMcpLink = lib.optionalAttrs (
    config.programs.mcp.enable && config.programs.mcp.servers != { }
  ) {
    ".cursor/mcp.json".source = config.xdg.configFile."mcp/mcp.json".source;
  };

  relativeToHome = lib.removePrefix "${config.home.homeDirectory}/";
  agentConfigDirectories = map relativeToHome [
    "${config.home.homeDirectory}/.agents"
    "${config.home.homeDirectory}/.codex"
    config.programs.claude-code.configDir
    "${config.xdg.configHome}/codex"
    "${config.xdg.configHome}/opencode"
  ];
  isInAgentConfig =
    target:
    let
      relativeTarget = lib.removePrefix "./" target;
    in
    builtins.any (
      directory: relativeTarget == directory || lib.hasPrefix "${directory}/" relativeTarget
    ) agentConfigDirectories;
  managedAgentConfigFiles = lib.filter (file: file.enable && isInAgentConfig file.target) (
    builtins.attrValues config.home.file
  );
  materializeAgentConfigFiles = lib.filter (
    file: !(lib.hasInfix "/skills/" file.target)
  ) managedAgentConfigFiles;
  removeManagedAgentConfigs = lib.concatMapStrings (file: ''
    rm -rf "$HOME"/${lib.escapeShellArg file.target}
  '') managedAgentConfigFiles;
  materializeManagedAgentConfigs = lib.concatMapStrings (file: ''
    target="$HOME"/${lib.escapeShellArg file.target}
    mkdir -p "$(dirname "$target")"
    rm -rf "$target"
    cp -RL ${lib.escapeShellArg (toString file.source)} "$target"
    chmod -R u+w "$target"
  '') materializeAgentConfigFiles;
  cursorFiles =
    {
      ".agents/AGENTS.md".text =
        cfg.instructions
        + cfg.agentBrowserInstructions
        + lib.optionalString rtkEnabled "\n@RTK.md";
    }
    // lib.optionalAttrs (hasSource ponytail) {
      ".agents/rules/ponytail.md".source = "${ponytail}/.agents/rules/ponytail.md";
    }
    // cursorSkillLinks
    // cursorMcpLink;
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
        agent-browser = "<agent-browser>/skills/agent-browser";
        unslop = "<cursor-plugins>/pstack/skills/unslop";
        frontend-design = "<anthropic-skills>/skills/frontend-design";
      }
    '';
    description = "Complete skill set shared by Claude Code, Codex, Cursor, and OpenCode. The default contains Ponytail skills, agent-browser when selected in development.agents.packages, unslop, and Anthropic's frontend-design. Setting this option replaces all default skills.";
    example = lib.literalExpression ''
      {
        project = ./skills/project;
      }
    '';
  };

  config = {
    development.agents.skills = lib.mkDefault defaultSkills;

    home = {
      packages = lib.optionals anyAgentEnabled (
        map (name: pkgs.${name}) (
          lib.filter (name: name != "opencode-desktop" || opencodeEnabled) cfg.packages
        )
        ++ lib.optionals cursorEnabled [ pkgs.cursor-cli ]
      );

      file = lib.mkMerge [
        (lib.mkIf cursorEnabled cursorFiles)
        (lib.mkIf (rtkEnabled && opencodeEnabled) {
          # TODO: temporary, drop once rtk installs a v2-compatible OpenCode plugin itself
          ".config/opencode/plugins/rtk.ts".source = ./opencode-rtk.ts;
        })
      ];

      activation = {
        prepareWritableAgentConfigs = lib.mkIf anyAgentEnabled (
          lib.hm.dag.entryBefore [ "checkLinkTargets" ] removeManagedAgentConfigs
        );
        materializeWritableAgentConfigs = lib.mkIf anyAgentEnabled (
          lib.hm.dag.entryAfter [ "linkGeneration" ] materializeManagedAgentConfigs
        );
        rtkInit = lib.mkIf (rtkEnabled && anyAgentEnabled) (
          lib.hm.dag.entryAfter [ "materializeWritableAgentConfigs" ] ''
            export RTK_TELEMETRY_DISABLED=1
            ${lib.optionalString opencodeEnabled "${pkgs.rtk}/bin/rtk init -g || true"}
          ''
        );
      };
    };
  };
}
