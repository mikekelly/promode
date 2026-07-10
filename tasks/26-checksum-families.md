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
(filled by the agent on completion)
