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

This installs a `SessionStart` hook that gives the main agent the promode orchestration brief. It never puts its methodology in your `CLAUDE.md` — your `CLAUDE.md` is the agent-knowledge root that agents maintain.

---

## How It Works

The main agent handles high-level work: brainstorming with the user, designing features, planning implementation, and orchestrating execution. It delegates implementation to phase-specific agents:

| Agent | Purpose |
|-------|---------|
| `promode:implementer` | TDD workflow, write code (and tests) |
| `promode:code-reviewer` | Review the code & solution (doesn't run the suite) |
| `promode:debugger` | Root-cause analysis, reproduce with a test, report findings (does not fix unless asked) |
| `promode:verifier` | Exercise the running app via the `/verify` skill; PASS/FAIL |
| `promode:environment-manager` | Docker, services, health checks, scripts |
| `promode:product-design-expert` | Product/UX decisions |
| `promode:agent-analyzer` | Analyse agent transcripts during after-action reviews |

The main agent gets the promode methodology from a `SessionStart` hook — it is **not** put in your `CLAUDE.md`, and it never reaches subagents. Your `CLAUDE.md` is the agent-knowledge root: every agent reads it to orient, and agents grow the knowledge graph from it. Each phase agent carries the methodology in its own definition, so subagents are self-contained. Subagents commit changes before reporting back.

Tasks can run in parallel when independent, improving throughput on larger features.

---

## What's Included

**Phase Agents** — Implementation, review, and debugging agents with methodology baked in.

**Skills:**
- **managing-promode** — Set up, update, and audit promode in a project (installs the main-agent SessionStart hook; never puts its methodology in your `CLAUDE.md` — your `CLAUDE.md` is the agent-knowledge root)
- **promode-audit** — Assess a repo's alignment with the promode methodology and produce a prioritised, actionable improvement plan (fans out parallel assessors)
- **handoff** — Write a handoff document so a fresh agent can continue after a `/clear` or `/compact` (also runs as `/handoff`)
- **recovering-subagents** — Inspect a completed or stalled subagent's transcript compactly, for recovery
