# Promode

Promode is a Claude Code plugin that implements a **methodology for AI agents to develop software**. It emphasises TDD, context conservation, progressive disclosure, and clear delegation patterns.

## Requirements: Claude Code with Team Mode

This plugin requires **Claude Code with team mode enabled** — a hidden feature that provides Task tools for multi-agent orchestration.

Team mode is not yet publicly available in standard Claude Code. To use this plugin, install a parallel Claude Code instance with team mode using [cc-mirror](https://github.com/numman-ali/cc-mirror):

```bash
# Create a Mirror Claude variant with team mode
npx cc-mirror create --provider mirror --name mclaude
```

This creates a separate `mclaude` command that runs alongside your standard `claude` installation. See the [cc-mirror documentation](https://github.com/numman-ali/cc-mirror/blob/main/docs/features/mirror-claude.md) for details.

## Core Philosophy

- **TDD is non-negotiable**: Write failing tests first, then implementation. No exceptions.
- **Context is precious**: Main agents delegate aggressively to subagents to conserve main agent context for high level planning and user conversation. Subagents enjoy a context focused on a specific task.
- **Tests are the documentation**: Executable tests document system behaviour, not markdown files.
- **Progressive disclosure**: CLAUDE.md defines agent behaviour; AGENT_ORIENTATION.md files hold compact agent guidance. Orientation files are distributed across packages and loaded just-in-time — agents load only what they need, further conserving context.

## What Promode Provides

### Phase Agents

Claude Code subagents don't inherit CLAUDE.md from the main conversation. This is a problem: subagents spawned via the Task tool don't know your project conventions.

**Solution**: Promode provides phase-specific agents with the methodology baked in:

| Agent | Purpose |
|-------|---------|
| `promode:implementer` | TDD workflow, write code |
| `promode:reviewer` | Code review, approve or request rework |
| `promode:debugger` | Root cause analysis, fix failures |

**Note**: The main agent handles brainstorming, planning, and orchestration directly. Use built-in `Explore` agents for codebase research.

Each agent already knows TDD, behavioural-authority, context conservation, and all promode conventions.

### Skills

- **managing-skills** — Install, update, list, and remove skills from GitHub repos or local sources
- **managing-claude-code-meta** — Set up, migrate, and audit CLAUDE.md files following promode conventions

### MCP Servers

The plugin includes three MCP servers that start automatically when the plugin is enabled:

- **context7** — Fetches up-to-date official documentation for libraries ([upstash/context7](https://github.com/upstash/context7))
- **exa** — Real-time web search powered by Exa AI (requires `EXA_API_KEY` environment variable)
- **grep_app** — Ultra-fast code search across millions of public GitHub repositories via [grep.app](https://grep.app)

## Installation

```
/plugin marketplace add mikekelly/team-mode-promode
/plugin install promode
```

Then restart Claude Code and tell Claude:

```
Update the claude code meta to install promode
```

## Skills Management

Managing Claude Code skills is awkward without tooling. You either need to use marketplace commands repeatedly or manually download files from GitHub.

Promode's skill management lets you just ask Claude:

- "Install the skill mikekelly/debugging-react-native"
- "Install the skill https://github.com/metabase/metabase/tree/master/.claude/skills/typescript-review"
- "Update my installed skills"
- "Remove the pdf skill"
- "List my installed skills"

Skills Management handles both user level (`~/.claude/skills/`) and project level (`.claude/skills/`).
