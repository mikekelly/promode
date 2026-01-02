---
name: managing-claude-code-meta
description: "MUST be loaded when setting up, installing, migrating, reviewing, auditing, or checking CLAUDE.md files in projects. Covers installing the promode CLAUDE.md into new projects, migrating existing CLAUDE.md content to READMEs (progressive disclosure), and auditing projects for conformance. Invoke PROACTIVELY when user mentions CLAUDE.md, project setup, agent configuration, or code meta files."
---

<essential_principles>
This skill manages projects that adopt the **promode methodology**.

**The core idea: the repo is always ready for a fresh agent.**

Any agent should be able to pick up the work with zero context from previous conversations. The human decides when to bring in a fresh agent; the methodology ensures that's always possible.

**How handoff works:**
1. `TODO.md` always answers "what's next?" — this is the primary handoff mechanism
2. Failing tests capture intended behaviour — the next agent knows what to implement
3. Plan docs in `docs/` explain approach — the next agent continues where you left off

**File responsibilities:**
- **CLAUDE.md** — How the agent works (the promode methodology). Standardised, not project-specific.
- **README.md** — What the project is. Project-specific knowledge.
- **TODO.md** — What to do next. Always current.
- **Tests** — What behaviour is expected. The authoritative documentation.

**CLAUDE.md is standardised**: Copy `standard/MAIN_AGENT_CLAUDE.md` exactly into projects. It works universally. All project-specific content belongs in README.md files.
</essential_principles>

<never_do>
- NEVER modify `standard/MAIN_AGENT_CLAUDE.md` content — it must be copied exactly into projects
- NEVER add project-specific content to CLAUDE.md (use README.md files instead)
- NEVER duplicate content between CLAUDE.md and README.md — single source of truth
- NEVER skip verifying CLAUDE.md matches the standard after installation or migration
</never_do>

<escalation>
Stop and ask the user when:
- Project is not under git version control or has uncommited changes
- Content doesn't fit KEEP/MOVE/DELETE categories during migration
- Existing README.md files conflict with the suggested structure
- You've attempted the same step 3+ times without success
- Changes would affect more than 10 files
</escalation>

<intake>
What would you like to do?

1. **Install** — Set up the standard CLAUDE.md in a new project
2. **Migrate** — Refactor an existing CLAUDE.md, moving content to READMEs
3. **Audit** — Check if a project follows progressive disclosure principles

**Wait for response before proceeding.**
</intake>

<routing>
| Response | Next Action | Workflow |
|----------|-------------|----------|
| 1, "install", "setup", "new", "create" | Confirm project path | workflows/install.md |
| 2, "migrate", "refactor", "move", "convert" | Analyze existing CLAUDE.md | workflows/migrate.md |
| 3, "audit", "check", "review", "assess" | Scan project structure | workflows/audit.md |

**Intent-based routing:**
- "set up CLAUDE.md", "add agent config" → workflows/install.md
- "CLAUDE.md is too big", "slim down", "refactor" → workflows/migrate.md
- "is this right?", "check conformance" → workflows/audit.md

**After reading the workflow, follow it exactly.**
</routing>

<quick_reference>
**CLAUDE.md**: Copy `standard/MAIN_AGENT_CLAUDE.md` exactly. Do not modify. This configures the agent with promode methodology.

**README.md distribution:**
```
project/
├── CLAUDE.md           # Agent behaviour (promode methodology)
├── README.md           # Project overview, links to main components
└── docs/
    └── {feature}/      # Ephemeral planning docs and task specs
```
</quick_reference>

<reference_index>
- `standard/MAIN_AGENT_CLAUDE.md` — The canonical CLAUDE.md (copy exactly into projects)
- `references/progressive-disclosure.md` — Why and how to distribute content to READMEs
- `references/claude-md-sections.md` — Purpose of each CLAUDE.md section
</reference_index>

<workflows_index>
All in `workflows/`:

| Workflow | Purpose |
|----------|---------|
| install.md | Install standard CLAUDE.md into new project |
| migrate.md | Migrate existing CLAUDE.md content to READMEs |
| audit.md | Audit project for progressive disclosure conformance |
</workflows_index>

<success_criteria>
A well-configured project:

- CLAUDE.md is an exact copy of `standard/MAIN_AGENT_CLAUDE.md`
- README.md at project root with overview and navigation
- Component README.md files throughout for domain-specific context
- Tests document system behaviour, not markdown files
</success_criteria>
