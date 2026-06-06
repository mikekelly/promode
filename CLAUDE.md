> Keep this file under 50 lines. This is a plugin repository - see plugins/promode/ for the actual plugin.

## What is Promode?

Promode is a Claude Code plugin that enhances how Claude builds software:

- **Skills** — just-in-time knowledge (e.g. `promode-audit` assesses a repo's alignment + setup; `discovery-to-determinism` for layered acceptance testing)
- **Agents** — phase-specific subagents for research, implementation, review, debugging, testing, QA, environment, product design

Core philosophy: TDD is non-negotiable, tests are the documentation, context is precious, discovery hardens into deterministic tests/scripts/maps, and the main agent orchestrates while subagents execute.

### How the methodology reaches agents

Promode never puts its methodology in the project's `CLAUDE.md` (that's the hook's job). `CLAUDE.md` is the project's own file **and** the root of the agent-knowledge graph — auto-loaded into every agent, maintained by agents over time (adding links to knowledge docs), created as a minimal file if absent, never clobbered.

- **Main agent** — gets the full promode brief (`PROMODE_MAIN_AGENT.md`: principles + orchestration) delivered **only** to it, via a `SessionStart` hook gated on `agent_id`. So "delegate everything, never do the work yourself" never leaks into subagents that exist to do the work.
- **Subagents** — carry the methodology in their own definitions (`plugins/promode/agents/*.md`); they need nothing from `CLAUDE.md`.

**Design constraints for the brief (load-bearing):**
- **Decisions, not mechanics.** The brief carries orchestration *decisions*; execution mechanics and methodology detail live in the subagent definitions and skills — reached by *dispatch* (which is acted on), not a pointer (which may not be read).
- **Stay under the 10k cap.** Every hook output string (`additionalContext`, `systemMessage`, stdout) must be < 10,000 chars, or Claude Code silently truncates it to a preview + file path and drops the tail. `scripts/check-hook-output-limits.sh` enforces this — keep it green (wire into CI). If a principle-complete brief exceeds the cap, split it across multiple SessionStart outputs at *section boundaries* (self-contained, so the parallel/unordered merge can't garble them) — never demote a principle to a pointer to fit.

Why a hook, and why the brief never goes in `CLAUDE.md`: see `plugins/promode/skills/promode-audit/references/main-agent-delivery.md`.

| Agent | Purpose | Model |
|-------|---------|-------|
| `promode:implementer` | TDD workflow, write code (and tests) | sonnet |
| `promode:code-reviewer` | Review the code & solution (doesn't run the suite) | sonnet/opus |
| `promode:debugger` | Root cause analysis, reproduce with test (does NOT fix unless asked) | sonnet/opus |
| `promode:verifier` | Exercise the running app via the `/verify` skill; report PASS/FAIL | sonnet |
| `promode:environment-manager` | Docker, services, health checks, env scripts | sonnet |
| `promode:product-design-expert` | Product decisions: UX, psychology, growth | sonnet |
| `promode:agent-analyzer` | Analyze agent output files | sonnet |

Brainstorming, planning, and architectural decisions stay with the main agent (the latest Opus on high effort) — never delegated. Use `Explore` for codebase research and `/deep-research` for web research.

### Where the brief + hook live; keeping principles in sync

The plugin ships its own `SessionStart` delivery — nothing is copied into a project:
- `plugins/promode/hooks/` — `hooks.json` + `promode-main-context.sh` inject the brief (main-agent-only, gated on `agent_id`), reading it from the plugin via `${CLAUDE_PLUGIN_ROOT}`, so a plugin update delivers the new brief automatically.
- `plugins/promode/PROMODE_MAIN_AGENT.md` — the brief the hook reads.

(There's no per-project install — enabling the plugin delivers the brief; `promode-audit` flags any stale leftovers from the retired copy-install.) Principles live in two places by design: when you change a shared principle, update **both** the brief (main agent) and the relevant phase-agent definitions (subagents).
