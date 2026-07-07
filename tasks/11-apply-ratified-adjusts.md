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
- **Open constraints** — none (P11 verbatim ×5 checksum-verified; chunks within cap)
- **Established facts** — ratification calls above
- **Pending goals / next step** — done

## Outcome

**Completed 2026-07-07.** All eight items applied, single commit, `./scripts/check-hooks.sh` green, version 2.31.0 → 2.32.0. Per-item record:

1. **O5** — brief `<subagent-scoping>`: the near-equal steer/resume restatement collapsed to a one-clause cross-ref to `<background-delegation>` (the fuller home). The clause **keeps the cache-economics why** ("already oriented, cache reads make reuse faster and cheaper") because that rationale was unique to this home; the fresh-spawn why ("uncontaminated perspective") now lives only in `<background-delegation>`, reached by the cross-ref. Chunk 2: 7122 → 7095 chars; chunk 1 untouched (it sits at 9842/10000 — no headroom, deliberately not grown).
2. **O19** — task-doc line added to `code-reviewer.md` `<reporting>` ("record the verdict + issues… canonical task state") and `environment-manager.md` (in the new Done-means, "outcome + actions taken"), payload calibrated per role like the peers.
3. **P11** — why-line appended inside `<behavioural-authority>` in all five homes, verbatim-identical, sha256 of the block = `19604f77719f0a8a706730da1e63b555a05a1e3ab09f49f269146c8801fa7182` across senior-engineer, fast-worker, chief-technology-officer, code-reviewer, debugger. Wording: "Why this precedence: verified behaviour outranks declared intent, and declared intent outranks prose — the ladder settles conflicts from evidence, without a human round-trip." Block added to the sync runbook's shared-block list (five verbatim homes, why-line included in the checksum).
4. **P12** — `environment-manager.md`: **Done means** paragraph added (scripts/config committed before reporting, with the why: uncommitted changes can't be reviewed and don't survive the session); frontmatter description gains "commits script/config changes before reporting" matching the SE/FW family.
5. **K1/K2** — `verifier.md` and `agent-analyzer.md` `<reporting>`: one line each — report capture-worthy knowledge (gotcha / decision / repeatable procedure) for the main agent to dispatch capture; "you don't write the knowledge graph yourself". No capture sections added (role calibration preserved).
6. **K3** — fast-worker sentence NOT restored; calibration documented in `runbooks/sync-a-shared-principle.md` (FW escalates decision-worthy findings per its lane asymmetry; "don't fix this by restoring the sentence").
7. **08 nits** — `RUNBOOKS.md`: "`CLAUDE.md` table" → "`CLAUDE.md` agents bullet list"; sync runbook reframed from "both homes" to "its homes / multiple homes" (title, intro, section header, and a clarifying gloss that `CLAUDE.md`'s "two places" means the two *sides*), index link text updated to match.
8. **Bump** — `scripts/bump-version.sh 2.32.0`; committed with the changes (no push, per brief).

**Decisions of note:** (a) O5 collapse direction kept chunk 1 untouched because it has only 158 chars of headroom; the surviving unique rationale moved *into* the collapsed clause rather than into `<background-delegation>`. (b) EM's task-doc + commit lines were combined into one SE/FW-shaped **Done means** paragraph rather than two scattered sentences.

**Flagged, not fixed (out of scope):** `runbooks/add-a-subagent.md` self-contradicts — line ~12 says "There is no agent table in `CLAUDE.md`" while line ~27 says "The descriptive tables live in `CLAUDE.md` and `README.md`"; same table-vs-bullet-list confusion the 08 nit fixed in `RUNBOOKS.md`.
