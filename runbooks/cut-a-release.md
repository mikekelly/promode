# Runbook: Cut a release / bump the version

What this is: how to ship a new version of the promode plugin. Read this when a change is
ready to publish and the version number needs to move.

## Where the version lives

The plugin version lives in **one place only**:

- `plugins/promode/.claude-plugin/plugin.json` — the `"version"` field (semver `x.y.z`).

`.claude-plugin/marketplace.json` does **not** carry a version, so there is nothing to keep
in sync. (Verified: a repo-wide search finds `"version"` only in `plugin.json`.)

## How releases are actually cut here

There is no separate "release commit". Looking at the history, the version bump is **bundled
into the same commit as the change it ships** — e.g. `e9bf378` ("Add reinforce-design-constraints
skill; bump to 2.10.0") edited `plugin.json` alongside the new skill, and `510b071` bumped
`2.7.1 -> 2.7.2` in the same commit that mirrored the methodology change. Publishing is just
pushing to the default branch (the marketplace serves the plugin straight from the repo source —
`source: ./plugins/promode`); there is no tag step or build artifact in this repo.

## Steps

1. **Land the substantive change** (agent/command/doc/brief/script edits) in your working tree, with
   its tests/checks green — including `./scripts/check-hooks.sh` if you touched the brief or hooks.
2. **Pick the new semver.** Patch for fixes/wording, minor for new agents/commands/capabilities.
   (No major bump has happened in recent history; treat it as a breaking-change signal.)
3. **Bump it with the script** (prefer the script over hand-editing):

   ```
   scripts/bump-version.sh <new-version>    # e.g. 2.11.0
   ```

   It edits only `plugin.json`, refuses a non-semver argument, and is a no-op if the version
   already matches.
4. **Commit the bump together with the change it ships** (one commit, as the history does), with
   a message that names both the change and the bump. End the message with the repo's
   `Co-Authored-By` trailer (see the convention in the project's commit history).
5. **Push** to the default branch. That publishes it — enabled installs pick up the new brief/agents
   on their next session (the hook reads from the plugin via `${CLAUDE_PLUGIN_ROOT}`).

## See also

- Script: [`scripts/bump-version.sh`](../scripts/bump-version.sh)
- Hub: [`RUNBOOKS.md`](../RUNBOOKS.md)
