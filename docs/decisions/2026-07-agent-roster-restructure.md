# Decided: agent-roster restructure — named defs pre-bake model+effort combos (2026-07 agent roster restructure)

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Maintainer-ratified 2026-07-10. Direct consequence of the harness constraint recorded in [`2026-07-effort-dispatch-constraint.md`](2026-07-effort-dispatch-constraint.md) — read that node first.

**Status: ratified design, not yet implemented.** This node records the *decision*; implementation (creating/renaming/retiring the actual agent def files, updating the delegation map, the register, and cross-references) lands in tasks 20–27. Nothing in this node should be read as "already true of the repo's current defs."

## What was decided

Because reasoning effort can only be pinned at the agent-**definition** level (node 1), the roster is restructured into named defs that each pre-bake a fixed model+effort combo, organised into three families:

### Engineers (one shared body, TDD conditional on code changes, pin-relative lane rule)

- `senior-engineer` — opus / high
- `mid-level-engineer` — sonnet / medium

### Workers (one shared thin generic body; exist to pre-bake model+effort combos for generic dispatch, per node 1)

- `elite-worker` — **inherit** (NEVER hardcoded to `fable` — honours the user's cost ceiling, same discipline as CTO's `model: inherit`)
- `high-level-worker` — opus / high
- `fast-worker` — sonnet / medium
- `cheap-worker` — haiku, no effort field (Haiku 4.5 has no effort control — node 1 fact (f))

### Specialist

- `gui-driver` — sonnet / medium — new home of the selector-discipline (T17) inline mirror.

### Product split

- `product-design-expert` **retires**.
- `chief-product-officer` — inherit; drafts crucial hard-to-reverse product calls (goal hierarchy, personas, positioning, growth strategy) for main-agent ratification; owns the claim side of PD4/A1.
- `senior-product-designer` — opus / high; the execution rung: consults, runs UI-variant spikes, maintains the lookbook, owns `docs/product/`.

## Why

The Agent/Task tool has no per-invocation `effort` parameter (node 1), and passing one is silently discarded rather than rejected — so any design that dispatches a single generic def with a per-call effort argument is a no-op that looks like it worked. The only lever that actually pins effort is the definition's frontmatter. Splitting engineers and workers into two families (rather than one shared body across all six) keeps the two roles' distinct system prompts (TDD-bound vs generic) intact while giving each model+effort combo its own dispatchable name — a named def is the unit of effort control.

## Rejected alternatives (durable reasons — don't re-suggest)

- **(a) One merged software-engineer def with per-dispatch effort.** Impossible per node 1 — there is no per-invocation effort parameter on plain Agent dispatch, and passing one is silently discarded, not honoured.
- **(b) `principal-engineer` on `inherit`.** Rejected as redundant with CTO — O13's "one execution agent worth the orchestrator's tier" is already served by CTO. The rare frontier-execution need (as opposed to frontier *design*) is served by dispatching `senior-engineer` with a per-dispatch `model` override to the orchestrator's own tier (node 1 fact (d): model override does work) — known from the own-model preamble signal, never fabricated.
- **(c) Six engineer/worker defs sharing ONE body.** Rejected: produces duplicate-config aliases — defs that differ only in frontmatter with no behavioural distinction. Two bodies (engineer = TDD-bound, worker = generic) is what makes both families non-redundant; collapsing to one body would make the six defs indistinguishable except by name.
- **(d) Hardcoded `model: fable` anywhere.** Rejected: breaks non-Fable consumers of a promode fork. `elite-worker` uses `inherit` for the same reason CTO does — it honours whatever tier the user is actually paying for, never assumes Fable.

## Migration note

Fast-worker's species change (TDD engineer → generic worker) and product-design-expert's retirement are corpus-wide scrubs, not local edits — every reference to the old shape (delegation map, register rows, cross-references in other defs) needs updating, not just the def file itself. The old fast-worker calibration records in the sync runbook (`runbooks/sync-a-shared-principle.md`) are **superseded-with-pointer, never silently deleted** — a future reader needs to see what changed and why, not just find the record gone.

## Verified vs assumed

This node's roster is ratified design (maintainer decision, 2026-07-10), not a harness fact — nothing here needs re-verification on a harness change. It rests on node 1's harness facts, which do need re-verification per that node's own instructions.

## Amendment (2026-07-16, owner call): code-reviewer moves sonnet → opus/high

`code-reviewer` was originally left off this roster's fixed-tier list (`## What was decided` above), instead running `model: sonnet` by default with a per-dispatch upgrade lever ("pass `model: opus` for complex architectural review") — the one execution role never folded into the pre-baked ladder. That stance is **superseded, not silently deleted**: the reviewer is now a pinned **opus/high** rung, like `senior-engineer` and `high-level-worker`, with the lever inverted — `model: sonnet` is now the *opt-down* for simple mechanical diffs, not the default.

Why: review is a judgement seat, not mechanical execution — its APPROVED/REWORK verdict gates merges and it's the enforcement home for the seam/tier/tracer/crystallise checks (register O13/AG-code-reviewer). A misjudged approval costs far more than the sonnet→opus delta, and the old "remember to pass `model: opus` when it's architectural" made the upgrade a forgettable dispatch decision — exactly what the pre-baked ladder (this node's whole point) exists to avoid.

Homes synced: `plugins/promode/agents/code-reviewer.md` frontmatter (`model: opus`, `effort: high`, description rewritten with the inverted lever) · brief `<model-tiers>` opus/high bullet + `<delegation-map>` annotation · register O13 statement + AG-code-reviewer row · README agents table.
