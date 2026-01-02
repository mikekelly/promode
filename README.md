# Promode

Promode is a Claude Code plugin that provides a **methodology for AI agents to develop software**.

## The Core Idea

**The repo is always ready for a fresh agent.**

Any agent should be able to pick up the work with zero context from previous conversations. The human decides when to bring in a fresh agent; the methodology ensures that's always possible.

This changes how agents work:

| Traditional approach | Promode approach |
|---------------------|------------------|
| Agent accumulates context over a session | All state lives in committed files |
| Handoff requires explanation | Handoff requires reading TODO.md |
| Context exhaustion is a problem | Context exhaustion is a non-event |
| Session continuity matters | Sessions are disposable |

## How It Works

### TODO.md is the handoff mechanism

`TODO.md` must always answer "what's next?" Before stepping away from work, the agent ensures TODO.md clearly describes what a fresh agent should do first.

A fresh agent reads:
1. `CLAUDE.md` — how to work (the promode methodology)
2. `README.md` — what this project is
3. `TODO.md` — what to do next

That's the complete handoff. No context sharing, no session history, no explanation needed.

### Failing tests capture intent

When implementing a feature, write failing tests first. If context runs out mid-implementation, those failing tests tell the next agent exactly what behaviour is expected. The tests are the specification.

### Plan docs are committed state

Plans go in `docs/` as committed markdown. If context runs out mid-plan, the next agent reads the plan and continues. Plans are deleted once tests verify the behaviour.

## Core Principles

- **TDD is non-negotiable** — Write failing tests first, then implementation. No exceptions.
- **Repo as source of truth** — All state lives in committed files. Nothing important exists only in agent context.
- **Continuous handoff readiness** — Work so that any agent can pick up with zero prior context.
- **Tests are the documentation** — Executable tests document behaviour, not markdown files.

## What Promode Provides

### Skills

- **managing-skills** — Install, update, list, and remove skills from GitHub repos or local sources
- **managing-claude-code-meta** — Set up, migrate, and audit CLAUDE.md files following promode conventions

### MCP Servers

The plugin includes three MCP servers that start automatically:

- **context7** — Fetches up-to-date official documentation for libraries
- **exa** — Real-time web search (requires `EXA_API_KEY`)
- **grep_app** — Code search across public GitHub repositories

## Installation

```
/plugin marketplace add mikekelly/promode
/plugin install promode
```

Then restart Claude Code and tell Claude:

```
Update the claude code meta to install promode
```

## Skills Management

Promode includes skill management that lets you ask Claude directly:

- "Install the skill mikekelly/debugging-react-native"
- "Install the skill https://github.com/metabase/metabase/tree/master/.claude/skills/typescript-review"
- "Update my installed skills"
- "Remove the pdf skill"
- "List my installed skills"

### Supported Sources

- GitHub repositories (`user/repo`)
- GitHub subdirectory URLs (`github.com/user/repo/tree/branch/path`)
- `.skill` zip files

Skills Management handles both user level (`~/.claude/skills/`) and project level (`.claude/skills/`).

## Why Skills Over MCPs

MCPs provide deterministic tools — useful, but limited. Skills blend the determinism of scripts with the reasoning of the model. A skill can guide Claude through a complex workflow, injecting structured steps where needed while letting the model apply judgment at decision points.

Instead of burning tokens on rigid back-and-forth tool calls, skills encode expertise directly into prompts that the model interprets and adapts.
