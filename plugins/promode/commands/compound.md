---
description: Document a solved problem in docs/solutions/ for future reference. Knowledge compounds.
---

# Knowledge Capture

You just solved a non-trivial problem. Document it so future agents (and humans) don't have to re-investigate.

## When to Use

Use this after:
- Debugging a tricky issue
- Figuring out how to use an API or tool
- Discovering a non-obvious pattern or workaround
- Solving a problem that took significant investigation

## Your Task

### Step 1: Identify the Category

Solutions are organized by category in `docs/solutions/`:

```
docs/solutions/
├── test-failures/        # Debugging test issues
├── build-issues/         # Build, compilation, bundling
├── api-integration/      # External API gotchas
├── performance-issues/   # Performance debugging
├── deployment/           # Deployment and infrastructure
├── tooling/              # Dev tools, LSP, linters
└── {domain}/             # Domain-specific (e.g., auth/, payments/)
```

Create the category directory if it doesn't exist.

### Step 2: Write the Solution Document

Create `docs/solutions/{category}/{descriptive-name}.md`:

```markdown
# {Problem Title}

## Problem
{What was the symptom? What error message or unexpected behavior?}

## Context
{When does this happen? What conditions trigger it?}

## Root Cause
{Why did this happen? The actual underlying issue.}

## Solution
{How to fix it. Be specific — include code, commands, config.}

## Prevention
{How to avoid this in the future, if applicable.}

## Related
{Links to relevant docs, issues, or other solutions.}
```

### Step 3: Link from AGENT_ORIENTATION.md (if appropriate)

If this solution is something agents should know about proactively (not just when searching), add a link to the root `AGENT_ORIENTATION.md`:

```markdown
## Known Solutions
- [{Problem Title}](docs/solutions/{category}/{name}.md) — {one-line summary}
```

Only link solutions that are:
- Frequently encountered
- Critical to avoid (e.g., data loss scenarios)
- Not discoverable through normal search

Most solutions should NOT be linked — they're found by searching `docs/solutions/` when needed.

### Step 4: Commit

```bash
git add docs/solutions/
git add AGENT_ORIENTATION.md  # if updated
git commit -m "docs: add solution for {problem summary}"
```

## Guidelines

- **Be specific** — Include exact error messages, file paths, versions
- **Be concise** — Future readers want the fix, not your journey
- **Include reproduction** — How to trigger the issue (helps verify fixes)
- **Name descriptively** — File name should indicate the problem
- **Don't duplicate** — Check if a similar solution exists first

## Example

`docs/solutions/test-failures/jest-memory-leak-with-workers.md`:

```markdown
# Jest Memory Leak with Workers

## Problem
Tests pass but Jest process hangs, memory grows unbounded.

## Context
Happens when running tests with `--runInBand` disabled and tests import heavy modules.

## Root Cause
Worker processes don't release memory properly when tests import modules that cache state globally.

## Solution
Add to `jest.config.js`:
```js
module.exports = {
  workerIdleMemoryLimit: '512MB',
  maxWorkers: '50%',
};
```

## Prevention
Avoid global state in test setup. Use `beforeEach` to reset state.
```

## After Documenting

Confirm with the user:
```
Solution documented: docs/solutions/{category}/{name}.md
{One-line summary of what was captured}
```
