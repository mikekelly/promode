# Promode Methodology Audit — v2.38.4 (2026-07-07)

Auditor: `promode:auditor` (5 assessors). Ratified by the main agent (checksum-guard promoted to lead methodology fix). Overall: **Strong — no integrity failures; low-effort drift + one real methodology gap.**

## Findings
- **F1 — repo fails its own two recommended settings** (`O6`, `O35`). No `worktree.baseRef: "head"` though it actively uses worktrees (fan-out forks from wrong base); no in-repo auto-memory (AAR promote-and-prune loop runs on the out-of-repo store). It's the template others copy, so the disabled state propagates. *(auto-memory: RESOLVED this pass.)*
- **F2 — M6 phantom home** (`M6`): `opinion-register.md:18` cites a README "migration note" deleted by commit `40fe49f`. Opinion survives in AUD+CM — stale citation, not lost opinion.
- **F3 — two stale worktrees** (`O6`): `lucid-agnesi-d48e54` is 0-ahead of main (safe remove); `amazing-dirac-3a8c31` is detached at v2.30.0 containing the deleted `skills/` dir — superseded (needs `--force`).
- **F4 — checksum families guarded only manually** (`P2`,`P11`,`RB`): `<test-driven-development>` (SE↔CTO) and `<behavioural-authority>` (5 homes) are byte-identical today but NO script enforces it — only the runbook's manual recipe. A future edit forgetting a sibling passes CI undetected. **The one real systemic gap.**
- **F5 (minor)** — incomplete DOC-d2d span at `opinion-register.md:231` (omits `operator-seam-and-agent-tools.md`) (`K5`); orphaned `plans/hierarchical-agent-orientation.md` (`K1/K5`); possibly-dead `managing-promode-retirement.md` (`K4`); checker unit-tests (`test-check-*.sh`) not wired into CI (`P2`); harness pin one patch stale — running 2.1.202 vs register's 2.1.201, changelog confirms no re-probe needed (`⚙`); ~10 dead local branches + empty `.claude/hooks/` dir (`P5`).

## Verified clean
All 8 hook sub-checks green (max output 8925/10000); CI gate real; all documented calibrations still hold; CLAUDE.md 49/50 lines; Rule of Two (`O11`) intact in all homes; register slugs unique, all agent/command/doc homes resolve.

## Prioritised plan (as ratified)
**[Now]** worktree.baseRef; auto-memory in-repo (DONE this pass); fix M6 phantom home; remove 2 stale worktrees.
**[Now, methodology-lead]** checksum-guard script wired into check-hooks.sh/CI (promoted from [Next] by the main agent — it's the only live systemic hole, and it's promode's own crystallise-into-determinism doctrine left un-crystallised).
**[Later]** wire checker unit-tests into CI; complete DOC-d2d span; verify/retire the two suspect docs; bump ⚙ pin to 2.1.202; prune dead branches + empty `.claude/hooks/`.

## AAR finding (process)
The auditor's first pass STALLED: its fan-out was surfaced by the harness as background children whose completion notifications bubbled to the root session (exactly as probe P2 predicts), and it ended its turn expecting to be woken. It recovered by collecting reports from transcripts (no wasted work), but `plugins/promode/agents/auditor.md` needs the foreground-synchronous-await requirement made unmissable and hardened against a harness that returns background handles.

## Skipped/merged dimensions
5 assessors, not 8. Tests/Observability/Design skipped as N/A (prompt/markdown corpus — no app code, runtime, request path, or visual surface; the corpus's "tests" are the shell invariant-checks, audited under hook-invariants). Change-hygiene merged into Architecture. Framing scoped to register↔corpus traceability (the register IS this repo's goal hierarchy). Product-framing lens (does promode trace to evidence-based user needs/personas of its own?) NOT run — distinct follow-up.
