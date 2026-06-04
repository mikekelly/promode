---
name: managing-promode
description: "MUST be loaded when setting up, installing, updating, or auditing promode in a project. Promode delivers a main-agent orchestration brief via a SessionStart hook and never modifies the project's own CLAUDE.md. Invoke PROACTIVELY when the user mentions installing/setting up promode, the promode hook, or auditing a promode install."
---

<essential_principles>
This skill sets up the **promode methodology** in a project. Promode is delivered without ever touching the project's own `CLAUDE.md`.

**1. The main-agent brief is delivered by a hook, not CLAUDE.md**
`PROMODE_MAIN_AGENT.md` (the team-lead orchestration brief) is injected into the **main agent only**, by a `SessionStart` hook gated on `agent_id`. It never reaches subagents. See `references/main-agent-delivery.md` for why.

**2. promode never owns the project's CLAUDE.md**
The project's `CLAUDE.md` stays the project's own. Subagents *do* load it (for genuine project context), so promode keeps its main-agent-only instructions out of it. Do NOT create, overwrite, or migrate `CLAUDE.md`.

**3. Subagents are self-contained**
Phase agents (implementer, code-reviewer, debugger, …) carry the methodology in their own definitions, so they need nothing installed into the project.

**4. AGENT_ORIENTATION.md holds project knowledge for agents**
Optional, compact, token-efficient project-specific guidance (tools, patterns, gotchas) that agents read just-in-time. Distinct from README.md (for humans). See `references/progressive-disclosure.md`.
</essential_principles>

<never_do>
- NEVER create, overwrite, or modify the project's `CLAUDE.md` — promode coexists with it
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
├── CLAUDE.md                          # the project's OWN — promode never touches it
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
- `references/progressive-disclosure.md` — AGENT_ORIENTATION.md: project knowledge for agents
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
- The project's `CLAUDE.md` (if any) left untouched
- `jq` available on PATH
</success_criteria>
