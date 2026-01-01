<required_reading>
Read these before proceeding:
1. `standard/MAIN_AGENT_CLAUDE.md` — The promode CLAUDE.md (project should match exactly)
2. references/progressive-disclosure.md — Principles being audited against
</required_reading>

<never_do>
- NEVER report PASS if CLAUDE.md doesn't match standard/MAIN_AGENT_CLAUDE.md exactly
- NEVER skip navigation chain testing (Step 4)
- NEVER auto-fix issues — audit reports findings, does not modify files
- NEVER ignore missing README.md files in significant packages
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
# README.md presence
find {project_path} -name "README.md" -type f | head -20

# Package/module structure
find {project_path} -type d -name "src" -o -name "packages" -o -name "lib" -o -name "apps" 2>/dev/null | head -10
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

If there are differences, note what was added/changed. Any project-specific content should be moved to README.md files.

**Note**: Sub-agents don't inherit CLAUDE.md. The promode-subagent (separate from this file) handles sub-agent behaviour.

## Step 3: Audit README Distribution

For each significant package/directory:

```bash
# Check if README exists
ls {package_path}/README.md 2>/dev/null || echo "MISSING"
```

| Package | Has README | Content Quality |
|---------|------------|-----------------|
| root | Yes/No | Good/Sparse/Bloated |
| packages/api | Yes/No | Good/Sparse/Bloated |
| packages/web | Yes/No | Good/Sparse/Bloated |

**README quality criteria:**
- **Good**: Under 150 lines, covers purpose + key files + patterns
- **Bloated**: Over 150 lines, should be split or content moved to tests

## Step 4: Check Navigation Chain

Test the agent navigation path:

1. **CLAUDE.md → README.md**
   - Does CLAUDE.md point to README.md?
   - Is the path correct?

2. **README.md → Package READMEs**
   - Does root README link to package docs?
   - Are links valid?

3. **Package READMEs → Code**
   - Do READMEs reference actual files?
   - Are key entry points documented?

## Step 5: Generate Audit Report

Create a summary:

```markdown
# CLAUDE.md Audit Report

## Summary
- **CLAUDE.md**: {PASS/FAIL} (exact match with standard)
- **README coverage**: {count}/{total} packages have READMEs
- **Navigation**: {COMPLETE/INCOMPLETE}

## Issues Found

### Critical (must fix)
- ...

### Warnings (should fix)
- ...

### Suggestions (nice to have)
- ...

## Recommended Actions
1. ...
2. ...
```

## Step 6: Provide Recommendations

Based on findings, recommend:

**If CLAUDE.md doesn't match standard:**
→ Replace with exact copy of `standard/MAIN_AGENT_CLAUDE.md`. Move any project-specific content to README.md files.

**If READMEs missing:**
→ List specific packages needing documentation

**If navigation broken:**
→ Identify broken links and suggest fixes
</process>

<audit_checklist>
**CLAUDE.md:**
- [ ] Exact match with `standard/MAIN_AGENT_CLAUDE.md`

**README Distribution:**
- [ ] Root README.md exists
- [ ] Root README under 150 lines
- [ ] Each major package has README.md
- [ ] Package READMEs cover purpose + key files
- [ ] No README over 150 lines (should split)

**Navigation:**
- [ ] CLAUDE.md → README.md link works
- [ ] README.md → package READMEs linked
- [ ] All links valid
</audit_checklist>

<success_criteria>
Audit is complete when:
- [ ] All metrics gathered
- [ ] CLAUDE.md analysed against checklist
- [ ] README distribution assessed
- [ ] Navigation chain tested
- [ ] Audit report generated
- [ ] Actionable recommendations provided
</success_criteria>
