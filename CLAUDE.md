> Keep this file under 50 lines. This is a plugin repository - see plugins/promode/ for the actual plugin.

## What is Promode?

Promode is a Claude Code plugin that enhances how Claude builds software:

- **Skills** — just-in-time knowledge (e.g. `promode-audit` assesses a repo's alignment + setup; `discovery-to-determinism` for layered acceptance testing)
- **Agents** — phase-specific subagents for research, implementation, review, debugging, testing, QA, environment, product design

Core philosophy: TDD is non-negotiable, tests are the documentation, context is precious, discovery hardens into deterministic tests/scripts/maps, and the main agent orchestrates while subagents execute.

### How the methodology reaches agents

Promode never puts its methodology in the project's `CLAUDE.md` (that's the hook's job). `CLAUDE.md` is the project's own file **and** the root of the agent-knowledge graph — auto-loaded into every agent, maintained by agents over time (adding links to knowledge docs), created as a minimal file if absent, never clobbered.
The graph may be hierarchical: major subtrees can have local `CLAUDE.md` launchpads for local critical rules, with adjacent `AGENTS.md -> CLAUDE.md` symlinks recommended for harness compatibility.

- **Main agent** — gets the full promode brief (`PROMODE_MAIN_AGENT.md`: principles + orchestration) delivered **only** to it, via a `SessionStart` hook gated on `agent_id`. So "delegate everything, never do the work yourself" never leaks into subagents that exist to do the work.
- **Subagents** — carry the methodology in their own definitions (`plugins/promode/agents/*.md`); they need nothing from `CLAUDE.md`.

**Placing anything new — decide its altitude first.** Split a new addition into the *decision* (whether/when to engage it → the main-agent brief + routing) and the *mechanics* (the how — format, steps, code → a skill or subagent def, reached by dispatch). Most capabilities span both: decision up, mechanics down. Calibrate against what's already there — e.g. `<test-strategy>` carries the *decision* to run the below-UI feedback loop while `discovery-to-determinism` carries its mechanics (the visual loop mirrors this: a `<test-strategy>` pointer → the `design-system-lookbook` skill).

**Design constraints for the brief (load-bearing):**
- **Decisions, not mechanics.** The brief carries orchestration *decisions*; execution mechanics and methodology detail live in the subagent definitions and skills — reached by *dispatch* (which is acted on), not a pointer (which may not be read).
- **Stay under the 10k cap.** Every hook output string (`additionalContext`, `systemMessage`, stdout) must be < 10,000 chars, or Claude Code silently truncates it to a preview + file path and drops the tail. If a principle-complete brief exceeds the cap, split it across multiple SessionStart outputs at *section boundaries* (self-contained, so the parallel/unordered merge can't garble them) — never demote a principle to a pointer to fit.
- **Brief isolation + full chunk registration.** The brief must reach the MAIN agent only (the hook withholds it whenever stdin carries an `agent_id`), and every `<!-- CHUNK -->`-delimited part must be registered in `hooks.json` (chunks `1..N`, N = markers+1, in each matcher) or the tail is silently dropped while the size check still passes.
- **One CI-gated runner enforces all three.** `scripts/check-hooks.sh` runs the size, gating, and chunk-registration checks (`scripts/check-hook-{output-limits,agent-gating,chunk-registration}.sh`); keep it green — it's wired into CI (`.github/workflows/hook-output-limits.yml`).

Why a hook, and why the brief never goes in `CLAUDE.md`: see `plugins/promode/skills/promode-audit/references/main-agent-delivery.md`.

Subagent definitions live in `plugins/promode/agents/`; skills (just-in-time knowledge) in `plugins/promode/skills/`. The canonical agent routing is the brief's `<delegation-map>` (and README's table for humans). Brainstorming, plan reviews, and final architectural calls stay with the main agent; crucial hard-to-reverse design may be *drafted* by `chief-technology-officer` (frontier-pinned) for the main agent to ratify.

How this knowledge graph works — the discipline this `CLAUDE.md` itself follows: [`agent-knowledge-wiki.md`](plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md).

### Where the brief + hook live; keeping principles in sync

The plugin ships its own `SessionStart` delivery — nothing is copied into a project:
- `plugins/promode/hooks/` — `hooks.json` + `promode-main-context.sh` inject the brief (main-agent-only, gated on `agent_id`), reading it from the plugin via `${CLAUDE_PLUGIN_ROOT}`, so a plugin update delivers the new brief automatically.
- `plugins/promode/PROMODE_MAIN_AGENT.md` — the brief the hook reads.

(There's no per-project install — enabling the plugin delivers the brief; `promode-audit` flags any stale leftovers from the retired copy-install.) Principles live in two places by design: when you change a shared principle, update **both** the brief (main agent) and the relevant phase-agent definitions (subagents).

### Runbooks

Repeatable operational procedures (release/version bump, adding a subagent, syncing a principle, verifying hook delivery) are captured as runbooks — see [`RUNBOOKS.md`](RUNBOOKS.md).
