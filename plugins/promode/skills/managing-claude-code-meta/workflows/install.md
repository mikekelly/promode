<required_reading>
Read these before proceeding:
1. `standard/MAIN_AGENT_CLAUDE.md` — The promode CLAUDE.md for main agents
2. references/progressive-disclosure.md — Context on README distribution
</required_reading>

<never_do>
- NEVER modify `standard/MAIN_AGENT_CLAUDE.md` content when copying to target project
- NEVER proceed if CLAUDE.md already exists (route to migrate workflow instead)
- NEVER create README.md files over 150 lines
- NEVER skip the verification step (Step 6)
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

## Step 4: Create Root README.md (if missing)

If no README.md exists, create one with:
- Project name and one-line description
- Quick start (how to run locally)
- Project structure overview with links to package READMEs
- Links to key documentation

**Keep it under 150 lines.** Deep details go in package READMEs.

## Step 5: Create Package READMEs

For each significant package/directory identified in Step 2:

Create a README.md with:
- What this package does (1-2 sentences)
- Key files and their purposes
- Domain-specific patterns or conventions
- Links to related packages

**Each README should be under 150 lines.**

## Step 6: Verify Installation

Run a quick check:
```bash
cat {project_path}/CLAUDE.md | head -5
```

Confirm:
- [ ] CLAUDE.md matches `standard/MAIN_AGENT_CLAUDE.md` exactly
</process>

<success_criteria>
Installation is complete when:
- [ ] CLAUDE.md installed at project root (exact copy of `standard/MAIN_AGENT_CLAUDE.md`)
- [ ] Root README.md exists with project overview
- [ ] At least one package README.md created (if packages exist)
- [ ] Agent can navigate from CLAUDE.md → README.md → package READMEs
</success_criteria>
