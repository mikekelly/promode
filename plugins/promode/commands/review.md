---
description: Multi-reviewer code review on feature branch. Runs reviewers in parallel against main.
---

# Code Review Workflow

Review the current feature branch against main using specialized reviewers.

## Prerequisites

- Must be on a feature branch (not main)
- Changes must be committed

## Your Task

### Step 1: Verify Branch State

```bash
git branch --show-current
git diff main...HEAD --stat
```

If on main or no diff exists, stop and inform the user that review requires a feature branch with changes.

### Step 2: Identify Languages and Review Scope

Examine the diff to determine which reviewers are needed:

```bash
git diff main...HEAD --name-only
```

### Step 3: Launch Reviewers in Parallel

Based on the changes, launch appropriate reviewers **in parallel** using `run_in_background: true`:

**Language-specific reviewers** (pick based on files changed):
- `promode:python-reviewer` — For `.py` files
- `promode:typescript-reviewer` — For `.ts`, `.tsx`, `.js`, `.jsx` files

**Cross-cutting reviewers** (always consider):
- `promode:security-reviewer` — If auth, user input, or data handling involved
- `promode:performance-reviewer` — If hot paths, data processing, or I/O involved
- `promode:architecture-reviewer` — If module boundaries or dependencies affected
- `promode:simplicity-reviewer` — For any significant new code
- `promode:pattern-reviewer` — If design patterns are involved

**Prompt template for all reviewers:**
```
Review the changes on this feature branch against main.

Branch: {current branch}
Focus area: {specific concerns if any}

Use `git diff main...HEAD` to see changes.
```

### Step 4: Synthesize Review Results

Once all reviewers complete, synthesize their findings:

```markdown
## Review Summary: {branch-name}

### Critical Issues (must fix)
{Aggregated critical issues from all reviewers}

### Warnings (should fix)
{Aggregated warnings}

### Suggestions
{Aggregated suggestions}

### Reviewer Verdicts
| Reviewer | Verdict | Key Concerns |
|----------|---------|--------------|
| {reviewer} | {APPROVE/REQUEST_CHANGES} | {summary} |

### Overall Verdict
{APPROVE / REQUEST_CHANGES / NEEDS_DISCUSSION}

### Required Actions Before Merge
1. {action}
2. {action}
```

### Step 5: Handle Results

**If APPROVE:** Inform user they can merge.

**If REQUEST_CHANGES:**
- List specific changes needed
- Offer to create tasks for fixes
- After fixes, suggest running `/review` again

**If NEEDS_DISCUSSION:**
- Highlight the architectural or design questions
- Facilitate discussion with user

## Quick Review vs Thorough Review

**Quick review** (single reviewer):
```
/review
```
Then select the most appropriate single reviewer for the changes.

**Thorough review** (multiple reviewers):
```
/review thorough
```
Runs architecture + security + performance + simplicity reviewers in parallel.

## Guidelines

- Always run reviewers in parallel (single message, multiple Task calls)
- Use `model: sonnet` for reviewers
- Deduplicate findings — multiple reviewers may flag the same issue
- Prioritize by severity — critical issues first
- Be actionable — every issue should have a clear fix path
