<required_reading>
Read these before proceeding:
1. `standard/PROMODE_MAIN_AGENT.md` — The latest brief
2. `standard/hooks/promode-main-context.sh` — The latest hook
</required_reading>

<never_do>
- NEVER create, overwrite, or modify the project's `CLAUDE.md` — promode never owns it
- NEVER overwrite `.claude/settings.json` wholesale — MERGE the hook entry, preserve all other content
- NEVER skip the verification step (Step 4)
</never_do>

<escalation>
Stop and ask the user when:
- No `.claude/` directory exists (suggest install workflow instead)
- `jq` is not available on PATH
- `.claude/settings.json` has a conflicting SessionStart hook that is not the promode one
</escalation>

<process>
## Step 1: Verify Existing Install

Confirm promode is already installed before updating:
```bash
ls -la {project_path}/.claude/PROMODE_MAIN_AGENT.md 2>/dev/null || echo "MISSING"
ls -la {project_path}/.claude/hooks/promode-main-context.sh 2>/dev/null || echo "MISSING"
ls -la {project_path}/.claude/settings.json 2>/dev/null || echo "MISSING"
```

**Routing:**
- No `.claude/` directory or brief missing → Route to **install workflow** instead
- Brief and hook present → Continue with update

## Step 2: Re-copy the Brief and Hook

The brief and hook in `.claude/` are promode-owned files. Overwrite them with the latest versions from `standard/`:

- `standard/PROMODE_MAIN_AGENT.md` → `{project_path}/.claude/PROMODE_MAIN_AGENT.md` (overwrite)
- `standard/hooks/promode-main-context.sh` → `{project_path}/.claude/hooks/promode-main-context.sh` (overwrite)

Copy exactly — do not modify contents. Then ensure the hook is executable:
```bash
chmod +x {project_path}/.claude/hooks/promode-main-context.sh
```

The project's `CLAUDE.md` is **not touched** — it is the project's own and promode never modifies it.

## Step 3: Ensure the SessionStart Entry Is Present

Read `{project_path}/.claude/settings.json` and check whether a `SessionStart` entry with all four matchers is present.

Required entry (all four matchers, exact command path):
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

- If already present with all four matchers → no change needed
- If partially present or missing → MERGE the missing matchers into the existing `SessionStart` array, preserving all other settings.json content
- If `settings.json` does not exist → create it with the entry above

Do not clobber any existing keys, permissions, or hooks.

## Step 4: Verify Update

Run a quick check:
```bash
ls -la {project_path}/.claude/PROMODE_MAIN_AGENT.md
ls -la {project_path}/.claude/hooks/promode-main-context.sh
test -x {project_path}/.claude/hooks/promode-main-context.sh && echo "hook is executable" || echo "NOT EXECUTABLE"
cat {project_path}/.claude/settings.json
```

**Verification checklist:**
- [ ] `.claude/PROMODE_MAIN_AGENT.md` matches `standard/PROMODE_MAIN_AGENT.md` exactly
- [ ] `.claude/hooks/promode-main-context.sh` matches the standard hook exactly and is executable
- [ ] `.claude/settings.json` has a `SessionStart` entry with all four matchers (`startup`, `resume`, `clear`, `compact`)
- [ ] Project's `CLAUDE.md` (if any) was not touched

## Step 5: Report Update Summary

Provide a concise summary:

```
# Promode Update Summary

## Updated
- .claude/PROMODE_MAIN_AGENT.md — refreshed to latest standard
- .claude/hooks/promode-main-context.sh — refreshed to latest standard

## Settings
- .claude/settings.json — {updated / already current}

## Status
- {PASS: all components verified} / {list any issues}
```
</process>

<required_components>
Every correctly updated promode install has:

| File | Location | Note |
|------|----------|------|
| `PROMODE_MAIN_AGENT.md` | `{project}/.claude/` | Exact copy of `standard/PROMODE_MAIN_AGENT.md` |
| `promode-main-context.sh` | `{project}/.claude/hooks/` | Exact copy, `chmod +x` |
| `settings.json` | `{project}/.claude/` | SessionStart entry with 4 matchers, merged in |
</required_components>

<success_criteria>
Update is complete when:
- [ ] `.claude/PROMODE_MAIN_AGENT.md` updated to latest `standard/PROMODE_MAIN_AGENT.md`
- [ ] `.claude/hooks/promode-main-context.sh` updated to latest standard hook, executable
- [ ] `.claude/settings.json` has SessionStart entry with all four matchers
- [ ] Project's `CLAUDE.md` untouched
</success_criteria>
