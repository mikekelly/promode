# Peripheral sync: README, runbooks, CTO boundary, cross-def references

## Brief
- **Orient** — depends on tasks 19–24 (merged). Read the two decision nodes (`docs/decisions/2026-07-agent-roster-restructure.md`, `2026-07-effort-dispatch-constraint.md`) and the updated register first; they are ground truth. Then: `README.md`, `runbooks/sync-a-shared-principle.md`, `runbooks/add-a-subagent.md`, `plugins/promode/agents/chief-technology-officer.md`, and `grep -rn 'fast-worker\|senior-engineer\|product-design-expert' --include='*.md'` across the repo minus `tasks/`, `DONE.md`, `docs/audits/`, `docs/decisions/` (historical records stay as-is).
- **Specify** —
  1. **README**: agent table → the new roster (7 new/changed rows); tier-economics prose → the config-ladder framing (pre-baked model+effort combos; inherit seats honour the cost ceiling); mention the effort-dispatch constraint in one line linking the decision node.
  2. **Runbook `sync-a-shared-principle.md`**: retire the SE↔CTO-and-FW-calibration narrative — supersede-with-pointer (M3), never delete; document the new byte-identity families (engineer body ×2, worker body ×4, reporting block across engineer+worker+gui-driver+product defs — verify the actual family membership against the committed defs) and point at the checksum script as the deterministic check.
  3. **Runbook `add-a-subagent.md`**: add the frontmatter `effort:` field to the checklist (with the silent-strip warning + decision-node link) and the byte-identity-family question ("does the new def join a checksummed family?").
  4. **CTO def**: narrow its product-call line (crucial *product* calls → CPO; CTO keeps entity/domain model + deep technical trade-offs; both-draft-in-parallel for genuinely-both) and re-point its task-routing references (senior-engineer/fast-worker → engineer rungs / workers as appropriate).
  5. **Cross-def scrub**: fix live references to retired names/semantics in the remaining defs (code-reviewer, debugger, verifier, auditor, constraint-reinforcer, environment-manager, agent-analyzer) and `plugins/promode/docs/*.md` routed docs (d2d routes FW's GUI driving — re-point to gui-driver). Do not rewrite content beyond the re-pointing.
  6. Root `CLAUDE.md`: update only what the roster falsifies (e.g. "eleven agent defs" count in the register preamble is task 24's file; here check CLAUDE.md's own agent enumerations/links). Keep it under its 50-line rule.
- **Why** — a rename that leaves stale references turns every stale mention into a mis-dispatch or a falsehood in loaded orientation (K6 territory).
- **Verified vs assumed** — the grep list above found matches in: README, PROMODE_MAIN_AGENT (task 24's), CTO def, code-reviewer def, lookbook doc, main-agent-delivery doc, register (task 24's), sync runbook, checksum scripts (task 26's). Re-run the grep yourself; files may have moved since.
- **Not / exit** — do NOT touch the brief, the register (task 24), or the checksum scripts (task 26). Historical records (tasks/, DONE.md, audits, decision nodes) stay untouched. Exit: all edits committed; report lists every file touched + every stale reference found and its fix; `grep` for the three old names over live surfaces comes back clean or each remaining hit justified.

## State
- **Open constraints** — blocked on tasks 19–24 merging.

## Outcome
(filled by the agent on completion)
