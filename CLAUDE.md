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

### Keeping Principles in Sync

These two files share the same **principles, workflows, and conventions** but have **role-specific differences**:
- `plugins/promode/skills/managing-claude-code-meta/standard/MAIN_AGENT_CLAUDE.md` — main agent (delegates work, converses with user)
- `plugins/promode/agents/promode-subagent.md` — sub-agent (executes tasks, reports back)

When updating shared content (principles, TDD rules, behavioural-authority, debugging strategies), update both files. Role-specific sections (e.g. `<your-role>`, escalation targets) are intentionally different and should stay that way.
