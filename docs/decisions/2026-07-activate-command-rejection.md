# Decided: keep the hook-delivered brief — reject a `/promode:activate` opt-in command (2026-07)

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Maintainer-ratified 2026-07-10; harness facts below are from live probes in the ratifying session — copied faithfully, not re-derived. Companion doc: [`main-agent-delivery.md`](../../plugins/promode/docs/main-agent-delivery.md) ("why a hook delivers the brief"). Register opinion: **M0 `owner-preferences-root`** (the structural-delivery clause this proposal would have amended).

## What was considered

Replacing the SessionStart hook-delivered main-agent brief with a user-typed `/promode:activate` command (opt-in per session), plus a minimal SessionStart hook that tells the agent to *suggest* activation when the request looks like project work, plus an auditor check that this reminder hook is present.

## What was decided

Keep the hook as default delivery. The activate-command design is **rejected for now**, with a named revisit condition — not silently shelved.

## Why rejected

1. **M0's structural-delivery clause is explicit** — "never a menu the human must remember to pick from." An activate command makes the whole methodology contingent on per-session human memory, and the easiest session to forget is a fresh one right after `/clear` mid-project — exactly where hook-guaranteed continuity earns its keep. Adopting activate is an **M0 amendment**, not a packaging change, and wasn't treated as one lightly.
2. The reminder-hook mitigation gives back most of the win on paper, but not in practice: promode still ships a SessionStart hook (same infra + audit surface), but automatic delivery degrades to a nag plus a required human action — the exact menu-dependency M0 forbids, just one layer removed.
3. The benefit is real but narrow: the brief costs ~10k tokens per session, which only matters in sessions where promode wasn't needed anyway. That's a small, occasional tax being traded against a structural guarantee.

## Verified facts (live, Claude Code 2.1.202, 2026-07-10)

- **Subagents DO see plugin commands in their skills listing and hold the Skill tool** (probe: a general-purpose subagent's listing contained `promode:handoff` and `promode:promode-audit`) — so an unflagged activate command would be model-invocable from inside subagents, risking orchestration-brief pollution of executor contexts.
- **The off-switch exists and is verified:** `disable-model-invocation: true` in plugin-skill/command frontmatter (live-verified 2.1.201, `tasks/07-invocation-tax.md`) removes the entry from the model listing and hard-blocks Skill-tool invocation even on explicit user prose request, while the typed slash form still works. An activate command would carry this flag — promode's first flagged command (`handoff`/`promode-audit` stay unflagged deliberately: the main agent invokes them proactively).
- **Today's gating holds:** the same probe confirmed a subagent's context contains no trace of the hook-delivered brief (`agent_id` gating working as designed).

## Revisit condition

If per-session brief tax proves painful in practice, revisit the flagged-activate + micro-reminder-hook design (~200-char hook). One unprobed fact blocks building it: **whether command-body expansion has a size cap analogous to the hook's 10k limit** — the brief is ~41k chars and would arrive as one expansion. Probe that first, before resuming this design.

## Reversibility

Cheap to revisit: no code was written, nothing shipped. The blocking unknown (command-body size cap) is a single probe, not a redesign — the revisit condition above is the whole reopening cost.
