# Decision nodes: effort-dispatch harness constraint + agent-roster restructure

## Brief
- **Orient** — `docs/decisions/` (existing nodes show the format: what was decided / rejected / why, cold-readable). Related: `docs/decisions/2026-07-context-monitor.md` (example of a ⚙ harness-fact node).
- **Specify** — write TWO decision nodes and link both from the knowledge graph (root `CLAUDE.md` already links `docs/decisions/`; no root edit needed):
  1. `docs/decisions/2026-07-effort-dispatch-constraint.md` — the harness facts (⚙, live-verified 2026-07-10 on Claude Code 2.1.202, method: dispatch-schema extraction from the installed binary + live dispatch probes + docs cross-check):
     - The Agent/Task tool's per-invocation input schema is exactly `description`, `prompt`, `subagent_type`, `model: enum(["sonnet","opus","haiku","fable"]).optional()`, `run_in_background`. **There is no per-invocation `effort` parameter.**
     - **Silent-strip trap:** passing `effort` on an Agent dispatch is *accepted without error and silently discarded* (the schema is non-strict). An orchestrator gets no signal the config didn't apply. Rule: never pass effort per-dispatch until the harness grows the parameter.
     - Reasoning effort IS settable per agent **definition**: frontmatter `effort:` accepts `low|medium|high|xhigh|max` **or an integer** (the integer form is undocumented; observed in the definition schema: `effort: union(enum|int).optional()`). Omitted → inherits the session effort.
     - Per-invocation `model` override works and is honoured (verified via subagent transcript recording the applied model).
     - The `Workflow` tool's `agent()` DOES take per-call `effort` — workflow orchestration can hit exact model+effort combos that plain Agent dispatch cannot.
     - Haiku 4.5 supports no effort control (extended thinking only, not adaptive); the harness silently downgrades effort for models that don't support a level.
     - Docs cross-check: code.claude.com/docs/en/sub-agents.md (frontmatter fields, resolution order), code.claude.com/docs/en/model-config.md (per-model effort defaults: Fable 5 / Opus 4.8 / Sonnet 5 all default `high`).
     - **Consequence (the decision):** model+effort combos must be pre-baked as agent definitions; this is why the roster (node 2) exists as named defs rather than dispatch parameters.
  2. `docs/decisions/2026-07-agent-roster-restructure.md` — the ratified roster (maintainer-ratified 2026-07-10) and its why:
     - **Engineers** (one shared body, TDD conditional on code changes, pin-relative lane rule): `senior-engineer` (opus/high), `mid-level-engineer` (sonnet/medium).
     - **Workers** (one shared thin generic body; exist to pre-bake model+effort combos for generic dispatch, per node 1): `elite-worker` (inherit — NEVER hardcoded fable, honours the user's cost ceiling like CTO), `high-level-worker` (opus/high), `fast-worker` (sonnet/medium), `cheap-worker` (haiku, no effort field).
     - **Specialist**: `gui-driver` (sonnet/medium) — new home of the selector-discipline (T17) inline mirror.
     - **Product split**: `product-design-expert` retires; `chief-product-officer` (inherit; drafts crucial hard-to-reverse product calls — goal hierarchy, personas, positioning, growth strategy — for main-agent ratification; owns the claim side of PD4/A1) + `senior-product-designer` (opus/high; execution rung: consults, UI-variant spikes, lookbook, `docs/product/` ownership).
     - **Rejected alternatives, with why:** (a) one merged software-engineer def with per-dispatch effort — impossible, per node 1; (b) `principal-engineer` on inherit — redundant with CTO (O13's "one execution agent worth the orchestrator's tier"); the rare frontier-execution need is served by dispatching `senior-engineer` with a per-dispatch model override to the orchestrator's own tier (known from the own-model preamble signal; never fabricate); (c) six engineer/worker defs sharing ONE body — produces duplicate-config aliases; two bodies (engineer TDD vs worker generic) is what makes both families non-redundant; (d) hardcoded `model: fable` anywhere — breaks non-Fable consumers.
     - Fast-worker's species change (TDD engineer → generic worker) and PDE's retirement are corpus-wide scrubs; the old FW calibration records in the sync runbook are superseded-with-pointer, never silently deleted.
- **Why** — these are ⚙ harness-pinned facts and a hard-to-reverse roster decision; without nodes, the next harness pass or fork can't tell opinion from constraint, and the silent-strip trap will bite an orchestrator that assumes per-dispatch effort works.
- **Verified vs assumed** — every fact in node 1 is live-verified (2.1.202, 2026-07-10) except the docs cross-checks (docs-confirmed). Node 2 is ratified design, not yet implemented — say so in the node (implementation lands in tasks 20–27).
- **Not / exit** — do NOT edit agent defs, the register, or the brief (other tasks own those). Exit: both nodes committed, cold-readable, each fact carrying its verification method + date.

## State
- **Established facts** — all facts above are final; copy them faithfully, do not re-derive or soften.
- **Open constraints** — worktree-isolated task: record the Outcome in YOUR worktree's copy of this doc; it lands on merge.

## Outcome
(filled by the agent on completion)
