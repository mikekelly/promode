# Research: can promode cut the per-session skill-description tax? (report-only)

## Brief
- **Orient** — promode ships 7 skills; their frontmatter descriptions (~985 tokens total) load into **every** session's skill list. The mattpocock/skills repo uses a `disable-model-invocation: true` skill frontmatter key so user-invoked skills cost zero context. Promode's own new design goal (root `CLAUDE.md`): optimise for the *current* Claude Code harness, verified via the community changelog and the live harness itself.
- **Specify** — a report (no file changes) answering:
  1. **Does current Claude Code support suppressing a skill's description/model-invocation via frontmatter?** Exact key name + semantics + version introduced. Sources in order: the community-tracked changelog (https://github.com/marckrenn/claude-code-changelog/releases), official docs (https://code.claude.com/docs), and **the live harness** — you are running in it; probe empirically where documentation is silent (e.g. create a scratch skill in a temp/scratchpad directory with the candidate frontmatter and observe whether it's listed/invocable — do NOT modify the promode plugin or any project files).
  2. **Which of promode's 7 skills qualify as user/main-agent-triggered-only?** Assess each: `handoff`, `promode-audit`, `task-docs`, `recovering-subagents`, `discovery-to-determinism`, `design-system-lookbook`, `reinforce-design-constraints`. Caution: several are *model*-invoked by the main agent mid-work (task-docs at planning time, recovering-subagents on failures) — suppressing those would break dispatch. Only skills invoked exclusively by an explicit user request qualify.
  3. **Estimated per-session token savings** for the qualifying set, and any risks (e.g. plugin-skill frontmatter handled differently from project skills; slash-command availability implications).
- **Why** — a signal:noise audit found the description tax is the only always-paid cost in the skills corpus; if the harness supports the lever, it's free savings — but only for skills whose just-in-time triggering we'd never need.
- **Verified vs assumed** — the ~985-token figure is from the 2026-07-06 audit (verified); mattpocock's key name is verified in *his* repo but NOT yet against Claude Code itself — that's the question.
- **Not / exit** — REPORT ONLY: change nothing outside scratch/temp dirs. Exit: findings + a go/no-go recommendation per skill, recorded in the Outcome below and in your final report.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — no file changes; empirical probes in scratch dirs only
- **Established facts** — audit figure; mattpocock usage
- **Pending goals / next step** — research, report, record Outcome

## Outcome
_(filled by the agent on completion)_
