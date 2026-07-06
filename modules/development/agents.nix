{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (inputs) ponytail;
  grill-me = ''
    ---
    name: grill-me
    description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
    ---

    Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

    Ask the questions one at a time.

    If a question can be answered by exploring the codebase, explore the codebase instead.

  '';
  caveman = ''
    ---
    name: caveman
    description: >
      Ultra-compressed communication mode. Cuts token usage ~75% by dropping
      filler, articles, and pleasantries while keeping full technical accuracy.
      Use when user says "caveman mode", "talk like caveman", "use caveman",
      "less tokens", "be brief", or invokes /caveman.
    ---

    Respond terse like smart caveman. All technical substance stay. Only fluff die.

    ## Persistence

    ACTIVE EVERY RESPONSE once triggered. No revert after many turns. No filler drift. Still active if unsure. Off only when user says "stop caveman" or "normal mode".

    ## Rules

    Drop: articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), hedging. Fragments OK. Short synonyms (big not extensive, fix not "implement a solution for"). Abbreviate common terms (DB/auth/config/req/res/fn/impl). Strip conjunctions. Use arrows for causality (X -> Y). One word when one word enough.

    Technical terms stay exact. Code blocks unchanged. Errors quoted exact.

    Pattern: `[thing] [action] [reason]. [next step].`

    Not: "Sure! I'd be happy to help you with that. The issue you're experiencing is likely caused by..."
    Yes: "Bug in auth middleware. Token expiry check use `<` not `<=`. Fix:"

    ### Examples

    **"Why React component re-render?"**

    > Inline obj prop -> new ref -> re-render. `useMemo`.

    **"Explain database connection pooling."**

    > Pool = reuse DB conn. Skip handshake -> fast under load.

    ## Auto-Clarity Exception

    Drop caveman temporarily for: security warnings, irreversible action confirmations, multi-step sequences where fragment order risks misread, user asks to clarify or repeats question. Resume caveman after clear part done.

    Example -- destructive op:

    > **Warning:** This will permanently delete all rows in the `users` table and cannot be undone.
    >
    > ```sql
    > DROP TABLE users;
    > ```
    >
    > Caveman resume. Verify backup exist first.
  '';
  agentInstructions = ''
    # Agent Instructions

    - Make the smallest idiomatic code change that solves the task.
    - Preserve the project's existing style, structure, and conventions.
  '';
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
  anyAgentEnabled =
    config.development.claude.enable
    || config.development.cursor.enable
    || config.development.codex.enable
    || config.development.opencode.enable;
  playwrightCommand = "npx";
  playwrightArgs = [
    "-y"
    "@playwright/mcp"
  ];
  playwrightMcpServers = {
    mcpServers.playwright = {
      command = playwrightCommand;
      args = playwrightArgs;
    };
  };

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
      lib.optionals anyAgentEnabled [ pkgs.nodejs ]
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
          ".claude.json".text = builtins.toJSON playwrightMcpServers;
          ".claude/CLAUDE.md".text = agentInstructions;
          ".claude/skills/grill-me/SKILL.md".text = grill-me;
          ".claude/skills/caveman/SKILL.md".text = caveman;
        }
        // ponytailSkillLinks ".claude/skills"
      ))
      (lib.mkIf config.development.cursor.enable {
        ".cursor/mcp.json".text = builtins.toJSON playwrightMcpServers;
      })
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
            ".agents/skills/grill-me/SKILL.md".text = grill-me;
            ".agents/skills/caveman/SKILL.md".text = caveman;
          }
          // ponytailSkillLinks ".agents/skills"
        )
      )
    ];

    xdg.configFile = lib.mkMerge [
      (lib.mkIf config.development.codex.enable {
        "codex/config.toml".text = lib.generators.toTOML { } {
          mcp_servers.playwright = {
            command = playwrightCommand;
            args = playwrightArgs;
          };
        };
      })
      (lib.mkIf config.development.opencode.enable {
        "opencode/opencode.json".text = builtins.toJSON {
          "$schema" = "https://opencode.ai/config.json";
          mcp.playwright = {
            type = "local";
            command = [ playwrightCommand ] ++ playwrightArgs;
            enabled = true;
          };
          plugin = [ "${ponytail}/.opencode/plugins/ponytail.mjs" ];
        };
        "opencode/command".source = "${ponytail}/.opencode/command";
      })
    ];
  };
}
