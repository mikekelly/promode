> Keep this file under 50 lines. This is a plugin repository - see plugins/promode/ for the actual plugin.

## What is Promode?

Promode is a Claude Code plugin that enhances how Claude builds software:

- **Skills** — just-in-time knowledge (`managing-promode` sets up promode in a project)
- **Agents** — phase-specific subagents for research, implementation, review, debugging, testing, QA, environment, product design

Core philosophy: TDD is non-negotiable, tests are the documentation, context is precious, and the main agent orchestrates while subagents execute.

### How the methodology reaches agents

Promode stays **out of the project's `CLAUDE.md`** — that file remains the project's own (conventions, build notes), loaded normally by the main agent and subagents alike.

- **Main agent** — gets the full promode brief (`PROMODE_MAIN_AGENT.md`: principles + orchestration) delivered **only** to it, via a `SessionStart` hook gated on `agent_id`. So "delegate everything, never do the work yourself" never leaks into subagents that exist to do the work.
- **Subagents** — carry the methodology in their own definitions (`plugins/promode/agents/*.md`); they need nothing from `CLAUDE.md`.

Why a hook, and why promode doesn't touch `CLAUDE.md`: see `plugins/promode/skills/managing-promode/references/main-agent-delivery.md`.

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

### Standard files & keeping them in sync

The `managing-promode` skill installs these into a target project (templates live in `skills/managing-promode/standard/`) — and never touches the project's `CLAUDE.md`:
- `standard/PROMODE_MAIN_AGENT.md` → `.claude/PROMODE_MAIN_AGENT.md` (main-only, hook-delivered)
- `standard/hooks/promode-main-context.sh` + a `SessionStart` entry in `.claude/settings.json`

Principles live in two places by design (the cost of keeping promode out of `CLAUDE.md`): update them in `standard/PROMODE_MAIN_AGENT.md` (main agent) and the relevant phase-agent definitions (subagents).
