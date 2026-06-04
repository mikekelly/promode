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

- [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) (vanilla install works fine)

---

## Installation

Run two commands to get the plugin setup:

```
/plugin marketplace add mikekelly/promode
```

```
/plugin install promode
```

Then restart Claude Code and ask Claude to set up promode in your project:

```
Set up promode in this project
```

This installs a `SessionStart` hook that gives the main agent the promode orchestration brief. It does **not** modify your project's `CLAUDE.md`.

---

## How It Works

The main agent handles high-level work: brainstorming with the user, designing features, planning implementation, and orchestrating execution. It delegates implementation to phase-specific agents:

| Agent | Purpose |
|-------|---------|
| `promode:implementer` | TDD workflow, write code |
| `promode:code-reviewer` | Code review, approve or request rework |
| `promode:tester` | Run tests, parse results, critique quality |
| `promode:debugger` | Root-cause analysis, reproduce with a test, report findings (does not fix unless asked) |
| `promode:qa-expert` | Blackbox QA from the outside in |
| `promode:environment-manager` | Docker, services, health checks, scripts |
| `promode:online-researcher` | Date-aware web research |
| `promode:product-design-expert` | Product/UX decisions |
| `promode:agent-analyzer` | Analyse agent output during after-action reviews |

The main agent gets the promode methodology from a `SessionStart` hook — it is **not** written into your `CLAUDE.md`, and it never reaches subagents. Each phase agent carries the methodology in its own definition, so subagents are self-contained. Subagents commit changes before reporting back.

Tasks can run in parallel when independent, improving throughput on larger features.

---

## What's Included

**Phase Agents** — Implementation, review, and debugging agents with methodology baked in.

**Skills:**
- **managing-promode** — Set up, update, and audit promode in a project (installs the main-agent SessionStart hook; never touches your `CLAUDE.md`)
