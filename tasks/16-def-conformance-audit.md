# Def↔register conformance audit (forward pass)

## Brief
- **Orient** — the register (`plugins/promode/docs/opinion-register.md`, auto-imported into every agent session here), all 11 defs in `plugins/promode/agents/`, `runbooks/sync-a-shared-principle.md`.
- **Specify** — first dedicated FORWARD verification of the register-traceability constraint over the agent defs: (a) per def, every clause maps to the register slug(s) it serves, or is flagged ORPHAN; (b) statements contradicting the register or a sibling def flagged; (c) each def's existence justified against its Components row (does the def actually do what the row claims?). Method: 11 parallel per-def checkers (register arrives via @-import) → main-agent synthesis. Verdict per def + a consolidated orphan/conflict list.
- **Why** — the register was derived FROM the defs (backward); "every clause serves an item" (forward) has only been checked on the migration's new defs. Maintainer asked for the affirmative answer; this pass earns it.
- **Not / exit** — read-only for checkers (report, change nothing); fixes ratified + dispatched separately. Outcome: synthesis recorded here.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — checkers read-only
- **Established facts** — 09 backward pass clean at its snapshot; migration review clean on new defs
- **Pending goals / next step** — fan out 11 checkers, synthesise

## Outcome
_(synthesis recorded on completion)_
