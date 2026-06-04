# Why the main-agent brief is delivered by a hook

Promode keeps its methodology **out of the project's `CLAUDE.md` entirely**:

- **The project `CLAUDE.md`** stays the project's own — conventions, build notes, whatever the team wants. Promode never owns or modifies it. It's loaded normally by the main agent *and* every subagent.
- **`PROMODE_MAIN_AGENT.md`** carries the full main-agent methodology (principles + orchestration). It's delivered to the main agent **only**, via a SessionStart hook, and lives in `.claude/`, not in `CLAUDE.md`.
- **Subagents** carry their methodology in their own definitions (`plugins/promode/agents/*.md`), so they need nothing from `CLAUDE.md` either.

## Why not just put it in CLAUDE.md?

Subagents **do** load the project `CLAUDE.md`. (Verified: every custom/plugin subagent inherits both the project and user `CLAUDE.md`; only the built-in `Explore` and `Plan` agents skip it.) So orchestration in `CLAUDE.md` — "you are a team lead, delegate everything, never do the work yourself" — would leak into the phase agents, where it's actively wrong for an `implementer` whose whole job is to do the work.

Putting orchestration anywhere a subagent can read it is the problem. The fix: deliver it only to the main agent, and leave `CLAUDE.md` alone.

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

The shared principles (evidence-over-assumptions, TDD, behavioural authority…) are not centralised in one file — they live in `PROMODE_MAIN_AGENT.md` (for the main agent) and in each phase-agent definition (for subagents). That redundancy is the deliberate cost of keeping promode out of the project's `CLAUDE.md` and making each agent self-contained.
