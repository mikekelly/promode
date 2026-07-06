# Support defs: debugger, code-reviewer, verifier, environment-manager — cuts + convergent additions

## Brief
- **Orient** — four files in `plugins/promode/agents/`: `debugger.md`, `code-reviewer.md`, `verifier.md`, `environment-manager.md`. House rule: rationale travels with the rule.
- **Specify** — all four edited, committed. Per file:

  **debugger.md**
  - CUT the `<reproduction-test>` example section (~500 chars incl. the toy `should not crash when input is empty` example — zero-delta at opus tier).
  - CUT two of the three "not a system test" statements (keep the `<feedback-loop>` copy, which carries the rationale; trim the parentheticals in `<your-role>` and the workflow step).
  - ADD the hard gate: **no red-capable reproduction command, no hypothesis phase** — "if you catch yourself reading code to build a theory before this command exists, stop and build the loop."
  - ADD: the **confirmed hypothesis is stated in the final report/commit message** — so the next debugger learns which prediction survived.
  - ADD (only if not already present): tag every temporary debug log with one unique token (e.g. `[DEBUG-a4f2]`) so cleanup is a single grep.

  **code-reviewer.md**
  - CUT the `<review-criteria>` checkbox echo of the test-realness/no-suite-running rule (the adjacent `<review-workflow>` paragraph carries it fully).
  - TRIM `<rework-guidance>` to its one decision-carrying line ("Don't nitpick style if it's within project norms") — the rest is behavior an opus/sonnet model produces unaided.
  - ADD: "**a finding you dismiss needs a stated reason, not silence**."
  - ADD the **tautological-test class** to the test-realness criteria: an assertion that recomputes the expected value the way the code does passes by construction and can never disagree with the code.

  **verifier.md** (no cuts — audit rated it best density in the corpus)
  - ADD **prove-the-change-is-real first**: before judging any output, confirm the change actually took effect (byte/behavior diff against the pre-change baseline; a critique of an unchanged artifact "verifies" a no-op).
  - ADD **reproduce the reporter's framing** for bug-fix verification: replay the reporter's exact steps/parameters/viewport first; your own probe framing supplements, never substitutes.

  **environment-manager.md**
  - DELETE the bodies of `<health-check-workflow>`, `<environment-operations>`, `<troubleshooting-workflow>` (~1.3k chars of `docker ps`-level procedure a sonnet-tier model executes unaided — the audit's weakest-density finding). Keep the section shells only if something non-generic survives; otherwise remove the sections.
  - KEEP: the testability primitives (bring-up / real reset primitive / per-test data isolation), the safety nevers, the "reproducible env is the cost budget" principle.
  - ADD the bootstrap line the other defs share ("If no root `CLAUDE.md` exists, create a minimal one") — this agent often runs first in a fresh repo.
- **Why** — cuts from a 2026-07-06 signal:noise audit; additions converged on by two community authors (mattpocock `diagnosing-bugs`/`code-review`, dzhng `screenshot-critique`/`codex`).
- **Verified vs assumed** — finding locations from the audit; confirm current wording by reading before editing.
- **Not / exit** — these four files only; keep each def's voice; no version bump. Exit: committed in your worktree, Outcome recorded below.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — verifier gets additions only; environment-manager keeps its three load-bearing passages
- **Established facts** — audit + convergence findings above
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
_(filled by the agent on completion)_
