<required_reading>
Read these before proceeding:
1. `standard/MAIN_AGENT_CLAUDE.md` — The promode CLAUDE.md for main agents
2. references/progressive-disclosure.md — Context on README distribution
3. references/mcp-servers.md — Required MCP server configuration
4. references/lsp-servers.md — LSP server configuration for code intelligence
</required_reading>

<never_do>
- NEVER modify `standard/MAIN_AGENT_CLAUDE.md` content when copying to target project
- NEVER proceed if CLAUDE.md already exists (route to migrate workflow instead)
- NEVER create README.md files over 150 lines
- NEVER skip the verification step (Step 8)
</never_do>

<escalation>
Stop and ask the user when:
- Project has unconventional structure (no src/, packages/, lib/, or apps/)
- Existing README.md has substantial content that might conflict
- You're unsure which directories warrant their own README.md
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
- [ ] README.md exists (or will need to create one)

## Step 2: Assess Project Structure

Identify key directories that will need README.md files:
```bash
find {project_path} -type d -name "src" -o -name "packages" -o -name "lib" -o -name "apps" | head -20
```

Note packages/modules that have distinct domains and will benefit from their own README.md.

## Step 3: Install CLAUDE.md

Copy `standard/MAIN_AGENT_CLAUDE.md` to the project root exactly as-is. Do not modify it.

This installs the promode methodology for the main agent. The standard CLAUDE.md is designed to work universally — it defines agent behaviour, not project knowledge. Project-specific information belongs in README.md files.

**Note**: Sub-agents don't inherit CLAUDE.md. Main agents should delegate to `promode-subagent`, which already understands the methodology.

## Step 4: Install MCP Servers

Create `.mcp.json` in the project root with the required MCP servers (see `references/mcp-servers.md`):

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

## Step 5: Install LSP Servers

Configure LSP servers for languages detected in the project (see `references/lsp-servers.md`).

**Step 5a: Detect languages**

```bash
# Check for common language files
find {project_path} -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) | head -3
find {project_path} -type f -name "*.py" | head -3
find {project_path} -type f -name "*.go" | head -3
find {project_path} -type f -name "*.rs" | head -3
find {project_path} -type f \( -name "*.ex" -o -name "*.exs" \) | head -3
```

**Step 5b: Configure official LSP plugins**

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

**Step 5c: Configure custom LSP servers**

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

**Note**: LSP plugins require the language server binary to be installed separately (gopls, pyright, etc.).

## Step 6: Create Root README.md (if missing)

If no README.md exists, create one with:
- Project name and one-line description
- Quick start (how to run locally)
- Project structure overview with links to package READMEs
- Links to key documentation

**Keep it under 150 lines.** Deep details go in package READMEs.

## Step 7: Create Package READMEs

For each significant package/directory identified in Step 2:

Create a README.md with:
- What this package does (1-2 sentences)
- Key files and their purposes
- Domain-specific patterns or conventions
- Links to related packages

**Each README should be under 150 lines.**

## Step 8: Verify Installation

Run a quick check:
```bash
cat {project_path}/CLAUDE.md | head -5
cat {project_path}/.mcp.json
cat {project_path}/.claude/settings.local.json 2>/dev/null | grep -E "lsp"
cat {project_path}/.lsp.json 2>/dev/null
```

Confirm:
- [ ] CLAUDE.md matches `standard/MAIN_AGENT_CLAUDE.md` exactly
- [ ] `.mcp.json` contains all 3 MCP servers (context7, exa, grep_app)
- [ ] LSP configured for detected languages (plugins in settings.local.json and/or .lsp.json)
</process>

<success_criteria>
Installation is complete when:
- [ ] CLAUDE.md installed at project root (exact copy of `standard/MAIN_AGENT_CLAUDE.md`)
- [ ] MCP servers installed in `.mcp.json` (context7, exa, grep_app)
- [ ] LSP servers configured for detected languages
- [ ] Root README.md exists with project overview
- [ ] At least one package README.md created (if packages exist)
- [ ] Agent can navigate from CLAUDE.md → README.md → package READMEs
</success_criteria>
