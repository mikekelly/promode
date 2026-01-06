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

## Step 5: Audit README Distribution

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

## Step 6: Check Navigation Chain

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

## Step 7: Generate Audit Report

Create a summary:

```markdown
# CLAUDE.md Audit Report

## Summary
- **CLAUDE.md**: {PASS/FAIL} (exact match with standard)
- **MCP Servers**: {PASS/FAIL} ({count}/3 servers configured)
- **LSP Servers**: {PASS/WARN/FAIL} ({count}/{total} languages covered)
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

## Step 8: Provide Recommendations

Based on findings, recommend:

**If CLAUDE.md doesn't match standard:**
→ Replace with exact copy of `standard/MAIN_AGENT_CLAUDE.md`. Move any project-specific content to README.md files.

**If MCP servers missing:**
→ Add missing servers to `.mcp.json`. See `references/mcp-servers.md` for configuration.

**If LSP servers missing for detected languages:**
→ For TypeScript/Python/Rust: Enable official plugins in `.claude/settings.local.json`
→ For Go/Elixir/others: Add custom config to `.lsp.json`. See `references/lsp-servers.md`.

**If READMEs missing:**
→ List specific packages needing documentation

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
- [ ] MCP servers checked in .mcp.json
- [ ] LSP servers checked for detected languages
- [ ] README distribution assessed
- [ ] Navigation chain tested
- [ ] Audit report generated
- [ ] Actionable recommendations provided
</success_criteria>
