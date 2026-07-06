# Engineer defs: fix traceability drift, adopt convergent test discipline, add logic spikes

## Brief
- **Orient** — `plugins/promode/agents/senior-engineer.md` + `plugins/promode/agents/fast-worker.md`. Their shared blocks (`<behavioural-authority>`, `<constraint-ladder>`, TDD core) are duplicated **by design** and must stay in sync — see `runbooks/sync-a-shared-principle.md`. House rule: rationale travels with the rule (never a bare prohibition).
- **Specify** — both defs edited, committed. Work items:

  **Drift fix:** fast-worker's traceability (correlation-ID) rule lost its rationale; senior-engineer's copy carries it ("The payoff is token economy and faster debugging: a future agent (or you) filters one request's whole trace instead of reading unfiltered logs"). Restore an equivalent why-clause to fast-worker's copy.

  **Add to BOTH TDD sections (kept in sync):**
  1. **Tautological-test class**: an assertion that recomputes the expected value the same way the code does passes by construction and can never disagree with the code — expected values come from an independent source of truth.
  2. **Assert the design contract, not current behavior** — a bar calibrated to whatever the code currently does silently encodes bugs as baseline.
  3. **Confirm red for the expected reason** — a test failing for an unrelated reason (typo, import error) proves nothing about the behavior under test.
  4. **Stochastic outcomes are asserted as distributions** (over seeds/samples) — a single-sample pin on a stochastic outcome is not a weak test, it is a blind one.
  5. **Test names use the project's canonical domain vocabulary** where a glossary node exists in the knowledge graph — tests are the documentation, so they speak the domain's language.

  **Add to senior-engineer only:**
  6. **Logic-spike discipline**: when a domain-model or algorithm decision needs a *reactable* answer, build a throwaway prototype — a pure, portable state module (reducer / state machine / pure functions; no I/O in the core) behind a thin disposable shell; no persistence, no tests, no polish; the *answer* (recorded in a commit message or decision node) is the only thing kept — the code is deleted or deliberately absorbed.
  7. In the operator-seam section: "**one adapter is a hypothetical seam; two adapters is a real one**" — reinforcing the existing don't-generalise-from-n=1 caution.
- **Why** — items 1–4 were converged on independently by two community skill authors (dzhng/skills `write-tests`, mattpocock/skills `tdd`); 5 supports "tests are the documentation"; the drift fix is required by house style (and fast-worker is the weaker model — it needs the why more, not less).
- **Verified vs assumed** — the drift finding and quoted rationale are from a 2026-07-06 audit; confirm current wording by reading before editing.
- **Not / exit** — no cuts (the audit rated both defs High-density); no other files. Keep each def's existing voice and section structure; put additions where the TDD/seam content already lives, not in new sections. Exit: both files committed in your worktree, Outcome recorded below.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — shared blocks stay verbatim-identical across the two defs; additions to shared TDD content go to both
- **Established facts** — audit + community-convergence findings above
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
- **Status**: done. Commit `6d9f69e` on branch `worktree-agent-abece3fe8d6018171` (executor's worktree; not pushed, no version bump — per brief).
- **Files changed**: `plugins/promode/agents/senior-engineer.md`, `plugins/promode/agents/fast-worker.md` only.
- **Drift fix**: fast-worker's traceability rule got the exact why-clause from senior-engineer's copy ("The payoff is token economy and faster debugging: …"). Confirmed by reading before editing: the audit finding was accurate — fast-worker's copy jumped straight from `[trace=…]` to "Build it in".
- **Shared TDD additions (items 1–5)**: added verbatim-identically to both defs' `<test-driven-development>` Non-negotiable lists (checksum-verified identical). Placement: "Confirm red for the expected reason" right after the no-code-without-failing-test bullet (it qualifies the RED step); the other four (independent source of truth / design contract not current behaviour / distributions for stochastic outcomes / canonical domain vocabulary in test names) appended after "Assert the action". Each carries its rationale inline, per house rule.
- **Senior-only additions**: (6) logic-spike discipline added as a closing paragraph of the TDD section, framed as "the one sanctioned exception" — a spike is by definition test-free, so it must be an explicit carve-out or it contradicts RED→GREEN; added the guard that anything absorbed re-enters through TDD. (7) "one adapter is a hypothetical seam; two adapters is a real one" spliced into the existing n=1 sentence in the "One seam, two operators" bullet of `<operator-seam>`.
- **Key decisions**: kept the defs' pre-existing intentional asymmetries untouched (senior's trace-user-need bullet + agent-example parenthetical; fast-worker's non-code closing note) — "verbatim-identical shared blocks" interpreted as: the *added* shared text is identical, existing per-def tailoring preserved. British "behaviour" spelling used to match both files' voice.
- **Task-doc feedback**: nothing materially wrong or stale. Two nits: (a) the constraint "shared blocks stay verbatim-identical" slightly overstates the status quo — the two TDD sections were already deliberately non-identical at the edges (see asymmetries above); applied it to the shared core + new additions. (b) The dispatch prompt said the task doc "is NOT in your worktree" — it is (tasks/ is tracked), so this Outcome is recorded in the worktree copy and committed with the branch.
