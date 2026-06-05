# Promode

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin that keeps the main agent orchestrating and hands the actual work to focused subagents.

Instead of one agent doing everything in a single, ever-growing context, the main agent plans, makes decisions, and talks to you, while short-lived subagents start clean, do one job, run in parallel, and report back a short summary.

It's a handful of agent definitions, a few skills, and one hook. No services, no MCP servers, no lock-in — you can read every prompt it ships.

## The problem it's built around

Two things quietly degrade a long Claude Code session:

1. **Context fills up.** The more an agent reads, edits, and logs, the larger its context grows and the worse its reasoning and instruction-following get. A session that starts sharp ends sloppy.
2. **The agent does the work itself.** Left to its own devices, a capable model writes code inline, piles detail into the main thread, and loses the high-level thread.

Promode's bet is to keep the main agent thin: it should hold the plan and the conversation, not the diff. Execution goes to subagents that each start fresh, do one thing, and return a few lines — so the main context stays small and the expensive reasoning stays clear.

## How it works

**The main agent orchestrates.** It does only what needs the whole picture: talking with you, pinning down what success looks like, planning, reviewing plans, making architectural calls, and synthesising results. Everything else is delegated.

**Subagents execute.** Each delegation is one agent, one deliverable, fresh context. They run in the background — the main agent dispatches and ends its turn, then gets woken when a result lands. Independent work runs in parallel. Subagents commit their changes before reporting, so what comes back is a summary, not a context-bloating dump.

**Model choice is explicit.** The main agent runs on a strong model because it's doing the reasoning; routine subagents run on a cheaper, faster one; hard jobs (multi-system debugging, architectural review) get bumped up.

**Where the methodology lives is deliberate** — this is the part that's easy to get wrong:

- The orchestration brief is delivered to the *main agent only*, via a `SessionStart` hook. It is not written into your `CLAUDE.md`, so "delegate everything, never do the work yourself" never leaks into the subagents whose whole job is to do the work.
- Each subagent carries its own methodology in its own definition, so it's self-contained.
- Your `CLAUDE.md` stays yours. Promode treats it as the root of an agent-maintained knowledge graph — an LLM wiki: every agent reads it to orient, and agents add linked docs as they learn things worth keeping. Promode never overwrites it; it creates a minimal one only if you don't have it.

### Agents

| Agent | Job |
|---|---|
| `implementer` | Write code and tests, TDD |
| `code-reviewer` | Review the change (doesn't run the suite — that's the implementer's job) |
| `debugger` | Find the root cause, reproduce with a test, report (doesn't fix unless asked) |
| `verifier` | Exercise the running app from the outside; PASS/FAIL with evidence |
| `environment-manager` | Docker, services, health checks, scripts |
| `product-design-expert` | Product and UX decisions |
| `agent-analyzer` | Read an agent's transcript during after-action reviews |

## The opinions

Promode is opinionated on purpose. What's baked into the agents:

- **TDD is not optional.** No implementation without a failing test first. Tests are the specification; behaviour lives in tests, not in prose.
- **Evidence over assumptions.** Read the code, run it, check the output. State assumptions out loud so they can be challenged.
- **Stay on task.** An agent fixes what it was sent to fix and flags the rest, rather than wandering into adjacent refactors and bloating the diff.
- **Work traces to a reason.** New work connects, through a hierarchy of docs (goals and risks → feature definitions → tests), up to an actual goal. If it can't, either the work is superfluous or the goals are out of date — and the main agent is told to push back, not to invent a goal to justify the work.

## Install

```
/plugin marketplace add mikekelly/promode
/plugin install promode
```

Restart Claude Code, then tell it:

```
Set up promode in this project
```

That installs the `SessionStart` hook and the brief, and creates a minimal `CLAUDE.md` if you don't already have one.

## Skills

- **managing-promode** — install, update, or audit the promode setup in a project.
- **promode-audit** — assess how well an existing repo matches the methodology (tests and feedback loops, the `CLAUDE.md` knowledge root, architecture, traceability) and produce a prioritised, actionable plan. Fans out parallel assessors and synthesises their findings.
- **handoff** — write a handoff document so a fresh agent can continue after a `/clear` or `/compact` (also runs as `/handoff`).
- **recovering-subagents** — inspect a finished or stalled subagent's transcript compactly, to recover from a failure without reading the whole thing.

## Requirements

- Claude Code (a vanilla install is fine)
- `git` — subagents commit their work
- `jq` — used by the hook
