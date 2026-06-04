<required_reading>
Read these before proceeding:
1. `standard/PROMODE_MAIN_AGENT.md` — The brief that will be installed
2. `standard/hooks/promode-main-context.sh` — The hook that will be installed
3. `references/main-agent-delivery.md` — Why delivery is via hook, not CLAUDE.md
</required_reading>

<never_do>
- NEVER put the orchestration brief in `CLAUDE.md`; NEVER overwrite or clobber existing `CLAUDE.md` content
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

## Step 5: CLAUDE.md — Do Not Put the Brief Here

The promode orchestration brief must never go in `CLAUDE.md`. The brief is delivered by the hook installed in Step 3–4.

If the project has an existing `CLAUDE.md`, do not overwrite or modify it — it is the project's own file and the root of the agent-knowledge graph; its content is preserved as-is.

If the project has **no `CLAUDE.md`**, create a minimal one now as the knowledge root (see Step 6).

## Step 6: Scaffold Optional Promode Conventions (offer, do not force)

The brief references `KANBAN_BOARD.md`. Offer to scaffold missing files — never overwrite existing files.

Ask the user: "Would you like me to scaffold `KANBAN_BOARD.md`? I'll only create it if it doesn't already exist."

If the user agrees, create only the missing files:

### CLAUDE.md (if missing — create as knowledge root)
If no `CLAUDE.md` exists (and one was not created in Step 5), create a minimal one now. This is the **root of the agent-knowledge graph**; agents will add links to it as knowledge accrues:
```markdown
# {Project Name}

<!-- Agent-knowledge root. Add links here as knowledge docs are created. -->
```

### KANBAN_BOARD.md (if missing)
```markdown
# Kanban Board

## Doing
<!-- Currently being worked on -->

## Ready
<!-- Designed + planned, can be picked up -->
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
- [ ] `CLAUDE.md` is present as the knowledge root (created if missing; existing content preserved; does not contain the orchestration brief)
- [ ] `jq` is available on PATH
</process>

<success_criteria>
Installation is complete when:
- [ ] `.claude/PROMODE_MAIN_AGENT.md` — exact copy of `standard/PROMODE_MAIN_AGENT.md`
- [ ] `.claude/hooks/promode-main-context.sh` — exact copy of the standard hook, executable (`chmod +x`)
- [ ] `.claude/settings.json` — SessionStart entry with all four matchers merged in, existing content preserved
- [ ] `CLAUDE.md` present as the knowledge root (created if it was missing; existing content preserved; never holds the orchestration brief)
- [ ] `jq` confirmed available on PATH
</success_criteria>
