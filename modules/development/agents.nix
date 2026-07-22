{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (inputs) ponytail;
  mattPocockSkills = inputs.matt-pocock-skills;
  playwrightCli = inputs.playwright-cli;
  agentInstructions = ''
    # Agent Instructions

    - Make the smallest idiomatic code change that solves the task.
    - Preserve the project's existing style, structure, and conventions.
    - For browser automation or web testing, use `playwright-cli`. See the skill at `.agents/skills/playwright-cli/SKILL.md` (or `.claude/skills/playwright-cli/SKILL.md`) for the full command reference. Run `playwright-cli show` to open the live monitoring dashboard.
  '';
  opencodeReviewer = ''
    ---
    description: Two-axis code reviewer combining Matt Pocock's code-review skill with ponytail's over-engineering lens. Use when asked to review a branch, PR, or diff since a fixed point.
    mode: primary
    permission:
      edit: deny
      bash: allow 
    ---
  ''
  + builtins.readFile "${mattPocockSkills}/skills/engineering/code-review/SKILL.md"
  + builtins.readFile "${ponytail}/skills/ponytail/SKILL.md";
  ponytailSkills = [
    "ponytail"
    "ponytail-review"
    "ponytail-audit"
    "ponytail-debt"
    "ponytail-gain"
    "ponytail-help"
  ];
  agentSkills =
    lib.listToAttrs (map (name: lib.nameValuePair name "${ponytail}/skills/${name}") ponytailSkills)
    // {
      "matt-pocock/engineering" = "${mattPocockSkills}/skills/engineering";
      playwright-cli = "${playwrightCli}/skills/playwright-cli";
    };
  agentSkillLinks = lib.mapAttrs' (
    name: source: lib.nameValuePair ".agents/skills/${name}" { inherit source; }
  ) agentSkills;
  anyAgentEnabled =
    config.development.claude.enable
    || config.development.cursor.enable
    || config.development.codex.enable
    || config.development.opencode.enable;
  playwrightCliBin = pkgs.writeShellScriptBin "playwright-cli" ''
    exec ${pkgs.nodejs}/bin/npx --yes @playwright/cli@latest "$@"
  '';
in
{
  options.development = {
    claude.enable = lib.mkEnableOption "claude code";
    codex.enable = lib.mkEnableOption "codex";
    cursor.enable = lib.mkEnableOption "cursor-agent";
    opencode.enable = lib.mkEnableOption "opencode";
  };

  config = {
    home.packages =
      lib.optionals anyAgentEnabled [
        pkgs.nodejs
        playwrightCliBin
      ]
      ++ lib.optionals config.development.cursor.enable [ pkgs.cursor-cli ]
      ++ lib.optionals config.development.opencode.enable [ pkgs.opencode-desktop ];

    programs = {
      mcp.enable = anyAgentEnabled;

      claude-code = lib.mkIf config.development.claude.enable {
        enable = true;
        enableMcpIntegration = true;
        context = agentInstructions;
        skills = agentSkills;
      };

      codex = lib.mkIf config.development.codex.enable {
        enable = true;
        enableMcpIntegration = true;
        context = agentInstructions;
        skills = agentSkills;
      };

      opencode = lib.mkIf config.development.opencode.enable {
        enable = true;
        enableMcpIntegration = true;
        context = agentInstructions;
        skills = agentSkills;
        settings.plugin = [ "${ponytail}/.opencode/plugins/ponytail.mjs" ];
      };

      zsh.shellAliases = lib.mkMerge [
        (lib.mkIf config.development.claude.enable { cc = "claude"; })
        (lib.mkIf config.development.cursor.enable { ccli = "cursor-agent"; })
        (lib.mkIf config.development.codex.enable { cx = "codex"; })
        (lib.mkIf config.development.opencode.enable { opc = "opencode"; })
      ];
    };

    home.file = lib.mkIf config.development.cursor.enable (
      {
        ".agents/AGENTS.md".text = agentInstructions;
        ".agents/rules/ponytail.md".source = "${ponytail}/.agents/rules/ponytail.md";
      }
      // agentSkillLinks
    );

    xdg.configFile = lib.mkMerge [
      (lib.mkIf config.development.opencode.enable {
        "opencode/agent/reviewer.md".text = opencodeReviewer;
      })
    ];
  };
}
