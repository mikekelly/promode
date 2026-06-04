<required_reading>
Read these before proceeding:
1. `standard/PROMODE_MAIN_AGENT.md` — The brief the project should have installed
2. `standard/hooks/promode-main-context.sh` — The hook the project should have installed
</required_reading>

<never_do>
- NEVER modify any project files — audit is read-only
- NEVER report PASS for a component that has not been explicitly checked
- NEVER auto-fix issues — report findings and specific remediation only
</never_do>

<escalation>
Stop and ask the user when:
- The project has no `.claude/` directory at all (suggest install workflow)
- Project structure is so non-standard that audit criteria cannot be applied
</escalation>

<process>
## Step 1: Check the Brief

Verify `.claude/PROMODE_MAIN_AGENT.md` is present and matches the standard:

```bash
ls -la {project_path}/.claude/PROMODE_MAIN_AGENT.md 2>/dev/null || echo "MISSING"
```

If present, read both and compare:
1. `{project_path}/.claude/PROMODE_MAIN_AGENT.md`
2. `standard/PROMODE_MAIN_AGENT.md` (relative to this skill's directory)

| Result | Status | Remediation |
|--------|--------|-------------|
| File present, exact match | PASS | — |
| File present, differs | FAIL | Re-copy `standard/PROMODE_MAIN_AGENT.md` exactly (update workflow) |
| File missing | FAIL | Run install workflow |

## Step 2: Check the Hook

Verify `.claude/hooks/promode-main-context.sh` is present, executable, and matches the standard:

```bash
ls -la {project_path}/.claude/hooks/promode-main-context.sh 2>/dev/null || echo "MISSING"
```

If present, check executability:
```bash
test -x {project_path}/.claude/hooks/promode-main-context.sh && echo "executable" || echo "NOT EXECUTABLE"
```

Read both and compare content:
1. `{project_path}/.claude/hooks/promode-main-context.sh`
2. `standard/hooks/promode-main-context.sh`

| Result | Status | Remediation |
|--------|--------|-------------|
| Present, executable, exact match | PASS | — |
| Present but not executable | FAIL | `chmod +x {project_path}/.claude/hooks/promode-main-context.sh` |
| Present, executable, but differs | FAIL | Re-copy `standard/hooks/promode-main-context.sh` exactly |
| File missing | FAIL | Run install workflow |

## Step 3: Check settings.json for the SessionStart Entry

Read `.claude/settings.json` and verify it contains a `SessionStart` entry with all four required matchers:

```bash
cat {project_path}/.claude/settings.json 2>/dev/null || echo "MISSING"
```

Required matchers (all four must be present, each pointing at the hook):
- `startup`
- `resume`
- `clear`
- `compact`

| Result | Status | Remediation |
|--------|--------|-------------|
| All four matchers present, correct command | PASS | — |
| Some matchers missing | FAIL | Note which are missing; merge them in (update workflow) |
| SessionStart entry absent | FAIL | Merge the full entry (update workflow) |
| settings.json missing | FAIL | Run install workflow |

**Why all four matter**: Without `compact`, the brief is silently dropped after the first `/compact`. Without `clear`, it is dropped after `/clear`.

## Step 4: Check `jq` Availability

The hook depends on `jq`:

```bash
which jq && jq --version || echo "jq NOT FOUND"
```

| Result | Status | Remediation |
|--------|--------|-------------|
| `jq` found | PASS | — |
| `jq` not found | FAIL | Install jq (e.g. `brew install jq` / `apt install jq`) |

## Step 5: Generate Audit Report

Output a summary:

```
# Promode Audit Report — {project_path}

## Component Status

| Component | Status | Notes |
|-----------|--------|-------|
| .claude/PROMODE_MAIN_AGENT.md | PASS/FAIL | {exact match / differs / missing} |
| .claude/hooks/promode-main-context.sh | PASS/FAIL | {present+executable+match / issue} |
| settings.json SessionStart entry | PASS/FAIL | {all 4 matchers / missing: startup,resume,clear,compact} |
| jq available | PASS/FAIL | {version or not found} |

## Issues Found

### Critical (must fix)
- {list issues that prevent promode from working}

### Recommended Actions
1. {specific remediation for each issue, e.g. "run update workflow to re-copy the hook"}
```

Make no modifications. Report only.
</process>

<audit_checklist>
**Required for a correct promode install:**
- [ ] `.claude/PROMODE_MAIN_AGENT.md` — present, exact match with `standard/PROMODE_MAIN_AGENT.md`
- [ ] `.claude/hooks/promode-main-context.sh` — present, executable, exact match with standard hook
- [ ] `.claude/settings.json` — `SessionStart` entry with all four matchers (`startup`, `resume`, `clear`, `compact`)
- [ ] `jq` available on PATH
- [ ] Project's `CLAUDE.md` (if any) — untouched by promode (informational check, not a failure)
</audit_checklist>

<success_criteria>
Audit is complete when:
- [ ] All four components checked (brief, hook, settings, jq)
- [ ] Brief compared against standard
- [ ] Hook compared against standard and executability checked
- [ ] All four SessionStart matchers verified in settings.json
- [ ] Audit report generated with PASS/FAIL for each component
- [ ] Specific remediation provided for every FAIL
- [ ] No modifications made to any project file
</success_criteria>
