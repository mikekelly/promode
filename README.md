# Promode

## Why Promode?

Promode is a battle-tested methodology for AI-assisted software development. It covers the full lifecycle:

- **Project management** — Task tracking, dependencies, progress visibility
- **Brainstorming** — Structured ideation with the user
- **Product design** — Feature specification and acceptance criteria
- **Research & analysis** — Codebase exploration, documentation lookup
- **Planning** — Implementation strategy before writing code
- **Execution** — Parallel task delegation to specialised agents
- **Test-driven development** — Verify behaviour with tests, not inspection
- **Code review** — Separate review phase before work is complete

The methodology is designed for efficiency: conservative use of context, intelligent model selection for speed and cost, and aggressive delegation to keep the main conversation focused on high level objectives, not implementation detail.

---

## Requirements

Promode requires **Team Mode**—a hidden Claude Code feature that enables multi-agent orchestration.

To get Team Mode, install a parallel Claude Code instance using [cc-mirror](https://github.com/numman-ali/cc-mirror):

```bash
npx cc-mirror create --provider mirror --name mclaude
```

See the [cc-mirror docs](https://github.com/numman-ali/cc-mirror/blob/main/docs/features/mirror-claude.md) for details.

---

## How It Works

The main agent handles high-level work: brainstorming with the user, designing features, planning implementation, and orchestrating execution. It delegates implementation to phase-specific agents:

| Agent | Purpose |
|-------|---------|
| `promode:implementer` | TDD workflow, write code |
| `promode:reviewer` | Code review, approve or request rework |
| `promode:debugger` | Root cause analysis, fix failures |

Each agent has the methodology embedded in its definition—they know TDD practices, commit conventions, and how to capture learnings. Subagents commit changes before reporting back.

Tasks can run in parallel when independent, improving throughput on larger features.

---

## What's Included

**Phase Agents** — Implementation, review, and debugging agents with methodology baked in.

**Skills:**
- **managing-skills** — Install, update, and remove skills from GitHub or local sources
- **managing-claude-code-meta** — Set up, migrate, and audit CLAUDE.md files

**MCP Servers (auto-start):**
- **context7** — Library documentation ([upstash/context7](https://github.com/upstash/context7))
- **exa** — Web search (requires `EXA_API_KEY`)
- **grep_app** — Code search via [grep.app](https://grep.app)

---

## Installation

```
/plugin marketplace add mikekelly/team-mode-promode
/plugin install promode
```

Then restart Claude Code and tell Claude:

```
Update the claude code meta to install promode
```

---

## Skills Management

Promode makes skill management conversational:

- "Install the skill mikekelly/debugging-react-native"
- "Install the skill from https://github.com/metabase/metabase/tree/master/.claude/skills/typescript-review"
- "Update my installed skills"
- "Remove the pdf skill"

Works with both user-level (`~/.claude/skills/`) and project-level (`.claude/skills/`) installations.
