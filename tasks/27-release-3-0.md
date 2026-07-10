# Release promode 3.0.0 (breaking: agent roster restructure)

## Brief
- **Orient** — depends on tasks 19–26 merged AND the main agent's review/verification checkpoint passing. Runbook: `runbooks/cut-a-release.md` (defers to `scripts/bump-version.sh`).
- **Specify** — bump `plugins/promode/.claude-plugin/plugin.json` 2.40.0 → **3.0.0** (major: `product-design-expert` removed, `fast-worker` semantics changed, new agents added — consumers' dispatch habits break), following the runbook flow (bump → commit → push per its steps; stop before any step needing credentials you lack and report). Update `DONE.md` with the shipped roster line; retire the completed cards from `KANBAN_BOARD.md`.
- **Why** — semver honesty: a fork or consumer pinning 2.x must not silently receive a roster where fast-worker no longer carries TDD.
- **Verified vs assumed** — verify the runbook's steps against the script before running; if the runbook and script disagree, behavioural authority: the script is code, the runbook is docs — flag the drift.
- **Not / exit** — no content changes to defs/brief/register. Exit: version bumped + committed per runbook, board/DONE updated, report confirms the release commit hash.

## State
- **Open constraints** — blocked on tasks 19–26 + main-agent review checkpoint (code-reviewer over the full diff, invariant scripts green).

## Outcome
**Done (2026-07-10).** Followed `runbooks/cut-a-release.md` (verified against `scripts/bump-version.sh`
first — no drift between runbook and script). Bumped `plugins/promode/.claude-plugin/plugin.json`
`2.40.0` → **3.0.0** via `scripts/bump-version.sh 3.0.0`. Re-ran `scripts/check-hooks.sh` after the
bump: version-banner check (`check-version-in-context.sh`) confirmed green against the new version
("Promode v3.0.0" in chunk 1's `additionalContext`), and the full invariant suite (checksum families,
chunk registration/gating, `@`-import guard, inspector fixtures) stayed green. Also ran the
CI-wired checker unit tests (`test-check-claude-md-imports.sh`, `test-check-component-frontmatter.sh`,
`test-context-monitor.sh`) — all pass.

Added the wave-2/release DONE.md line (brief+register sync, peripheral scrub, checksum families,
fresh-review APPROVED, v3.0.0) and retired both completed cards (task 25 peripheral-sync, this
release task) from `KANBAN_BOARD.md`'s Ready/Doing columns — Doing is now empty (no other card was
in it) and Ready no longer lists this release.

**Deliberate deviation from the runbook:** did **not** push. Per this task's brief, the branch goes
up for the maintainer's ratification — pushing to the default branch is the maintainer's call, not
this agent's, even though `runbooks/cut-a-release.md` step 5 says to push. Everything through
"commit" is done; the commit sits on `claude/engineer-agent-models-e606ea` unpushed.

**No content changes** to any agent def, the brief, or the register — scope was version bump +
DONE/board bookkeeping only, per the brief's Not/exit line.

Release commit: `122e110` ("Release v3.0.0: agent-roster restructure (major, breaking)").
