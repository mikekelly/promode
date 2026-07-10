# Decided: per-dispatch `effort` does not exist — reasoning effort is pinned per agent definition (2026-07 effort-dispatch constraint)

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Facts below are ⚙ harness-pinned, **live-verified 2026-07-10 on Claude Code 2.1.202**, method: dispatch-schema extraction from the installed binary + live dispatch probes + docs cross-check. Consequence (roster restructure) recorded separately: [`2026-07-agent-roster-restructure.md`](2026-07-agent-roster-restructure.md).

## What was decided

The Agent/Task tool has no per-invocation lever for reasoning effort. Effort is only settable at the agent-**definition** level (frontmatter). Any orchestration design that assumes a dispatcher can pick a model+effort combo per call is wrong for plain Agent dispatch — the combo must be pre-baked into a named agent definition instead. This is the reason the agent-roster restructure (node 2) exists as a set of named defs rather than dispatch-time parameters.

## Harness facts (⚙ — live-verified on Claude Code 2.1.202, 2026-07-10)

- **(a) The Agent/Task tool's per-invocation input schema is exactly:** `description`, `prompt`, `subagent_type`, `model: enum(["sonnet","opus","haiku","fable"]).optional()`, `run_in_background`. **There is no per-invocation `effort` parameter.** Verified by extracting the dispatch schema from the installed binary and cross-checking against live dispatch calls.
- **(b) Silent-strip trap.** Passing `effort` on an Agent dispatch is **accepted without error and silently discarded** — the schema is non-strict, so an unrecognised field is dropped rather than rejected. An orchestrator gets **no signal** that the config didn't apply; it looks like the call succeeded. **Rule: never pass `effort` per-dispatch until the harness grows the parameter** — it is a no-op today, not a soft hint.
- **(c) Reasoning effort IS settable per agent definition.** Frontmatter `effort:` accepts `low|medium|high|xhigh|max` **or an integer** — the integer form is undocumented, observed directly in the definition schema: `effort: union(enum|int).optional()`. Omitted → the agent inherits the session's effort.
- **(d) Per-invocation `model` override works and is honoured.** Verified via a subagent transcript recording the model actually applied — this is the one dispatch-time lever that does work, in contrast to (a)/(b).
- **(e) The `Workflow` tool's `agent()` DOES take a per-call `effort` argument.** Workflow orchestration can therefore hit exact model+effort combos that plain Agent dispatch cannot — a capability gap between the two orchestration surfaces, not a harness-wide limitation.
- **(f) Haiku 4.5 supports no effort control** — extended thinking only, not adaptive-effort. The harness silently downgrades/ignores an effort level for models that don't support it (same silent-acceptance shape as (b), at the model-support layer instead of the schema layer).
- **(g) Docs cross-check (docs-confirmed, not independently re-verified):** `code.claude.com/docs/en/sub-agents.md` (frontmatter fields, resolution order) and `code.claude.com/docs/en/model-config.md` (per-model effort defaults: Fable 5 / Opus 4.8 / Sonnet 5 all default `high`).

## Consequence (the decision)

Because effort cannot be dialed per-dispatch on plain Agent calls, model+effort combos must be **pre-baked as named agent definitions**. This is the direct cause of the agent-roster restructure in node 2 — engineers and workers are split into named defs (`senior-engineer`, `mid-level-engineer`, `elite-worker`, `high-level-worker`, `fast-worker`, `cheap-worker`, …) each pinning its own model+effort pair, rather than one generic def dispatched with different effort parameters per call.

## Re-verify on any Claude Code / model change

These are ⚙ harness-pinned facts, current as of 2.1.202 (2026-07-10). Re-verify (a)–(f) against the installed binary's dispatch schema and a live probe on any Claude Code upgrade; re-check (g) against the docs pages on the same pass.
