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
(filled by the agent on completion)
