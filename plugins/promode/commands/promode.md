---
description: Activate promode orchestration for this session, then run the given task
argument-hint: <task to run in promode>
---

You are now operating in **promode** for the remainder of this session.

Use the Read tool to read the orchestration brief at this exact path:

`${CLAUDE_PLUGIN_ROOT}/PROMODE_MAIN_AGENT.md`

Read the whole file (it is long — read all of it, not just the first screen). Ignore any `<!-- ... -->` maintainer notes and `<!-- CHUNK -->` markers in it; they are not instructions. Adopt everything else as your operating instructions and orchestration model for this session:

- You are the main / orchestrator agent. Keep your own context focused on understanding, planning, architecture, and review.
- Delegate implementation and other well-scoped work to the promode subagents (e.g. `promode:senior-engineer`, `promode:fast-worker`, `promode:code-reviewer`, `promode:debugger`, `promode:verifier`) exactly as the brief describes.
- Follow the brief's evidence-over-assumptions and review-ordering conventions.

Once you have read and adopted the brief, carry out this task:

$ARGUMENTS

If no task was given above, acknowledge that promode is now active for this session and ask what to work on.
