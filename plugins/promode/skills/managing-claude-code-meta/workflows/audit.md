<required_reading>
Read these before proceeding:
1. `standard/MAIN_AGENT_CLAUDE.md` — The promode CLAUDE.md (project should match exactly)
2. references/progressive-disclosure.md — Principles being audited against
3. references/mcp-servers.md — Required MCP server configuration
4. references/lsp-servers.md — LSP server configuration for code intelligence
</required_reading>

<never_do>
- NEVER report PASS if CLAUDE.md doesn't match standard/MAIN_AGENT_CLAUDE.md exactly
- NEVER skip navigation chain testing (Step 6)
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
# AGENT_ORIENTATION.md presence
find {project_path} -name "AGENT_ORIENTATION.md" -type f | head -20

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

If there are differences, note what was added/changed. Any project-specific content should be moved to AGENT_ORIENTATION.md files.

**Note**: Sub-agents don't inherit CLAUDE.md. Phase-specific agents (implementer, reviewer, debugger) handle execution; main agents handle brainstorming, planning, and orchestration directly.

## Step 3: Audit MCP Servers

Check that required MCP servers are installed in the project's `.mcp.json`:

```bash
cat {project_path}/.mcp.json 2>/dev/null || echo "MISSING"
```

**Required servers** (see `references/mcp-servers.md` for full config):

| Server | Status | Notes |
|--------|--------|-------|
| context7 | Present/Missing | Documentation lookup |
| exa | Present/Missing | Web search |
| grep_app | Present/Missing | GitHub code search |

| Result | Status | Action |
|--------|--------|--------|
| All 3 servers present | PASS | MCP configuration correct |
| Missing servers | FAIL | Add missing servers to `.mcp.json` |
| No .mcp.json | FAIL | Create file with MCP configuration |

**Note**: The `EXA_API_KEY` environment variable is user-provided and should NOT be in the file — only the `${EXA_API_KEY}` reference.

## Step 4: Audit LSP Servers

Check that LSP servers are configured for languages used in the project.

**Step 4a: Detect languages used**

```bash
# Find language files in the project
find {project_path} -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) | head -5
find {project_path} -type f -name "*.py" | head -5
find {project_path} -type f -name "*.go" | head -5
find {project_path} -type f -name "*.rs" | head -5
find {project_path} -type f \( -name "*.ex" -o -name "*.exs" \) | head -5
```

**Step 4b: Check LSP configuration**

For official plugins, check `.claude/settings.local.json`:
```bash
cat {project_path}/.claude/settings.local.json 2>/dev/null | grep -E "typescript-lsp|pyright-lsp|rust-lsp"
```

For custom LSP servers, check `.lsp.json`:
```bash
cat {project_path}/.lsp.json 2>/dev/null || echo "No custom LSP config"
```

**Required LSP by language** (see `references/lsp-servers.md`):

| Language | Files Found | LSP Required | Status |
|----------|-------------|--------------|--------|
| TypeScript/JS | Yes/No | typescript-lsp plugin | Configured/Missing |
| Python | Yes/No | pyright-lsp plugin | Configured/Missing |
| Rust | Yes/No | rust-lsp plugin | Configured/Missing |
| Go | Yes/No | gopls in .lsp.json | Configured/Missing |
| Elixir | Yes/No | elixir-ls in .lsp.json | Configured/Missing |

**Step 4c: Verify language server binaries are installed**

For each configured LSP, check that the binary exists:

```bash
which typescript-language-server 2>/dev/null || echo "MISSING: typescript-language-server"
which pyright 2>/dev/null || echo "MISSING: pyright"
which rust-analyzer 2>/dev/null || echo "MISSING: rust-analyzer"
which gopls 2>/dev/null || echo "MISSING: gopls"
```

| Result | Status | Action |
|--------|--------|--------|
| All detected languages have LSP + binaries | PASS | LSP configuration complete |
| LSP configured but binary missing | WARN | Install missing language server binary |
| Missing LSP config for some languages | WARN | Add LSP config for uncovered languages |
| No LSP configured at all | FAIL | Configure LSP servers for code intelligence |

**Note**: LSP is a warning (WARN) not a hard failure — projects can function without it, but code intelligence significantly improves agent effectiveness.

## Step 5: Audit AGENT_ORIENTATION.md Distribution

For each significant package/directory:

```bash
# Check if AGENT_ORIENTATION.md exists
ls {package_path}/AGENT_ORIENTATION.md 2>/dev/null || echo "MISSING"
```

| Package | Has AGENT_ORIENTATION.md | Content Quality |
|---------|--------------------------|-----------------|
| root | Yes/No | Good/Sparse/Verbose |
| packages/api | Yes/No | Good/Sparse/Verbose |
| packages/web | Yes/No | Good/Sparse/Verbose |

**AGENT_ORIENTATION.md quality criteria:**
- **Good**: Compact, covers purpose + key files + patterns + gotchas
- **Sparse**: Missing key information an agent would need
- **Verbose**: Too much detail — should be more compact or split into package files

## Step 6: Check Navigation Chain

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

## Step 7: Generate Audit Report

Create a summary:

```markdown
# CLAUDE.md Audit Report

## Summary
- **CLAUDE.md**: {PASS/FAIL} (exact match with standard)
- **MCP Servers**: {PASS/FAIL} ({count}/3 servers configured)
- **LSP Servers**: {PASS/WARN/FAIL} ({count}/{total} languages covered)
- **AGENT_ORIENTATION.md coverage**: {count}/{total} packages have orientation files
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

## Step 8: Provide Recommendations

Based on findings, recommend:

**If CLAUDE.md doesn't match standard:**
→ Replace with exact copy of `standard/MAIN_AGENT_CLAUDE.md`. Move any project-specific content to AGENT_ORIENTATION.md files.

**If MCP servers missing:**
→ Add missing servers to `.mcp.json`. See `references/mcp-servers.md` for configuration.

**If LSP servers missing for detected languages:**
→ For TypeScript/Python/Rust: Enable official plugins in `.claude/settings.local.json`
→ For Go/Elixir/others: Add custom config to `.lsp.json`. See `references/lsp-servers.md`.

**If AGENT_ORIENTATION.md files missing:**
→ List specific packages needing orientation files

**If navigation broken:**
→ Identify broken links and suggest fixes
</process>

<audit_checklist>
**CLAUDE.md:**
- [ ] Exact match with `standard/MAIN_AGENT_CLAUDE.md`

**MCP Servers (in .mcp.json):**
- [ ] context7 server configured
- [ ] exa server configured
- [ ] grep_app server configured

**LSP Servers (for detected languages):**
- [ ] TypeScript/JS → typescript-lsp plugin enabled
- [ ] Python → pyright-lsp plugin enabled
- [ ] Rust → rust-lsp plugin enabled
- [ ] Go → gopls configured in .lsp.json
- [ ] Other languages → appropriate LSP in .lsp.json

**AGENT_ORIENTATION.md Distribution:**
- [ ] Root AGENT_ORIENTATION.md exists
- [ ] Root AGENT_ORIENTATION.md is compact (not verbose)
- [ ] Each major package has AGENT_ORIENTATION.md
- [ ] Package orientation files cover purpose + key files + patterns + gotchas
- [ ] Orientation files reference tests rather than duplicating code examples

**Navigation:**
- [ ] CLAUDE.md → AGENT_ORIENTATION.md link works
- [ ] AGENT_ORIENTATION.md → package orientation files linked
- [ ] All links valid
</audit_checklist>

<success_criteria>
Audit is complete when:
- [ ] All metrics gathered
- [ ] CLAUDE.md analysed against checklist
- [ ] MCP servers checked in .mcp.json
- [ ] LSP servers checked for detected languages
- [ ] AGENT_ORIENTATION.md distribution assessed
- [ ] Navigation chain tested
- [ ] Audit report generated
- [ ] Actionable recommendations provided
</success_criteria>
