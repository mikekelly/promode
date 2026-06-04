<required_reading>
Read these before proceeding:
1. `standard/MAIN_AGENT_CLAUDE.md` — The latest promode CLAUDE.md
2. references/progressive-disclosure.md — Context on AGENT_ORIENTATION.md distribution
</required_reading>

<never_do>
- NEVER proceed if CLAUDE.md doesn't exist (route to install workflow)
- NEVER modify project-specific AGENT_ORIENTATION.md content — only update standard components
- NEVER skip the component verification step
</never_do>

<escalation>
Stop and ask the user when:
- CLAUDE.md has project-specific modifications that would be lost
- Project has custom components that might conflict with updates
- You're unsure if existing configuration should be preserved or replaced
</escalation>

<process>
## Step 1: Verify Existing Installation

Confirm promode is already installed:
```bash
ls -la {project_path}/CLAUDE.md
ls -la {project_path}/KANBAN_BOARD.md 2>/dev/null
ls -la {project_path}/IDEAS.md 2>/dev/null
ls -la {project_path}/DONE.md 2>/dev/null
ls -la {project_path}/AGENT_ORIENTATION.md 2>/dev/null
```

**Routing:**
- No CLAUDE.md exists → Route to **install workflow** instead
- CLAUDE.md exists → Continue with update

## Step 2: Update CLAUDE.md to Latest Version

Replace the project's CLAUDE.md with the latest `standard/MAIN_AGENT_CLAUDE.md`.

**Important**: CLAUDE.md should NOT contain project-specific content. If it does, that content should be moved to AGENT_ORIENTATION.md before updating. Check for differences first:

1. Read project's CLAUDE.md
2. Compare with `standard/MAIN_AGENT_CLAUDE.md`
3. If differences are only version updates → replace directly
4. If project-specific content exists → warn user, suggest moving to AGENT_ORIENTATION.md

## Step 3: Ensure Required Components Exist

Check and create any missing standard components:

### KANBAN_BOARD.md
```bash
ls {project_path}/KANBAN_BOARD.md 2>/dev/null || echo "MISSING"
```

If missing, create with standard structure:
```markdown
# Kanban Board

## Doing
<!-- Currently being worked on -->

## Ready
<!-- Designed + planned, can be picked up -->
```

### IDEAS.md
```bash
ls {project_path}/IDEAS.md 2>/dev/null || echo "MISSING"
```

If missing, create:
```markdown
# Ideas

Raw thoughts and ideas, not yet spec'd or evaluated.

<!-- Add ideas here as they come up -->
```

### DONE.md
```bash
ls {project_path}/DONE.md 2>/dev/null || echo "MISSING"
```

If missing, create:
```markdown
# Done

Completed work. Archive periodically.

<!-- Move completed items here from Kanban -->
```

### Root AGENT_ORIENTATION.md
```bash
ls {project_path}/AGENT_ORIENTATION.md 2>/dev/null || echo "MISSING"
```

If missing, create a minimal one (see install workflow Step 5 for template).

## Step 4: Analyze Progressive Disclosure

Check if AGENT_ORIENTATION.md files are properly distributed:

**Step 4a: Find significant directories**
```bash
# Look for package directories
find {project_path} -type d -name "src" -o -name "packages" -o -name "lib" -o -name "apps" 2>/dev/null | head -20

# Check README for package structure hints
cat {project_path}/README.md 2>/dev/null | head -50
```

**Step 4b: Check existing AGENT_ORIENTATION.md files**
```bash
find {project_path} -name "AGENT_ORIENTATION.md" -type f
```

**Step 4c: Identify gaps**
For each significant package without AGENT_ORIENTATION.md, note it as a recommendation.

## Step 5: Verify Update

Run verification checks:

```bash
# CLAUDE.md matches standard
cat {project_path}/CLAUDE.md | head -5

# Required components exist
ls {project_path}/KANBAN_BOARD.md
ls {project_path}/IDEAS.md
ls {project_path}/DONE.md
ls {project_path}/AGENT_ORIENTATION.md
```

**Verification checklist:**
- [ ] CLAUDE.md matches `standard/MAIN_AGENT_CLAUDE.md` exactly
- [ ] KANBAN_BOARD.md exists with Doing/Ready columns
- [ ] IDEAS.md exists
- [ ] DONE.md exists
- [ ] Root AGENT_ORIENTATION.md exists

## Step 6: Report Update Summary

Provide a summary of what was updated:

```markdown
# Update Summary

## Updated
- CLAUDE.md updated to latest version
- {list other updates}

## Created (was missing)
- {list any created components}

## Recommendations
- {list any AGENT_ORIENTATION.md files that should be created}
- {list any other improvements}
```
</process>

<required_components>
Every promode project should have these components:

| Component | Location | Purpose |
|-----------|----------|---------|
| CLAUDE.md | project root | Main agent behaviour (exact copy of standard) |
| KANBAN_BOARD.md | project root | Kanban board (Doing, Ready columns) |
| IDEAS.md | project root | Raw ideas, not yet spec'd |
| DONE.md | project root | Completed work archive |
| AGENT_ORIENTATION.md | project root | Compact agent guidance for the project |
| Package AGENT_ORIENTATION.md | each significant package | Domain-specific agent guidance |
</required_components>

<success_criteria>
Update is complete when:
- [ ] CLAUDE.md updated to latest `standard/MAIN_AGENT_CLAUDE.md`
- [ ] Required components exist (KANBAN_BOARD.md, IDEAS.md, DONE.md, AGENT_ORIENTATION.md)
- [ ] Progressive disclosure gaps identified and reported
</success_criteria>
