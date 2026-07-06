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
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
_(filled by the agent on completion)_
