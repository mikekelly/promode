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
_(filled by the agent on completion)_
