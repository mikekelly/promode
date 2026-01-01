> Keep this file under 50 lines. This is a plugin repository - see plugins/promode/ for the actual plugin.

## What is Promode?

Promode is a Claude Code plugin that enhances how Claude builds software. It provides:

- **Skills** — Domain knowledge that loads just-in-time (managing CLAUDE.md files, installing skills)
- **Agents** — Pre-configured subagents that understand promode conventions

The core philosophy: TDD is non-negotiable, tests are the documentation, context is precious, and agents should delegate aggressively to conserve it.

### The promode-subagent Pattern

Claude Code subagents do NOT inherit CLAUDE.md from the main conversation. This creates a problem: subagents spawned via the Task tool don't know project conventions, TDD practices, or behavioural-authority rules.

**Solution**: The `promode-subagent` (`plugins/promode/agents/promode-subagent.md`) mirrors the standard CLAUDE.md content that would normally be in a project's CLAUDE.md. When the main agent delegates work, it should prefer `promode-subagent` over the built-in `general-purpose` agent.

**Why this works**: The promode-subagent's system prompt contains the same principles, workflows, and conventions that would be in a properly configured CLAUDE.md. The subagent "boots up" with this knowledge already loaded.

**Usage**: When delegating, the main agent can say:
```
Use the promode-subagent to [task description]
```

The subagent will already understand TDD, progressive disclosure, behavioural-authority, and all promode conventions.

### Plugin Structure

```
plugins/promode/
├── .claude-plugin/plugin.json    # Plugin manifest
├── agents/
│   └── promode-subagent.md       # Convention-aware subagent
└── skills/
    ├── managing-skills/          # Skill installation/management
    └── managing-claude-code-meta/ # CLAUDE.md setup/migration/audit
```

### Keeping Files in Sync

**CRITICAL**: These two files must be kept in sync:
- `plugins/promode/skills/managing-claude-code-meta/standard/MAIN_AGENT_CLAUDE.md` — main agent instructions
- `plugins/promode/agents/promode-subagent.md` — sub-agent instructions

Unless a change is role-specific (e.g. main agent delegation triggers vs sub-agent coordination), any change to one file MUST be reflected in the other. They share the same principles, workflows, and conventions.
