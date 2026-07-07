# Kanban board

Flow view only — one-line cards (title + link to the task's doc where one exists); the column owns
status. Detail lives in task docs (the brief's `<task-docs>` mechanics), raw ideas in [IDEAS.md](IDEAS.md), completed
work in [DONE.md](DONE.md).

## Doing

- Unknowns-UX opinions O40–O42 + O18 calibration (register + brief + CTO def + README) — [tasks/17](tasks/17-unknowns-ux-opinions.md) (landed `2bffea5`, awaiting round close-out review)
- Unknowns field-guide decision node + IDEAS entry + bump 2.39.0 — [tasks/18](tasks/18-unknowns-decision-node.md)

## Ready
- Add worktree.baseRef: "head" to .claude/settings.json (O6) — see [audit](docs/audits/2026-07-07-methodology-audit.md)
- Fix M6 phantom home — drop "(migration note)" at opinion-register.md:18 (M6) — see [audit](docs/audits/2026-07-07-methodology-audit.md)
- Remove 2 stale worktrees: lucid-agnesi (safe), amazing-dirac (--force, needs confirm) (O6) — see [audit](docs/audits/2026-07-07-methodology-audit.md)
- Add check-shared-principle-checksums.sh + wire into check-hooks.sh & CI (P2,P11) — methodology-lead — see [audit](docs/audits/2026-07-07-methodology-audit.md)
- Write promode's own docs/product/PERSONAS.md (PD3 on itself)
- README honesty pass — outcome claims → flagged hypotheses (PD4/PD6)
- Run external A/B of the core efficacy thesis (O32 outward)
- Harden engineer-def commit/report discipline (P12/P17 AAR finding)
- Runtime-verify CTO inherit + sub-Fable consent check in a fresh session
