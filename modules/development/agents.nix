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
  ponytailSkillLinks =
    base:
    lib.listToAttrs (
      map (
        name: lib.nameValuePair "${base}/${name}" { source = "${ponytail}/skills/${name}"; }
      ) ponytailSkills
    );
  mattPocockSkillCategories = [
    "engineering"
    "productivity"
    "personal"
  ];
  mattPocockSkillLinks =
    base:
    lib.listToAttrs (
      map (
        name:
        lib.nameValuePair "${base}/matt-pocock/${name}" { source = "${mattPocockSkills}/skills/${name}"; }
      ) mattPocockSkillCategories
    );
  playwrightCliSkillLinks = base: {
    "${base}/playwright-cli".source = "${playwrightCli}/skills/playwright-cli";
  };
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
      ++ lib.optionals config.development.claude.enable [ pkgs.claude-code ]
      ++ lib.optionals config.development.cursor.enable [ pkgs.cursor-cli ]
      ++ lib.optionals config.development.codex.enable [ pkgs.codex ]
      ++ lib.optionals config.development.opencode.enable [ pkgs.opencode ];

    programs.zsh.shellAliases = lib.mkMerge [
      (lib.mkIf config.development.claude.enable { cc = "claude"; })
      (lib.mkIf config.development.cursor.enable { ccli = "cursor-agent"; })
      (lib.mkIf config.development.codex.enable { cx = "codex"; })
      (lib.mkIf config.development.opencode.enable { opc = "opencode"; })
    ];

    home.file = lib.mkMerge [
      (lib.mkIf config.development.claude.enable (
        {
          ".claude/CLAUDE.md".text = agentInstructions;
        }
        // ponytailSkillLinks ".claude/skills"
        // mattPocockSkillLinks ".claude/skills"
        // playwrightCliSkillLinks ".claude/skills"
      ))
      (lib.mkIf config.development.codex.enable {
        ".codex/AGENTS.md".text = agentInstructions;
      })
      (lib.mkIf
        (
          config.development.cursor.enable
          || config.development.codex.enable
          || config.development.opencode.enable
        )
        (
          {
            ".agents/AGENTS.md".text = agentInstructions;
            ".agents/rules/ponytail.md".source = "${ponytail}/.agents/rules/ponytail.md";
          }
          // ponytailSkillLinks ".agents/skills"
          // mattPocockSkillLinks ".agents/skills"
          // playwrightCliSkillLinks ".agents/skills"
        )
      )
    ];

    xdg.configFile = lib.mkMerge [
      (lib.mkIf config.development.opencode.enable {
        "opencode/opencode.json".text = builtins.toJSON {
          "$schema" = "https://opencode.ai/config.json";
          plugin = [ "${ponytail}/.opencode/plugins/ponytail.mjs" ];
        };
        "opencode/agent/reviewer.md".text = opencodeReviewer;
        "opencode/command".source = "${ponytail}/.opencode/command";
      })
    ];
  };
}
