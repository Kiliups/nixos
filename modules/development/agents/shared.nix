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
  hasSource = source: source != null;

  anyAgentEnabled =
    config.development.claude.enable
    || config.development.cursor.enable
    || config.development.codex.enable
    || config.development.opencode.enable;
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
      lib.listToAttrs (map (name: lib.nameValuePair name "${ponytail}/skills/${name}") ponytailSkills)
    )
    // lib.optionalAttrs (builtins.elem "agent-browser" cfg.packages) {
      agent-browser = "${pkgs.agent-browser}/skills/agent-browser";
    }
    // lib.optionalAttrs (hasSource cursorPlugins) {
      unslop = "${cursorPlugins}/pstack/skills/unslop";
    };
  sharedSkillLinks = lib.mapAttrs' (
    name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }
  ) cfg.skills;

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
  removeManagedAgentConfigs = lib.concatMapStrings (file: ''
    rm -rf "$HOME"/${lib.escapeShellArg file.target}
  '') managedAgentConfigFiles;
  materializeManagedAgentConfigs = lib.concatMapStrings (file: ''
    target="$HOME"/${lib.escapeShellArg file.target}
    mkdir -p "$(dirname "$target")"
    rm -rf "$target"
    cp -RL ${lib.escapeShellArg (toString file.source)} "$target"
    chmod -R u+w "$target"
  '') managedAgentConfigFiles;
in
{
  options.development.agents.skills = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = defaultSkills;
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
      }
    '';
    description = "Complete skill set shared by Claude Code, Codex, Cursor, and OpenCode. The default contains Ponytail skills, agent-browser when selected in development.agents.packages, and unslop. Setting this option replaces all default skills.";
    example = lib.literalExpression ''
      {
        project = ./skills/project;
      }
    '';
  };

  config = {
    home.packages = lib.optionals anyAgentEnabled (
      map (name: pkgs.${name}) (
        lib.filter (name: name != "opencode-desktop" || config.development.opencode.enable) cfg.packages
      )
      ++ lib.optionals config.development.cursor.enable [ pkgs.cursor-cli ]
    );

    home.file = lib.mkIf config.development.cursor.enable (
      {
        ".agents/AGENTS.md".text = cfg.instructions + cfg.agentBrowserInstructions + lib.optionalString rtkEnabled "\n@RTK.md";
      }
      // lib.optionalAttrs (hasSource ponytail) {
        ".agents/rules/ponytail.md".source = "${ponytail}/.agents/rules/ponytail.md";
      }
      // sharedSkillLinks
    );

    # Agents update their configuration interactively, so managed entries cannot remain store symlinks.
    home.activation.prepareWritableAgentConfigs = lib.mkIf anyAgentEnabled (
      lib.hm.dag.entryBefore [ "checkLinkTargets" ] removeManagedAgentConfigs
    );
    home.activation.materializeWritableAgentConfigs = lib.mkIf anyAgentEnabled (
      lib.hm.dag.entryAfter [ "linkGeneration" ] materializeManagedAgentConfigs
    );

    home.activation.rtkInit = lib.mkIf (rtkEnabled && anyAgentEnabled) (
      lib.hm.dag.entryAfter [ "materializeWritableAgentConfigs" ] ''
        export RTK_TELEMETRY_DISABLED=1
        ${lib.optionalString config.development.opencode.enable "${pkgs.rtk}/bin/rtk init -g --opencode || true"}
      ''
    );
  };
}
