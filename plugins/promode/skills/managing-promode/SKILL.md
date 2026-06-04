---
name: managing-promode
description: "MUST be loaded when setting up, installing, updating, or auditing promode in a project. Promode delivers a main-agent orchestration brief via a SessionStart hook and never puts its methodology in the project's own CLAUDE.md. Invoke PROACTIVELY when the user mentions installing/setting up promode, the promode hook, or auditing a promode install."
---

<essential_principles>
This skill sets up the **promode methodology** in a project. Promode never puts its methodology in `CLAUDE.md` (that's hook-delivered) and never clobbers it.

**1. The main-agent brief is delivered by a hook, not CLAUDE.md**
`PROMODE_MAIN_AGENT.md` (the team-lead orchestration brief) is injected into the **main agent only**, by a `SessionStart` hook gated on `agent_id`. It never reaches subagents. See `references/main-agent-delivery.md` for why.

**2. CLAUDE.md is the project's own file and the agent-knowledge root**
The project's `CLAUDE.md` is auto-loaded into every agent and serves as the root of the agent-knowledge graph. Promode does not put its orchestration brief there. Agents maintain it over time (adding links to new knowledge docs); existing content is never overwritten. A minimal `CLAUDE.md` may be created if none exists.

**3. Subagents are self-contained**
Phase agents (implementer, code-reviewer, debugger, …) carry the methodology in their own definitions, so they need nothing installed into the project.

**4. Agent knowledge is an interlinked markdown graph rooted at CLAUDE.md**
Durable project knowledge for agents lives as a graph of linked markdown docs. `CLAUDE.md` is the root — it links out to key areas; docs link to each other densely. File location doesn't matter — the links carry the graph. Distinct from README.md (for humans). See `references/agent-knowledge-wiki.md`.
</essential_principles>

<never_do>
- NEVER put the orchestration brief in `CLAUDE.md`; NEVER overwrite or clobber existing `CLAUDE.md` content (the knowledge graph only appends + links; a minimal `CLAUDE.md` may be created if none exists)
- NEVER modify `standard/PROMODE_MAIN_AGENT.md` or the standard hook when copying into a project — copy them exactly
- NEVER overwrite an existing `.claude/settings.json` — always MERGE the hook entry, preserving existing settings
</never_do>

<escalation>
Stop and ask the user when:
- The project is not under git, or has uncommitted changes
- `.claude/settings.json` already has a conflicting `SessionStart` hook
- `jq` is not available (the hook needs it)
- Changes would affect more than a handful of files
</escalation>

<intake>
What would you like to do?

1. **Install** — Set up promode in a project (adds the SessionStart hook + brief; leaves CLAUDE.md alone)
2. **Update** — Refresh an existing promode install to the latest brief + hook
3. **Audit** — Check whether promode is correctly installed

**Wait for response before proceeding.**
</intake>

<routing>
| Response | Workflow |
|----------|----------|
| 1, "install", "set up", "add promode" | workflows/install.md |
| 2, "update", "upgrade", "refresh" | workflows/update.md |
| 3, "audit", "check", "verify" | workflows/audit.md |

**After reading the workflow, follow it exactly.**
</routing>

<quick_reference>
Promode install footprint in a target project:
```
<project>/
├── CLAUDE.md                          # the project's own file + agent-knowledge root (created if missing, never clobbered)
└── .claude/
    ├── PROMODE_MAIN_AGENT.md          # main-agent brief (copied from standard/)
    ├── hooks/promode-main-context.sh  # SessionStart hook (copied from standard/)
    └── settings.json                  # SessionStart entry (MERGED; matchers startup|resume|clear|compact)
```
The hook injects `PROMODE_MAIN_AGENT.md` into the main agent only (gated on `agent_id`); it re-fires on `clear`/`compact`, so the brief survives both. Requires `jq`.
</quick_reference>

<reference_index>
- `standard/PROMODE_MAIN_AGENT.md` — the main-agent brief (copy into `.claude/` exactly)
- `standard/hooks/promode-main-context.sh` — the SessionStart hook (copy into `.claude/hooks/` exactly)
- `references/main-agent-delivery.md` — why the brief is hook-delivered, not in CLAUDE.md
- `references/agent-knowledge-wiki.md` — the interlinked-graph model for durable agent knowledge
</reference_index>

<workflows_index>
| Workflow | Purpose |
|----------|---------|
| install.md | Set up the promode hook + brief in a project |
| update.md | Refresh the brief + hook to the latest version |
| audit.md | Check the install is present and current |
</workflows_index>

<success_criteria>
A correctly-installed project has:
- `.claude/PROMODE_MAIN_AGENT.md` — exact copy of `standard/PROMODE_MAIN_AGENT.md`
- `.claude/hooks/promode-main-context.sh` — exact copy of the standard hook, executable
- `.claude/settings.json` — a `SessionStart` hook entry (matchers `startup|resume|clear|compact`) running the hook
- `CLAUDE.md` present as the knowledge root (created if it was missing; existing content preserved; never holds the orchestration brief)
- `jq` available on PATH
</success_criteria>
