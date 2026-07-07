---
name: promode-audit
description: "Audit how well a repository's codebase and practices align with the promode methodology, then produce a prioritised, actionable improvement plan. Runs via the promode:auditor agent, which fans out parallel assessors (one per dimension) and synthesises their findings. Use when the user wants to assess promode alignment/fit, audit a repo against the methodology, or get a plan to bring a codebase in line with promode."
argument-hint: "[optional focus: an area, dimension, or repo path]"
---

Run the promode methodology audit by dispatching the **`promode:auditor`** agent (via the Agent tool) — do not run the audit yourself. Brief it with the target repo (default: the current one) and any focus the user gave: $ARGUMENTS

The auditor fans out per-dimension assessors, synthesises their findings, and returns a full report with a prioritised action plan. When it reports back: ratify (or challenge) its prioritisation, deliver the report to the user, and offer to capture the plan as tracked work (e.g. `KANBAN_BOARD.md` / `IDEAS.md`) or a saved report file.
