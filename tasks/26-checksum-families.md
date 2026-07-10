# Extend checksum verification to the new byte-identity families

## Brief
- **Orient** — `scripts/check-shared-principle-checksums.sh` + `scripts/test-check-shared-principle-checksums.sh` (existing script + its test suite — read both; TDD binds). `scripts/check-hooks.sh` (the CI-gated runner that should invoke this check, verify it does). Depends on tasks 20–23 (merged) for the def files.
- **Specify** — extend the checksum script, test-first, to verify the new invariants:
  1. **Engineer-body family**: `senior-engineer.md` and `mid-level-engineer.md` bodies (everything below the closing `---` of frontmatter) are byte-identical.
  2. **Worker-body family**: `elite-worker.md`, `high-level-worker.md`, `fast-worker.md`, `cheap-worker.md` bodies byte-identical.
  3. **Reporting-block family**: the `<reporting>…</reporting>` block byte-identical across every def that carries it (enumerate membership from the committed defs).
  4. Existing checks: keep what still holds (behavioural-authority five-home byte-identity — membership may have changed with the FW rewrite; re-derive from the committed defs), retire what tasks 20–23 made obsolete (old SE↔CTO TDD-block checksum if the blocks legitimately diverged — check against the committed defs and the updated sync runbook, and if they still match, keep the check).
  - RED first for each new check: prove the check fails on a deliberately-broken fixture (the existing test suite shows the pattern), then green. A failing crystallised check must state WHICH family and WHICH file diverged.
- **Why** — "same prompt, different frontmatter" is a maintainer promise that will silently rot without a deterministic guard (P7); the checksum script is that guard, CI-gated via check-hooks.sh.
- **Verified vs assumed** — assumed the existing script's structure accommodates multi-file families; if it needs restructuring, that's in scope (it's the script's single responsibility) but keep the diff minimal (P5).
- **Not / exit** — do NOT edit defs (if a family fails byte-identity, that's a FINDING to report, not yours to fix), the brief, register, README. Exit: script + tests committed, full test suite green, `scripts/check-hooks.sh` green and invoking the check, report states each family's verified membership.

## State
- **Open constraints** — blocked on tasks 20–23 merging.

## Outcome

Done. `scripts/check-shared-principle-checksums.sh` rewritten (test-first) to guard five
byte-identity families, membership re-derived from the committed defs (tasks 20–23 reorganised
the roster into engineer/worker rungs; the old SE/FW/CTO membership was stale — the old script
in fact FAILED against the committed tree because `fast-worker.md` no longer carries
`<behavioural-authority>`):

- **engineer-body** (whole body below frontmatter): `senior-engineer.md` == `mid-level-engineer.md` ✓
- **worker-body** (whole body): `elite-worker.md` == `high-level-worker.md` == `fast-worker.md` == `cheap-worker.md` ✓
- **`<reporting>`** (generic block, 7 homes): `senior-engineer`, `mid-level-engineer`, `elite-worker`,
  `high-level-worker`, `fast-worker`, `cheap-worker`, `gui-driver` ✓ — the 10 specialised defs
  (reviewer, verifier, debugger, CTO, CPO, SPD, auditor, agent-analyzer, environment-manager,
  constraint-reinforcer) carry role-calibrated payloads (P13) and are deliberately NOT members.
- **`<behavioural-authority>`** (5 verbatim homes, membership changed): `senior-engineer`,
  `mid-level-engineer`, `chief-technology-officer`, `code-reviewer`, `debugger` ✓ (was SE/FW/CTO/CR/DBG).
- **`<test-driven-development>`** (3 homes): `senior-engineer`, `mid-level-engineer`,
  `chief-technology-officer` ✓ — SE↔CTO still match (kept, per brief); the old `assert_differs
  SE/FW` half is retired (fast-worker no longer carries a TDD block).

Test harness extended: obsolete FW-TDD fixtures (d)/(e) removed; new per-family drift fixtures
added for engineer-body, worker-body, and reporting. Each fixture verified to trip its OWN family
line (non-vacuous). No family failed byte-identity — no FINDING against the defs.

Green: `check-shared-principle-checksums.sh`, `test-check-shared-principle-checksums.sh`,
`check-hooks.sh` (invokes the check at line 17), and all four `test-*` harnesses. CI workflow
(`hook-output-limits.yml`) runs both check-hooks.sh and the test harness.

**Did NOT touch defs, brief, register, README, runbooks.** FINDING: `runbooks/sync-a-shared-principle.md`
is now stale — it still documents the old FW-based TDD/behavioural-authority families (lines 33–51)
and predates the engineer/worker/reporting families. Out of scope here (do-not-touch), flagged for
the main agent to route as a runbook-sync task.
