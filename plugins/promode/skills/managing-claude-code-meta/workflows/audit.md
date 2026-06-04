<required_reading>
Read these before proceeding:
1. `standard/MAIN_AGENT_CLAUDE.md` — The promode CLAUDE.md (project should match exactly)
2. references/progressive-disclosure.md — Principles being audited against
</required_reading>

<never_do>
- NEVER report PASS if CLAUDE.md doesn't match standard/MAIN_AGENT_CLAUDE.md exactly
- NEVER skip navigation chain testing (Step 5)
- NEVER auto-fix issues — audit reports findings, does not modify files
- NEVER ignore missing AGENT_ORIENTATION.md files in significant packages
</never_do>

<escalation>
Stop and ask the user when:
- Project has no CLAUDE.md at all (suggest install workflow)
- Project structure is so non-standard that audit criteria don't apply
- You find security-sensitive content in CLAUDE.md (credentials, keys)
</escalation>

<process>
## Step 1: Gather Project Information

Collect key metrics:
```bash
# Required components
ls {project_path}/CLAUDE.md 2>/dev/null || echo "MISSING: CLAUDE.md"
ls {project_path}/KANBAN_BOARD.md 2>/dev/null || echo "MISSING: KANBAN_BOARD.md"
ls {project_path}/IDEAS.md 2>/dev/null || echo "MISSING: IDEAS.md"
ls {project_path}/DONE.md 2>/dev/null || echo "MISSING: DONE.md"
ls {project_path}/AGENT_ORIENTATION.md 2>/dev/null || echo "MISSING: AGENT_ORIENTATION.md"

# AGENT_ORIENTATION.md distribution
find {project_path} -name "AGENT_ORIENTATION.md" -type f | head -20

# Package/module structure
find {project_path} -type d -name "src" -o -name "packages" -o -name "lib" -o -name "apps" 2>/dev/null | head -10

# README for structure hints
cat {project_path}/README.md 2>/dev/null | head -100
```

## Step 2: Audit CLAUDE.md

**Exact match check:**

The project's CLAUDE.md should be an exact copy of this skill's `standard/MAIN_AGENT_CLAUDE.md` (the promode methodology for main agents). Read both files and compare them:

1. Read the project's CLAUDE.md: `{project_path}/CLAUDE.md`
2. Read this skill's standard: `standard/MAIN_AGENT_CLAUDE.md` (relative to this skill's directory)

| Result | Status | Action |
|--------|--------|--------|
| No differences | PASS | CLAUDE.md correctly implements promode methodology |
| Differences found | FAIL | Replace with exact copy of `standard/MAIN_AGENT_CLAUDE.md` |

If there are differences, note what was added/changed. Any project-specific content should be moved to AGENT_ORIENTATION.md files.

**Note**: Sub-agents don't inherit CLAUDE.md. Phase-specific agents (implementer, reviewer, debugger) handle execution; main agents handle brainstorming, planning, and orchestration directly.

## Step 3: Audit Project Tracking Files

Check if the three project tracking files exist with correct structure:

### KANBAN_BOARD.md
```bash
cat {project_path}/KANBAN_BOARD.md 2>/dev/null | head -20
```

**Required structure:**
- `## Doing` — Currently being worked on
- `## Ready` — Designed + planned, can be picked up

| Result | Status | Action |
|--------|--------|--------|
| Both columns present | PASS | KANBAN_BOARD.md correctly structured |
| Missing columns | WARN | Add missing columns |
| File missing | FAIL | Create KANBAN_BOARD.md |

### IDEAS.md
```bash
cat {project_path}/IDEAS.md 2>/dev/null | head -10
```

| Result | Status | Action |
|--------|--------|--------|
| File exists | PASS | IDEAS.md present |
| File missing | FAIL | Create IDEAS.md for raw ideas |

### DONE.md
```bash
cat {project_path}/DONE.md 2>/dev/null | head -10
```

| Result | Status | Action |
|--------|--------|--------|
| File exists | PASS | DONE.md present |
| File missing | FAIL | Create DONE.md for completed work archive |

## Step 4: Audit Progressive Disclosure

This step analyzes the project structure and documentation to assess AGENT_ORIENTATION.md coverage and suggest improvements.

**Step 4a: Analyze README for structure hints**

```bash
# Look for package/component structure in README
cat {project_path}/README.md 2>/dev/null | grep -E "^##|packages/|src/|lib/|apps/" | head -30
```

The README often documents the project structure. Look for:
- Package/module descriptions that should have their own AGENT_ORIENTATION.md
- Architecture sections that hint at significant components
- Directories mentioned that might warrant agent guidance

**Step 4b: Identify significant directories**

```bash
# Find potential packages that should have AGENT_ORIENTATION.md
find {project_path} -type d -maxdepth 3 \( -name "packages" -o -name "src" -o -name "lib" -o -name "apps" \) -exec ls -d {}/* \; 2>/dev/null | head -20

# Check package.json files (monorepo indicators)
find {project_path} -name "package.json" -maxdepth 3 | head -10
```

**Step 4c: Check existing AGENT_ORIENTATION.md coverage**

```bash
# Find all AGENT_ORIENTATION.md files
find {project_path} -name "AGENT_ORIENTATION.md" -type f
```

**Step 4d: Build coverage assessment**

| Directory | Has AGENT_ORIENTATION.md | Quality | Notes |
|-----------|--------------------------|---------|-------|
| root | Yes/No | Good/Sparse/Verbose | |
| packages/api | Yes/No | Good/Sparse/Verbose | |
| packages/web | Yes/No | Good/Sparse/Verbose | |
| {other significant dirs} | Yes/No | Good/Sparse/Verbose | |

**Quality criteria:**
- **Good**: Compact, covers purpose + key files + patterns + gotchas
- **Sparse**: Missing key information an agent would need
- **Verbose**: Too much detail — should be more compact or split into package files

**Step 4e: Identify gaps and suggest placements**

Based on README structure and directory analysis:

| Suggested Location | Reason | Priority |
|--------------------|--------|----------|
| {path}/AGENT_ORIENTATION.md | {why this needs one} | High/Medium/Low |

**Common indicators a directory needs AGENT_ORIENTATION.md:**
- Has its own package.json (monorepo package)
- Contains domain-specific logic (api, auth, database)
- Referenced in README as a distinct component
- Has >5 source files with non-obvious patterns
- Has gotchas or conventions not obvious from code

## Step 5: Check Navigation Chain

Test the agent navigation path:

1. **CLAUDE.md → AGENT_ORIENTATION.md**
   - Does CLAUDE.md point to AGENT_ORIENTATION.md?
   - Is the path correct?

2. **AGENT_ORIENTATION.md → Package AGENT_ORIENTATION.md**
   - Does root AGENT_ORIENTATION.md link to package docs?
   - Are links valid?

3. **Package AGENT_ORIENTATION.md → Code**
   - Do package orientation files reference actual files?
   - Are key entry points documented?

## Step 6: Generate Audit Report

Create a summary:

```markdown
# Promode Audit Report

## Summary
| Component | Status | Notes |
|-----------|--------|-------|
| CLAUDE.md | {PASS/FAIL} | {exact match with standard?} |
| KANBAN_BOARD.md | {PASS/WARN/FAIL} | {exists with Doing/Ready columns?} |
| IDEAS.md | {PASS/FAIL} | {exists?} |
| DONE.md | {PASS/FAIL} | {exists?} |
| Root AGENT_ORIENTATION.md | {PASS/FAIL} | {exists and quality?} |
| Progressive Disclosure | {GOOD/NEEDS_WORK} | {coverage}/{total} packages |
| Navigation Chain | {COMPLETE/INCOMPLETE} | {all links valid?} |

## Issues Found

### Critical (must fix)
- {issues that break promode functionality}

### Warnings (should fix)
- {issues that degrade agent effectiveness}

### Suggestions (nice to have)
- {improvements based on README/structure analysis}

## Recommended AGENT_ORIENTATION.md Additions
{Based on Step 4e analysis, list specific directories that should have AGENT_ORIENTATION.md}

## Recommended Actions
1. ...
2. ...
```

## Step 7: Provide Recommendations

Based on findings, recommend:

**If CLAUDE.md doesn't match standard:**
→ Replace with exact copy of `standard/MAIN_AGENT_CLAUDE.md`. Move any project-specific content to AGENT_ORIENTATION.md files.

**If KANBAN_BOARD.md missing or malformed:**
→ Create/fix with standard columns: Doing, Ready.

**If IDEAS.md missing:**
→ Create IDEAS.md for capturing raw ideas without derailing current work.

**If DONE.md missing:**
→ Create DONE.md for archiving completed work.

**If Root AGENT_ORIENTATION.md missing:**
→ Create with project structure, commands, and gotchas.

**If package AGENT_ORIENTATION.md files missing:**
→ List specific directories identified in Step 4e that need orientation files.
→ Prioritize directories referenced in README or containing domain-specific logic.

**If navigation broken:**
→ Identify broken links and suggest fixes
</process>

<audit_checklist>
**Required Components:**
- [ ] CLAUDE.md — Exact match with `standard/MAIN_AGENT_CLAUDE.md`
- [ ] KANBAN_BOARD.md — Exists with columns (Doing, Ready)
- [ ] IDEAS.md — Exists for raw ideas
- [ ] DONE.md — Exists for completed work archive
- [ ] Root AGENT_ORIENTATION.md — Exists and is compact

**Progressive Disclosure:**
- [ ] Root AGENT_ORIENTATION.md is compact (not verbose)
- [ ] Each significant package has AGENT_ORIENTATION.md (based on README/structure analysis)
- [ ] Package orientation files cover purpose + key files + patterns + gotchas
- [ ] Orientation files reference tests rather than duplicating code examples
- [ ] No orphaned directories missing orientation when they should have one

**Navigation:**
- [ ] CLAUDE.md → AGENT_ORIENTATION.md link works
- [ ] AGENT_ORIENTATION.md → package orientation files linked
- [ ] All links valid
</audit_checklist>

<success_criteria>
Audit is complete when:
- [ ] All required components checked (CLAUDE.md, KANBAN_BOARD.md, IDEAS.md, DONE.md, AGENT_ORIENTATION.md)
- [ ] CLAUDE.md compared against standard
- [ ] KANBAN_BOARD.md structure verified (Doing, Ready columns)
- [ ] IDEAS.md and DONE.md existence verified
- [ ] README and project structure analyzed for progressive disclosure gaps
- [ ] AGENT_ORIENTATION.md coverage and quality assessed
- [ ] Navigation chain tested
- [ ] Audit report generated with component status table
- [ ] Specific recommendations for missing AGENT_ORIENTATION.md files provided
</success_criteria>
