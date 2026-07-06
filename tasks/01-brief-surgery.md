# Brief surgery: cut same-target repeats, adopt convergent planning/execution rules

## Brief
- **Orient** — `plugins/promode/PROMODE_MAIN_AGENT.md`: the main-agent brief, split by `<!-- CHUNK -->` markers into 3 hook outputs, each hard-capped at 10,000 chars (currently ~9.4k / ~6.9k / ~9.2k delivered). Read the file's header comment first — it explains the chunking. `./scripts/check-hooks.sh` enforces caps + chunk registration and must pass.
- **Specify** — one edited brief, checks green, committed. Work items:

  **Cuts (from a signal:noise audit of this file):**
  1. The CTO-drafts/main-ratifies rule appears 4× (`<role>`, `<delegation-map>`, `<model-tiers>`, `<planning>` closing sentence). Keep the `<role>` and `<delegation-map>` copies; trim the other two mentions to nothing or a bare name.
  2. Delete `<planning>`'s **Model:** sentence entirely ("**Model:** per `<model-tiers>` — … don't downgrade.") — it restates `<model-tiers>` and `<delegation-map>` nearly verbatim in the tightest chunk.
  3. `<agent-knowledge>` bullet 3 (capture routing: linked doc / decision node / runbook) → one line cross-referencing `<after-action-review>`, which holds the fuller copy in the same delivered context.
  4. `<feature-knowledge-base>` states the post-hoc-justification trap 3× (stretching goals; invented/flattered personas; fabricated citations) → one statement covering all three surfaces, keeping the persona and citation rules themselves.

  **Move:**
  5. Rule of Two out of `<promode-audit>` into `<subagent-scoping>` — it's a live delegation-time rule, not an audit dimension. `<promode-audit>` keeps one clause: "Autonomy/security dimension: the Rule of Two (see `<subagent-scoping>`)."

  **Additions (each converged on independently by two community skill authors — dzhng/skills and mattpocock/skills):**
  6. `<planning>`: slice by **verifiability**, not just agent fit — every task independently verifiable ("one question, one seam, one review surface, one verdict"); a slice described with broad verbs ("make it realistic", "add the backend") isn't a task yet — re-slice it. **Fog discipline**: plan tasks only to the fog edge; keep the fog as *named unknowns*, never pre-sliced into fake tasks (the fog test: you can state the question precisely now — *not* answer it).
  7. `<execution>` opener: replace "Work methodically; adjust the plan when new information warrants" (audit: zero-delta) with "**Reslicing is progress, not failure** — adjust the plan the moment the work proves it stale."
  8. `<subagent-scoping>`: **unprimed dispatch** — when briefing `verifier` or `code-reviewer`, never state the expected answer or the fix you hope is confirmed ("primed eyes pass defects fresh eyes catch"); say what to examine, not what to conclude.
  9. `<workflow>`: a prototype-detour clause — when a decision needs a *reactable* answer rather than a debated one, dispatch a spike first (UI variants → `product-design-expert`; logic spike → `senior-engineer`); a prototype is throwaway code that answers a question — keep the answer, delete the code.

  Rebalance sections across chunk markers if a chunk exceeds the cap — sections are self-contained and merge unordered, so placement is free. Prefer keeping exactly 3 chunks (changing the marker count requires re-registering chunks in `plugins/promode/hooks/hooks.json`).
- **Why** — the audit found same-target repetition diluting a near-cap brief; the additions carry the strongest two-author convergence signal from the community evaluation.
- **Verified vs assumed** — chunk sizes and repeat-counts verified by the audit agent (2026-07-06); wording locations assumed accurate but confirm by reading before cutting.
- **Not / exit** — do NOT touch agent defs, skills, hooks.json (unless chunk count changes), or version. Do not reword sections not listed. Exit: `./scripts/check-hooks.sh` green, committed in your worktree, Outcome recorded below.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — 10k/chunk cap; 3 registered chunks; principles duplicated with agent defs are BY DESIGN (cut only *same-target* repeats within this file)
- **Established facts** — audit findings listed above
- **Pending goals / next step** — none; task complete

## Outcome
**Done** — all 9 work items executed on branch `worktree-agent-a9631984bce8dfdea`, commit `17564f6`. `./scripts/check-hooks.sh` green before and after. One file changed: `plugins/promode/PROMODE_MAIN_AGENT.md` (9 insertions, 9 deletions). Chunk count stays 3, `hooks.json` untouched, no version bump.

**Final chunk sizes** (raw additionalContext / delivered incl. banner): chunk 1 — 9288 / 9641; chunk 2 — 7122 / 7313; chunk 3 — 8835 / 9052. All under the 10k cap; no rebalancing needed. Chunk 1 is now the tightest (~360 chars delivered headroom) — worth knowing before the next addition lands there. (Pre-edit raw baseline measured: 9049 / 6737 / 9015.)

**Key judgement calls:**
1. *Cut 1 nuance:* `<model-tiers>` never restated the full drafts/ratifies rule — only the descriptive "the crucial hard-to-reverse design work via `chief-technology-officer`". Trimmed to the bare name ("plus `chief-technology-officer` (the one execution agent worth your tier)"), keeping the tier assignment, which is that section's actual job. Left the later "or `chief-technology-officer` for crucial design" qualifier in the high-stakes-parallel sentence — it routes a different decision (parallel dispatch), not ratification.
2. *Cuts 1+2 merged:* the `<planning>` Model: sentence and the CTO closing sentence were adjacent — removed in one edit, ending the paragraph at "…checkpoint between chained ones."
3. *Cut 4 shape:* single trap statement placed at the "Guarding the *why*" sentence — "post-hoc justification is one trap in three guises — a stretched or invented goal, a flattered persona, a fabricated citation — and none is a valid fix." Persona rule kept ("Personas must be *realistic* — grounded in real customer evidence"); citation clause kept ("never silent, never fabricated"). Rules survive; the trap is stated once.
4. *Rule of Two placement:* appended to `<subagent-scoping>` after the fresh-spawn sentence, next to the new unprimed-dispatch rule — both are dispatch-time constraints, so they read as a coherent tail. Side benefit: moves ~350 chars from the tight chunk 3 to the roomy chunk 2.
5. *Addition 9 wording:* "At any step, when a decision needs a *reactable* answer rather than a debated one, detour into a spike…" appended after `<workflow>`'s ordered list — a cross-cutting detour, not a numbered phase, since it can fire during brainstorm, clarify, or plan.
6. *No rebalancing:* the brief said rebalance only if a chunk exceeds the cap; none did.

**Doc accuracy:** audit findings held up, with one wrinkle — the `<model-tiers>` "4th copy" of the CTO rule is a paraphrase of the routing, not a verbatim restatement of drafts/ratifies (handled per call 1). Nothing else stale.

*(Note: recorded in the task's worktree copy and committed on the branch — the Edit tool is sandboxed to this worktree, so the shared-checkout copy at `.claude/worktrees/lucid-agnesi-d48e54/tasks/01-brief-surgery.md` gets this Outcome on merge.)*
