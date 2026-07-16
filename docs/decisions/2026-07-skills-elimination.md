# Decided: promode ships no skills (2026-07 skills elimination)

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Maintainer-ratified 2026-07-07; executed as the 14a–14e migration. Canonical design + probe log: [`tasks/13-skills-elimination-design.md`](../../tasks/13-skills-elimination-design.md). Register opinion: **M5 `no-voluntary-invocation`**.

## What was decided

Promode avoids voluntary-invocation skills altogether. A skill fires off a description competing in a merged listing — the model may or may not invoke it — and that was the **last non-deterministic delivery surface** in promode: everything else already reached agents by guaranteed load (hook, defs, `@`-import) or dispatch. The maintainer priced the inconsistency cost above the just-in-time benefit, so all seven plugin skills were eliminated **while preserving the JIT context economics** — nothing became always-loaded that didn't earn it.

## The four-surface matrix (the opinion's operational form)

Every capability moved to one of four **non-voluntary** surfaces:

1. **Dedicated agent** — big JIT mechanics that are one agent's whole job; invocation becomes delegation-map dispatch, and the def (the agent's system prompt) loads only when dispatched — exact JIT parity. → `promode:auditor` (ex promode-audit), `promode:constraint-reinforcer` (ex reinforce-design-constraints); recovering-subagents folded into the existing `promode:agent-analyzer`.
2. **Shared/def prompting** — small, always-relevant-to-that-agent mechanics, inline in the def (register-tracked homes).
3. **Def-directed doc read** — cross-cutting mechanics several agents need occasionally: content at `plugins/promode/docs/<name>.md`, each consuming def carrying a conditional imperative ("when the dispatch is X, first read `${CLAUDE_PLUGIN_ROOT}/docs/<name>.md`"). Not literally deterministic — still model compliance — but it swaps *listing-competition voluntariness* for an *in-system-prompt imperative*, the trust level the corpus already grants def text. → `discovery-to-determinism.md`, `design-system-lookbook.md` (+ their references). *(The lookbook doc was later superseded by `reference-conformance.md` — see `2026-07-reference-conformance.md`; the delivery surface it exemplifies is unchanged.)*
4. **Plugin `commands/`** — user-typed flows, kept model-invocable so the brief can also fire them proactively. → `/promode:handoff`, `/promode:promode-audit` (a thin shim dispatching the auditor).

Main-agent-only mechanics went into the **brief** (chunk 4: the task-docs template + lifecycle, and the proactive-handoff trigger — the one disposition that raised always-loaded cost, ~1.2k tokens, bought deliberately because the doc shape is used at plan time in most sessions).

## Probe evidence (harness-pinned ⚙, verified live on Claude Code 2.1.201, 2026-07-07)

The design leans on five live-probed facts — P1 (plugin subagents hold the `Agent` tool; nested fan-out works), P2 (background fan-out inside a subagent bubbles child notifications to the root session → in-subagent fan-out must be a foreground parallel batch), P3 (plugin `commands/` execute with `$ARGUMENTS` + `${CLAUDE_PLUGIN_ROOT}` expansion), P4 (commands stay model-invocable — the description tax persists and is bought deliberately), P5 (`${CLAUDE_PLUGIN_ROOT}` expands in agent defs — the mechanism under every def-directed read). Full statements: the register's Harness-pinned section and tasks/13. These are the migration's real risk surface: undocumented behaviours a future Claude Code release could regress — re-verify on any harness change; the auditor def carries a no-Agent-tool fallback.

## Rejected alternatives (durable reasons — don't re-suggest)

- **`disable-model-invocation` on qualifying skills** (task 07's lever). Rejected: 6 of the 7 skills were dispatch targets the model must be able to fire; the flag is a plugin-author one-way door; and it buys tokens, not determinism — the invocation that remains is still voluntary.
- **d2d / lookbook as dedicated agents** — the closest call. Rejected because the knowledge is *cross-cutting* (SE builds the seam, VER runs the UI tier, FW drives GUIs, PDE bridges scenarios): an agent home cannot deliver mechanics into sibling agents' contexts, and a "seam-engineer" def would fork SE's checksummed TDD blocks (sync burden, drift risk). Def-directed doc reads keep one home and exact JIT economics.
- **Audit synthesis stays with the main agent** (the pre-migration shape: agent gathers, main agent synthesises). Rejected: the rubrics would still need a main-agent-loadable home — precisely the skill being eliminated — and probe P1 removed the technical reason the fan-out ever lived in the main context. The judgement concern is covered by the existing O2 pattern: the auditor synthesises and prioritises, the main agent ratifies.
- Also rejected (see tasks/13 §8): *everything into the brief* (dies on the 10k-per-chunk budget — the audit alone was 23k — and puts subagent mechanics at the wrong altitude) and a *docs-only migration with no new agents* (audit and constraint-reinforcement are whole jobs deserving delegation-map determinism, not reference knowledge).

## Reversibility

Cheap to reverse in-repo (git revert + patch release; no external state; slash names `/promode:handoff` and `/promode:promode-audit` preserved, so no user muscle-memory breakage). The migration deliberately does **not** use `disable-model-invocation` — the one-way door task 07 identified. One accepted soft spot: a mis-briefed dispatch that doesn't name seam/GUI work can no longer be rescued by a skill description triggering off the listing — promode's doctrine already makes naming the work the dispatcher's job.
