<required_reading>
Read these before proceeding:
1. `standard/PROMODE_MAIN_AGENT.md` — The brief that will be installed
2. `standard/hooks/promode-main-context.sh` — The hook that will be installed
3. `references/main-agent-delivery.md` — Why delivery is via hook, not CLAUDE.md
</required_reading>

<never_do>
- NEVER create, overwrite, or modify the project's `CLAUDE.md` — promode coexists with it
- NEVER modify `standard/PROMODE_MAIN_AGENT.md` or `standard/hooks/promode-main-context.sh` when copying — copy them exactly
- NEVER overwrite an existing `.claude/settings.json` — MERGE the hook entry, preserve all other content
- NEVER skip the verification step (Step 7)
</never_do>

<escalation>
Stop and ask the user when:
- The project is not under git, or has significant uncommitted changes
- `jq` is not available on PATH (the hook needs it)
- `.claude/settings.json` already has a conflicting SessionStart hook entry
- Changes would affect more than the three install footprint files
</escalation>

<process>
## Step 1: Verify Target Project

Check the target project:
```bash
ls -la {project_path}
git -C {project_path} status 2>&1 | head -5
```

Confirm:
- [ ] Project directory exists
- [ ] Project is under git (or user has acknowledged it is not)
- [ ] Working tree is in a sane state

## Step 2: Verify `jq` Is Available

The SessionStart hook uses `jq` to format its output. Check it is on PATH:
```bash
which jq && jq --version
```

If `jq` is not found, **stop and tell the user**: install it before proceeding (e.g. `brew install jq` on macOS, `apt install jq` on Debian/Ubuntu).

## Step 3: Copy the Brief and Hook

Create `.claude/hooks/` if it does not exist:
```bash
mkdir -p {project_path}/.claude/hooks
```

Copy the files **exactly** — do not modify their contents:

- `standard/PROMODE_MAIN_AGENT.md` → `{project_path}/.claude/PROMODE_MAIN_AGENT.md`
- `standard/hooks/promode-main-context.sh` → `{project_path}/.claude/hooks/promode-main-context.sh`

Then make the hook executable:
```bash
chmod +x {project_path}/.claude/hooks/promode-main-context.sh
```

## Step 4: Merge the SessionStart Hook into settings.json

The install requires exactly this SessionStart entry in `{project_path}/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "startup", "hooks": [ { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/promode-main-context.sh" } ] },
      { "matcher": "resume",  "hooks": [ { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/promode-main-context.sh" } ] },
      { "matcher": "clear",   "hooks": [ { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/promode-main-context.sh" } ] },
      { "matcher": "compact", "hooks": [ { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/promode-main-context.sh" } ] }
    ]
  }
}
```

All four matchers are required. Without `compact`, the brief is silently dropped after the first `/compact`.

**If `settings.json` does not exist**: create it with the JSON above.

**If `settings.json` exists**: read it first, then MERGE — add the SessionStart entry while preserving all existing keys, permissions, hooks, and settings. Do not clobber any pre-existing content.

**If `settings.json` already has a conflicting `SessionStart` hook**: stop and ask the user how to proceed before modifying anything.

## Step 5: Do Not Touch CLAUDE.md

The project's `CLAUDE.md` (if any) is the project's own — promode must never create, overwrite, or modify it. Skip this entirely. The promode brief is delivered by the hook installed in Step 3–4.

## Step 6: Scaffold Optional Promode Conventions (offer, do not force)

The brief references `KANBAN_BOARD.md` and `AGENT_ORIENTATION.md`. Offer to create them if missing — never overwrite existing files.

Ask the user: "Would you like me to scaffold `KANBAN_BOARD.md` and a root `AGENT_ORIENTATION.md`? I'll only create them if they don't already exist."

If the user agrees, create only the missing files:

### KANBAN_BOARD.md (if missing)
```markdown
# Kanban Board

## Doing
<!-- Currently being worked on -->

## Ready
<!-- Designed + planned, can be picked up -->
```

### AGENT_ORIENTATION.md (if missing)
Minimal template — this is the **entry point** to the agent-knowledge graph; it links out as knowledge accrues (the project team fills in actual content):
```markdown
# Agent Orientation

## Structure
- {key directories and their purpose}

## Commands
- {test command}
- {dev server command}

## Gotchas
- {known issues and workarounds}
```

Also offer to create `IDEAS.md` and `DONE.md` if the user wants the full project-tracking setup:
```markdown
# Ideas
Raw thoughts and ideas, not yet spec'd or evaluated.
```
```markdown
# Done
Completed work. Archive periodically.
```

## Step 7: Verify Installation

Run a quick check:
```bash
ls -la {project_path}/.claude/PROMODE_MAIN_AGENT.md
ls -la {project_path}/.claude/hooks/promode-main-context.sh
ls -la {project_path}/.claude/settings.json
```

Confirm:
- [ ] `.claude/PROMODE_MAIN_AGENT.md` exists and matches `standard/PROMODE_MAIN_AGENT.md` exactly
- [ ] `.claude/hooks/promode-main-context.sh` exists, is executable, and matches the standard hook exactly
- [ ] `.claude/settings.json` contains a `SessionStart` entry with all four matchers (`startup`, `resume`, `clear`, `compact`)
- [ ] The project's `CLAUDE.md` (if it existed before install) is unchanged — promode did not touch it
- [ ] `jq` is available on PATH
</process>

<success_criteria>
Installation is complete when:
- [ ] `.claude/PROMODE_MAIN_AGENT.md` — exact copy of `standard/PROMODE_MAIN_AGENT.md`
- [ ] `.claude/hooks/promode-main-context.sh` — exact copy of the standard hook, executable (`chmod +x`)
- [ ] `.claude/settings.json` — SessionStart entry with all four matchers merged in, existing content preserved
- [ ] Project's `CLAUDE.md` untouched (promode never created or modified it)
- [ ] `jq` confirmed available on PATH
</success_criteria>
