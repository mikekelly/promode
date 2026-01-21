<required_reading>
Read these before proceeding:
1. `standard/MAIN_AGENT_CLAUDE.md` — The promode CLAUDE.md for main agents
2. references/progressive-disclosure.md — Context on AGENT_ORIENTATION.md distribution
3. references/mcp-servers.md — Recommended MCP server configuration (optional)
4. references/lsp-servers.md — LSP server configuration for code intelligence
</required_reading>

<never_do>
- NEVER modify `standard/MAIN_AGENT_CLAUDE.md` content when copying to target project
- NEVER proceed if CLAUDE.md already exists (route to migrate workflow instead)
- NEVER include secrets or credentials in AGENT_ORIENTATION.md files
- NEVER skip the verification step (Step 9)
</never_do>

<escalation>
Stop and ask the user when:
- Project has unconventional structure (no src/, packages/, lib/, or apps/)
- Existing AGENT_ORIENTATION.md has substantial content that might conflict
- You're unsure which directories warrant their own AGENT_ORIENTATION.md
</escalation>

<process>
## Step 1: Verify Target Project

Check the target project:
```bash
ls -la {project_path}
```

Confirm:
- [ ] Project directory exists
- [ ] No existing CLAUDE.md (if exists, suggest migrate workflow instead)
- [ ] AGENT_ORIENTATION.md exists or will need to be created

## Step 2: Assess Project Structure

Identify key directories that will need AGENT_ORIENTATION.md files:
```bash
find {project_path} -type d -name "src" -o -name "packages" -o -name "lib" -o -name "apps" | head -20
```

Note packages/modules that have distinct domains and will benefit from their own AGENT_ORIENTATION.md.

## Step 3: Install CLAUDE.md

Copy `standard/MAIN_AGENT_CLAUDE.md` to the project root exactly as-is. Do not modify it.

This installs the promode methodology for the main agent. The standard CLAUDE.md is designed to work universally — it defines agent behaviour, not project knowledge. Project-specific information belongs in AGENT_ORIENTATION.md files.

**Note**: Sub-agents don't inherit CLAUDE.md. Main agents handle brainstorming, planning, and orchestration directly, then delegate execution to phase-specific agents (implementer, debugger, tester, reviewers).

## Step 4: Create Project Tracking Files

Create these files at the project root for project tracking:

### KANBAN_BOARD.md
```markdown
# Kanban Board

## Doing
<!-- Currently being worked on -->

## Ready
<!-- Designed + planned, can be picked up -->
```

### IDEAS.md
```markdown
# Ideas

Raw thoughts and ideas, not yet spec'd or evaluated.

<!-- Add ideas here as they come up -->
```

### DONE.md
```markdown
# Done

Completed work. Archive periodically.

<!-- Move completed items here from Kanban -->
```

These three files provide persistent project tracking across sessions. The main agent maintains them as part of the promode methodology:
- **IDEAS.md** — Capture raw ideas without derailing current work
- **KANBAN_BOARD.md** — Spec'd work ready to be picked up or in progress
- **DONE.md** — Archive of completed work

## Step 5: Create docs/solutions/ Directory

Create the directory for knowledge capture:

```bash
mkdir -p {project_path}/docs/solutions
```

This is where `/compound` stores documented solutions. Categories will be created automatically as solutions are captured.

## Step 6: Install MCP Servers (Optional)

MCP servers are **optional optimisations** that improve information access:
- **context7** — Documentation lookup (faster than web search for common libraries)
- **exa** — Real-time web search (requires EXA_API_KEY)
- **grep_app** — GitHub code search (find examples across public repos)

**Ask the user:** "Would you like to install MCP servers for enhanced documentation and search capabilities? These are optional but improve agent effectiveness."

If the user wants them, create or update `.mcp.json` in the project root (see `references/mcp-servers.md`):

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "exa": {
      "command": "npx",
      "args": ["-y", "exa-mcp-server"],
      "env": {
        "EXA_API_KEY": "${EXA_API_KEY}"
      }
    },
    "grep_app": {
      "type": "http",
      "url": "https://mcp.grep.app"
    }
  }
}
```

If `.mcp.json` already exists, merge the `mcpServers` section (preserving any existing servers).

**Note**: The `EXA_API_KEY` is provided by the user's environment, not stored in the file.

If the user declines, skip this step — promode works without MCP servers.

## Step 7: Install LSP Servers

Configure LSP servers for languages detected in the project (see `references/lsp-servers.md`).

**Step 7a: Detect languages**

```bash
# Check for common language files
find {project_path} -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) | head -3
find {project_path} -type f -name "*.py" | head -3
find {project_path} -type f -name "*.go" | head -3
find {project_path} -type f -name "*.rs" | head -3
find {project_path} -type f \( -name "*.ex" -o -name "*.exs" \) | head -3
```

**Step 7b: Configure official LSP plugins**

For TypeScript, Python, or Rust, add to `.claude/settings.local.json`:

```json
{
  "enabledPlugins": {
    "typescript-lsp@claude-plugins-official": true,
    "pyright-lsp@claude-plugins-official": true,
    "rust-lsp@claude-plugins-official": true
  }
}
```

Only include plugins for languages actually used in the project. Merge with existing settings if the file exists.

**Step 7c: Configure custom LSP servers**

For Go, Elixir, or other languages, create or update `.lsp.json`:

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {".go": "go"}
  }
}
```

**Step 7d: Verify language server binaries are installed**

Check that the required binaries are available:

```bash
# For each detected language, verify the binary exists
which typescript-language-server 2>/dev/null || echo "MISSING: typescript-language-server (npm install -g typescript-language-server typescript)"
which pyright 2>/dev/null || echo "MISSING: pyright (pip install pyright)"
which rust-analyzer 2>/dev/null || echo "MISSING: rust-analyzer (see https://rust-analyzer.github.io)"
which gopls 2>/dev/null || echo "MISSING: gopls (go install golang.org/x/tools/gopls@latest)"
```

If any required binaries are missing, inform the user they need to install them for LSP to work.

## Step 8: Create Root AGENT_ORIENTATION.md (if missing)

If no AGENT_ORIENTATION.md exists at the project root, create one with:
- Project structure overview (key directories)
- How to run tests and build
- Common gotchas across the codebase
- Links to package AGENT_ORIENTATION.md files

Keep it compact — every line should save more tokens than it costs.

Example:
```markdown
# Agent Orientation

## Structure
- `packages/api/` — Backend API
- `packages/web/` — Frontend app
- `docs/` — Architecture decisions
- `docs/solutions/` — Documented problem solutions (via /compound)

## Commands
- `npm test` — Run tests
- `npm run dev` — Start dev server

## Gotchas
- {any known issues}

See package AGENT_ORIENTATION.md files for domain-specific guidance.
```

## Step 9: Create Package AGENT_ORIENTATION.md Files

For each significant package/directory identified in Step 2:

Create an AGENT_ORIENTATION.md with:
- What this package does (1 sentence)
- Key files and their purposes
- Domain-specific patterns or conventions
- Gotchas

Keep it compact. Example:
```markdown
# {Package} Agent Orientation

## Purpose
{One sentence description}

## Key Files
- `src/index.ts` — Entry point
- `src/routes/` — API routes

## Patterns
- {pattern}: {when to use}

## Gotchas
- {issue}: {workaround}
```

## Step 10: Verify Installation

Run a quick check:
```bash
cat {project_path}/CLAUDE.md | head -5
cat {project_path}/KANBAN_BOARD.md | head -10
cat {project_path}/IDEAS.md | head -5
cat {project_path}/DONE.md | head -5
ls {project_path}/docs/solutions 2>/dev/null || echo "MISSING: docs/solutions/"
cat {project_path}/.mcp.json 2>/dev/null || echo "No MCP config"
cat {project_path}/.claude/settings.local.json 2>/dev/null | grep -E "lsp"
cat {project_path}/.lsp.json 2>/dev/null
cat {project_path}/AGENT_ORIENTATION.md 2>/dev/null | head -10
```

Confirm:
- [ ] CLAUDE.md matches `standard/MAIN_AGENT_CLAUDE.md` exactly
- [ ] KANBAN_BOARD.md exists with columns (Doing, Ready)
- [ ] IDEAS.md exists for raw ideas
- [ ] DONE.md exists for completed work archive
- [ ] `docs/solutions/` directory exists for knowledge capture
- [ ] `.mcp.json` contains MCP servers (if user opted in)
- [ ] LSP configured for detected languages (plugins in settings.local.json and/or .lsp.json)
- [ ] Root AGENT_ORIENTATION.md exists with project overview
</process>

<success_criteria>
Installation is complete when:
- [ ] CLAUDE.md installed at project root (exact copy of `standard/MAIN_AGENT_CLAUDE.md`)
- [ ] KANBAN_BOARD.md created with Doing and Ready columns
- [ ] IDEAS.md created for raw ideas
- [ ] DONE.md created for completed work archive
- [ ] `docs/solutions/` directory created for knowledge capture
- [ ] MCP servers offered to user (optional — installed if user accepted)
- [ ] LSP servers configured for detected languages
- [ ] Root AGENT_ORIENTATION.md exists as thin conceptual entry point with links to solutions
- [ ] Package AGENT_ORIENTATION.md files created for significant packages
- [ ] Agent can navigate from CLAUDE.md → AGENT_ORIENTATION.md → docs/solutions/
</success_criteria>
