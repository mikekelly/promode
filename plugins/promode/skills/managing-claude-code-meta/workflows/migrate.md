<required_reading>
Read these before proceeding:
1. The existing CLAUDE.md in the target project
2. `standard/MAIN_AGENT_CLAUDE.md` — The promode CLAUDE.md for main agents
3. references/progressive-disclosure.md — Principles for content distribution
4. references/mcp-servers.md — Required MCP server configuration
5. references/lsp-servers.md — LSP server configuration for code intelligence
</required_reading>

<never_do>
- NEVER delete content without first confirming its destination (MOVE or DELETE must be explicit)
- NEVER leave content orphaned — every section must be categorised as KEEP, MOVE, or DELETE
- NEVER modify `standard/MAIN_AGENT_CLAUDE.md` content when replacing the old file
- NEVER create circular references between AGENT_ORIENTATION.md files
- NEVER skip the navigation test (Step 8)
</never_do>

<escalation>
Stop and ask the user when:
- Content doesn't clearly fit KEEP/MOVE/DELETE categories
- Migration would delete substantial content (>50 lines) without a clear destination
- Existing AGENT_ORIENTATION.md files duplicate content that should be in tests
- You find conflicting information across files
</escalation>

<process>
## Step 1: Analyse Existing CLAUDE.md

Read the existing file:
```bash
cat {project_path}/CLAUDE.md
```

Categorise each section into:

**KEEP in CLAUDE.md** (promode methodology — but will be replaced by standard):
- Critical instructions about communication style
- Main agent role and delegation patterns
- Workflow patterns (TDD, orchestration)
- Definition of done
- Orientation pointers to AGENT_ORIENTATION.md

**Note**: Even if the existing CLAUDE.md has good agent behaviour content, it will be replaced with `standard/MAIN_AGENT_CLAUDE.md`. The standard is comprehensive and should not be modified.

**MOVE to AGENT_ORIENTATION.md** (project knowledge):
- Tech stack details
- API endpoint documentation
- Database schema information
- Environment variable lists
- Third-party service configurations
- Testing commands/scripts
- Build/deploy procedures
- Key entry points and file locations
- Common gotchas and workarounds

**DELETE** (redundant or stale):
- Obvious information Claude already knows
- Duplicated content
- Outdated instructions

## Step 2: Map Content to Destinations

Create a migration plan:

| Content | Current Location | New Location | Reason |
|---------|------------------|--------------|--------|
| ... | CLAUDE.md line X | AGENT_ORIENTATION.md | Project knowledge |
| ... | CLAUDE.md line Y | packages/api/AGENT_ORIENTATION.md | API-specific |
| ... | CLAUDE.md line Z | DELETE | Redundant |

## Step 3: Create/Update AGENT_ORIENTATION.md Files

For each destination identified:

**Root AGENT_ORIENTATION.md:**
- Project structure overview
- How to run tests and build
- Common gotchas
- Links to package AGENT_ORIENTATION.md files

**Package AGENT_ORIENTATION.md files:**
- Module-specific context
- Key files and patterns
- Domain-specific conventions
- Gotchas

Keep all content compact — every line should save more tokens than it costs.

## Step 4: Replace CLAUDE.md

Replace the existing CLAUDE.md with an exact copy of `standard/MAIN_AGENT_CLAUDE.md`. Do not modify it.

This installs the promode methodology for the main agent. The standard CLAUDE.md is designed to work universally — all project-specific content belongs in AGENT_ORIENTATION.md files.

**Note**: Sub-agents don't inherit CLAUDE.md. Main agents handle brainstorming, planning, and orchestration directly, then delegate execution to phase-specific agents (implementer, reviewer, debugger).

## Step 5: Install MCP Servers

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

## Step 6: Install LSP Servers

Configure LSP servers for languages detected in the project (see `references/lsp-servers.md`).

**Step 6a: Detect languages**

```bash
# Check for common language files
find {project_path} -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) | head -3
find {project_path} -type f -name "*.py" | head -3
find {project_path} -type f -name "*.go" | head -3
find {project_path} -type f -name "*.rs" | head -3
find {project_path} -type f \( -name "*.ex" -o -name "*.exs" \) | head -3
```

**Step 6b: Configure official LSP plugins**

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

**Step 6c: Configure custom LSP servers**

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

**Step 6d: Verify language server binaries are installed**

Check that the required binaries are available:

```bash
# For each detected language, verify the binary exists
which typescript-language-server 2>/dev/null || echo "MISSING: typescript-language-server (npm install -g typescript-language-server typescript)"
which pyright 2>/dev/null || echo "MISSING: pyright (pip install pyright)"
which rust-analyzer 2>/dev/null || echo "MISSING: rust-analyzer (see https://rust-analyzer.github.io)"
which gopls 2>/dev/null || echo "MISSING: gopls (go install golang.org/x/tools/gopls@latest)"
```

If any required binaries are missing, inform the user they need to install them for LSP to work.

## Step 7: Verify Migration

Check the result:
```bash
cat {project_path}/AGENT_ORIENTATION.md 2>/dev/null | head -20
find {project_path} -name "AGENT_ORIENTATION.md" | wc -l
```

Confirm:
- [ ] New CLAUDE.md matches `standard/MAIN_AGENT_CLAUDE.md` exactly
- [ ] `.mcp.json` contains all 3 MCP servers (context7, exa, grep_app)
- [ ] LSP configured for detected languages (plugins in settings.local.json and/or .lsp.json)
- [ ] All moved content is accessible via AGENT_ORIENTATION.md chain
- [ ] No orphaned content (everything moved or deliberately deleted)

## Step 8: Test Agent Navigation

Simulate an agent's path:
1. Read CLAUDE.md — Get agent behaviour instructions
2. Read AGENT_ORIENTATION.md — Get project-specific context
3. Navigate to package AGENT_ORIENTATION.md — Get domain-specific context

If any step feels incomplete, add content to the appropriate AGENT_ORIENTATION.md.
</process>

<common_content_migrations>
**Tech stack → Root AGENT_ORIENTATION.md**
```
# Before (CLAUDE.md)
We use React 18, TypeScript, and Vite for the frontend.
The backend is Node.js with Express and PostgreSQL.

# After (AGENT_ORIENTATION.md)
## Stack
React 18 + TypeScript + Vite (frontend), Node.js + Express + PostgreSQL (backend)
```

**API documentation → packages/api/AGENT_ORIENTATION.md**
```
# Before (CLAUDE.md)
The API has these endpoints:
- GET /users - List users
- POST /users - Create user

# After (packages/api/AGENT_ORIENTATION.md)
## Routes
Routes in `src/routes/`:
- users.ts — CRUD operations
- auth.ts — Authentication
```

**Environment variables → Root AGENT_ORIENTATION.md**
```
# Before (CLAUDE.md)
Required env vars: DATABASE_URL, API_KEY, JWT_SECRET

# After (AGENT_ORIENTATION.md)
## Environment
See `.env.example` for required variables.
```

**Testing commands → Root AGENT_ORIENTATION.md**
```
# Before (CLAUDE.md)
Run tests with: npm test
Run specific test: npm test -- --grep "pattern"

# After (AGENT_ORIENTATION.md)
## Commands
- `npm test` — run tests
- `npm run dev` — start dev server
```
</common_content_migrations>

<success_criteria>
Migration is complete when:
- [ ] Old CLAUDE.md content fully categorised (keep/move/delete)
- [ ] New CLAUDE.md installed (exact copy of `standard/MAIN_AGENT_CLAUDE.md`)
- [ ] MCP servers installed in `.mcp.json` (context7, exa, grep_app)
- [ ] LSP servers configured for detected languages
- [ ] Moved content placed in appropriate AGENT_ORIENTATION.md files
- [ ] Content navigation tested (CLAUDE.md → AGENT_ORIENTATION.md → package AGENT_ORIENTATION.md)
</success_criteria>
