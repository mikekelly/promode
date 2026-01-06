<required_reading>
Read these before proceeding:
1. The existing CLAUDE.md in the target project
2. `standard/MAIN_AGENT_CLAUDE.md` — The promode CLAUDE.md for main agents
3. references/progressive-disclosure.md — Principles for content distribution
4. references/mcp-servers.md — Required MCP server configuration
</required_reading>

<never_do>
- NEVER delete content without first confirming its destination (MOVE or DELETE must be explicit)
- NEVER leave content orphaned — every section must be categorised as KEEP, MOVE, or DELETE
- NEVER modify `standard/MAIN_AGENT_CLAUDE.md` content when replacing the old file
- NEVER create circular references between README files
- NEVER skip the navigation test (Step 7)
</never_do>

<escalation>
Stop and ask the user when:
- Content doesn't clearly fit KEEP/MOVE/DELETE categories
- Migration would delete substantial content (>50 lines) without a clear destination
- Existing README.md files are already bloated (>150 lines)
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
- Workflow patterns (TDD, task management)
- Definition of done
- Orientation pointers to README.md

**Note**: Even if the existing CLAUDE.md has good agent behaviour content, it will be replaced with `standard/MAIN_AGENT_CLAUDE.md`. The standard is comprehensive and should not be modified.

**MOVE to README.md** (project knowledge):
- Tech stack details
- API endpoint documentation
- Database schema information
- Environment variable lists
- Third-party service configurations
- Testing commands/scripts
- Build/deploy procedures

**DELETE** (redundant or stale):
- Obvious information Claude already knows
- Duplicated content
- Outdated instructions

## Step 2: Map Content to Destinations

Create a migration plan:

| Content | Current Location | New Location | Reason |
|---------|------------------|--------------|--------|
| ... | CLAUDE.md line X | README.md | Project knowledge |
| ... | CLAUDE.md line Y | packages/api/README.md | API-specific |
| ... | CLAUDE.md line Z | DELETE | Redundant |

## Step 3: Create/Update README Files

For each destination identified:

**Root README.md:**
- Project overview
- Quick start
- Architecture overview
- Links to package READMEs

**Package README.md files:**
- Module-specific context
- Key files and patterns
- Domain-specific conventions

## Step 4: Replace CLAUDE.md

Replace the existing CLAUDE.md with an exact copy of `standard/MAIN_AGENT_CLAUDE.md`. Do not modify it.

This installs the promode methodology for the main agent. The standard CLAUDE.md is designed to work universally — all project-specific content belongs in README.md files.

**Note**: Sub-agents don't inherit CLAUDE.md. Main agents should delegate to `promode-subagent`, which already understands the methodology.

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

## Step 6: Verify Migration

Check the result:
```bash
wc -l {project_path}/README.md
find {project_path} -name "README.md" | wc -l
```

Confirm:
- [ ] New CLAUDE.md matches `standard/MAIN_AGENT_CLAUDE.md` exactly
- [ ] `.mcp.json` contains all 3 MCP servers (context7, exa, grep_app)
- [ ] All moved content is accessible via README.md chain
- [ ] No orphaned content (everything moved or deliberately deleted)

## Step 7: Test Agent Navigation

Simulate an agent's path:
1. Read CLAUDE.md — Get agent behaviour instructions
2. Read README.md — Get project overview
3. Navigate to package README — Get domain-specific context

If any step feels incomplete, add content to the appropriate README.
</process>

<common_content_migrations>
**Tech stack → Root README.md**
```
# Before (CLAUDE.md)
We use React 18, TypeScript, and Vite for the frontend.
The backend is Node.js with Express and PostgreSQL.

# After (README.md)
## Tech Stack
- Frontend: React 18, TypeScript, Vite
- Backend: Node.js, Express, PostgreSQL
```

**API documentation → packages/api/README.md**
```
# Before (CLAUDE.md)
The API has these endpoints:
- GET /users - List users
- POST /users - Create user

# After (packages/api/README.md)
## Endpoints
See route definitions in `src/routes/`. Key endpoints:
- /users — User management
- /auth — Authentication
```

**Environment variables → Root README.md**
```
# Before (CLAUDE.md)
Required env vars: DATABASE_URL, API_KEY, JWT_SECRET

# After (README.md)
## Environment
Copy `.env.example` to `.env`. Required variables documented in the example file.
```

**Testing commands → Root README.md or CONTRIBUTING.md**
```
# Before (CLAUDE.md)
Run tests with: npm test
Run specific test: npm test -- --grep "pattern"

# After (README.md)
## Development
- `npm test` — Run test suite
- `npm run dev` — Start dev server
```
</common_content_migrations>

<success_criteria>
Migration is complete when:
- [ ] Old CLAUDE.md content fully categorised (keep/move/delete)
- [ ] New CLAUDE.md installed (exact copy of `standard/MAIN_AGENT_CLAUDE.md`)
- [ ] MCP servers installed in `.mcp.json` (context7, exa, grep_app)
- [ ] Moved content placed in appropriate README.md files
- [ ] Content navigation tested (CLAUDE.md → README.md → package READMEs)
</success_criteria>
