# Apply the ratified 09 adjusts (items 1–6) + 08's runbook nits

## Brief
- **Orient** — `tasks/09-opinion-inventory.md` (entries O5, O19, P11, P12, K1, K2, K3 carry exact home locations; read those entries before editing), `runbooks/sync-a-shared-principle.md`, `RUNBOOKS.md`. Ratified by maintainer 2026-07-07 with these calls:
- **Specify** — committed edits:
  1. **O5** — brief (`plugins/promode/PROMODE_MAIN_AGENT.md`): steer/resume-vs-fresh-spawn is stated at near-equal depth in `<background-delegation>` and `<subagent-scoping>`; keep the fuller `<background-delegation>` copy, collapse the other to a short cross-ref clause. `./scripts/check-hooks.sh` green (chunk sizes).
  2. **O19** — add the record-your-outcome-in-the-task-doc line (mirror the peers' wording) to `code-reviewer.md` and `environment-manager.md`.
  3. **P11** — `behavioural-authority` block (5 homes: senior-engineer, fast-worker, chief-technology-officer, code-reviewer, debugger): attach a one-line why (e.g. *why this precedence: verified behaviour outranks intent, intent outranks prose — the ladder resolves conflicts without a human round-trip*, in your words), **verbatim-identical across all five** (sync-runbook discipline; add the block to the runbook's shared-block list).
  4. **P12** — `environment-manager.md`: commit-before-reporting discipline (it writes scripts/config; they land in git before reporting, matching its executing peers).
  5. **K1/K2** — `verifier.md` + `agent-analyzer.md`: one line each — report capture-worthy knowledge (gotchas, decisions, procedures) in the summary for the main agent to dispatch capture; you don't write the graph yourself. NOT full capture sections (deliberate role calibration: their value is not mutating state mid-run).
  6. **K3** — do NOT restore fast-worker's decision-node sentence; document the calibration in `runbooks/sync-a-shared-principle.md` (fast-worker escalates decision-worthy findings per its lane-asymmetry instead of authoring decision nodes).
  7. **08 nits** — `RUNBOOKS.md`: "the `CLAUDE.md` table" → the bullet list it actually is; `runbooks/sync-a-shared-principle.md`: reframe the "two homes" framing to match its own three-TDD-homes content.
  8. Bump `2.32.0` (`scripts/bump-version.sh`), single commit, no push.
- **Why** — first enforcement pass of the opinion inventory (task 09) under the register-traceability constraint; every edit serves an inventoried opinion.
- **Verified vs assumed** — locations verified by the 09 extraction agent (read-confirmed); re-verify each site by reading before editing (sites may have moved).
- **Not / exit** — no other def/brief/skill changes; T18/R4 widenings and P11 brief/verifier coverage are PARKED (register decisions, task 10). Exit: committed, checks green, Outcome recorded here (you work in the shared checkout — this path is writable).

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — P11 why-line verbatim-identical ×5; chunk caps
- **Established facts** — ratification calls above
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
_(filled by the agent on completion)_
