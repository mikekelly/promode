# Why the main-agent brief is delivered by a hook

Promode keeps its **main-agent orchestration brief out of `CLAUDE.md`** and delivers it via a SessionStart hook instead. The split:

- **`CLAUDE.md`** is the project's own file and the **root of the agent-knowledge graph** — auto-loaded into the main agent *and* every subagent, and maintained by agents over time. It holds project knowledge, not promode's methodology.
- **`PROMODE_MAIN_AGENT.md`** carries the main-agent methodology (principles + orchestration). It's delivered to the **main agent only**, via the hook, and lives in `.claude/` — never in `CLAUDE.md`.
- **Subagents** carry their methodology in their own definitions, so they need nothing extra.

## Why the brief can't just go in CLAUDE.md

Subagents **do** load `CLAUDE.md`. (Verified: every custom/plugin subagent inherits both the project and user `CLAUDE.md`; only the built-in `Explore` and `Plan` agents skip it.) So if the main-agent orchestration — "you are a team lead, delegate everything, never do the work yourself" — lived in `CLAUDE.md`, it would leak into the phase agents, where it's actively wrong for an `implementer` whose whole job is to do the work.

That's the crux: **orchestration** must not reach subagents. **Project knowledge** (the graph rooted at `CLAUDE.md`) is the opposite — it's meant for everyone. So orchestration goes to the hook; knowledge stays in `CLAUDE.md`.

## Why a SessionStart hook

No supported mechanism scopes content to the main agent except a hook:

- `CLAUDE.md` (and its `@imports`) load into subagents.
- Output styles apply to the whole session.
- The `agent` setting / `--agent` flag doesn't stop `CLAUDE.md` loading into subagents.

A subagent invocation includes an `agent_id` field on stdin; the hook injects `PROMODE_MAIN_AGENT.md` as `additionalContext` only when `agent_id` is absent (the main agent). Subagents receive nothing.

Verified behaviour:

- The injected context **does not cascade** into subagents.
- `SessionStart` re-fires on `clear` and `compact`, so the brief **survives `/clear` and compaction** — provided the hook matches all four sources (`startup|resume|clear|compact`). Miss the `compact` matcher and the brief is silently dropped after the first compaction.

## The trade-off

The shared principles live in `PROMODE_MAIN_AGENT.md` (for the main agent) and in each phase-agent definition (for subagents) — a deliberate redundancy, the cost of keeping orchestration out of `CLAUDE.md` and making each agent self-contained.
