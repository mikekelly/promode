> Keep this file under 50 lines. This is a plugin repository - see plugins/promode/ for the actual plugin.

## What is Promode?

Promode is a Claude Code plugin that enhances how Claude builds software:

- **Skills** — just-in-time knowledge (e.g. `promode-audit` assesses a repo's alignment + setup; `discovery-to-determinism` for layered acceptance testing)
- **Agents** — phase-specific subagents for hard-to-reverse design, implementation, review, debugging, verification/QA, environment management, product design, and after-action analysis

Core philosophy: TDD is non-negotiable, tests are the documentation, context is precious, discovery hardens into deterministic tests/scripts/maps, and the main agent orchestrates while subagents execute.

**Overriding design goal — optimise for the *current* harness.** Promode's techniques target the latest Claude Code features/behaviour, and silently decay as the harness evolves. Two verification resources: the [community-tracked Claude Code changelog](https://github.com/marckrenn/claude-code-changelog/releases) for what changed release-to-release, and the harness *you are running in* (when you're a Claude Code agent working on this repo) — probe it live to verify undocumented behaviour and edge cases (how SendMessage steer/resume and hook chunking were pinned down) before building a technique on an assumption.

### How the methodology reaches agents

Promode never puts its methodology in the project's `CLAUDE.md` (that's the hook's job). `CLAUDE.md` is the project's own file **and** the root of the agent-knowledge graph — auto-loaded into every agent, maintained by agents over time (adding links to knowledge docs), created as a minimal file if absent, never clobbered — and possibly hierarchical: subtree `CLAUDE.md` launchpads for local critical rules, with adjacent `AGENTS.md -> CLAUDE.md` symlinks for harness compatibility.

- **Main agent** — gets the full promode brief (`PROMODE_MAIN_AGENT.md`: principles + orchestration) delivered **only** to it, via a `SessionStart` hook gated on `agent_id`. So "delegate everything, never do the work yourself" never leaks into subagents that exist to do the work.
- **Subagents** — carry the methodology in their own definitions (`plugins/promode/agents/*.md`); they need nothing from `CLAUDE.md`.

**Placing anything new — decide its altitude first.** Split a new addition into the *decision* (whether/when to engage it → the main-agent brief + routing) and the *mechanics* (the how — format, steps, code → a skill or subagent def, reached by dispatch). Most capabilities span both: decision up, mechanics down. Calibrate against what's already there — e.g. `<test-strategy>` carries the *decision* to run the below-UI feedback loop while `discovery-to-determinism` carries its mechanics (the visual loop mirrors this: a `<test-strategy>` pointer → the `design-system-lookbook` skill).

**Authoring register — opinions, not tutorials.** Altitude decides *where* a capability lives; register decides what earns words once it lands in an agent def or the brief: never tell an agent *how* to do what its pinned tier already knows how to do — instill promode's specific opinions — product design, software design, architecture, methodology — and house doctrine the model can't derive, each with its why. Calibrate scaffolding to the pinned model: a weaker pin earns more operational detail; over-prescription degrades stronger models. Full convention: [`agent-knowledge-wiki.md` → Authoring agent definitions](plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md).

**Every clause serves the register.** Each clause in an agent def or the brief must be in service of an item in the README's opinion register (currently "The opinions"). A clause serving no item is a red flag with a two-way fix — cut the clause, or the register earns a new item — the feature↔goal traceability discipline applied to promode's own defs. Not deterministically enforced: agents follow it while authoring, and fix violations they encounter.

**Design constraints for the brief (load-bearing):**
- **Decisions, not mechanics.** The brief carries orchestration *decisions*; execution mechanics and methodology detail live in the subagent definitions and skills — reached by *dispatch* (which is acted on), not a pointer (which may not be read).
- **Stay under the 10k cap.** Every hook output string (`additionalContext`, `systemMessage`, stdout) must be < 10,000 chars, or Claude Code silently truncates it to a preview + file path and drops the tail. If a principle-complete brief exceeds the cap, split it across multiple SessionStart outputs at *section boundaries* (self-contained, so the parallel/unordered merge can't garble them) — never demote a principle to a pointer to fit.
- **Brief isolation + full chunk registration.** The brief must reach the MAIN agent only (the hook withholds it whenever stdin carries an `agent_id`), and every `<!-- CHUNK -->`-delimited part must be registered in `hooks.json` (chunks `1..N`, N = markers+1, in each matcher) or the tail is silently dropped while the size check still passes.
- **One CI-gated runner enforces all three.** `scripts/check-hooks.sh` runs them (`scripts/check-hook-{output-limits,agent-gating,chunk-registration}.sh`) as part of the repo's full invariant-check suite; keep it green — it's wired into CI (`.github/workflows/hook-output-limits.yml`).

Why a hook, and why the brief never goes in `CLAUDE.md`: see `plugins/promode/skills/promode-audit/references/main-agent-delivery.md`.

Subagent definitions live in `plugins/promode/agents/`; skills (just-in-time knowledge) in `plugins/promode/skills/`. The canonical agent routing is the brief's `<delegation-map>` (and README's table for humans). Brainstorming, plan reviews, and final architectural calls stay with the main agent; crucial hard-to-reverse design may be *drafted* by `chief-technology-officer` (frontier-pinned) for the main agent to ratify.

How this knowledge graph works — the discipline this `CLAUDE.md` itself follows: [`agent-knowledge-wiki.md`](plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md).
Concepts considered and **rejected** — check before proposing methodology ideas, don't re-suggest: [`docs/decisions/`](docs/decisions/2026-07-community-skills-rejections.md).

### Where the brief + hook live; keeping principles in sync

The plugin ships its own `SessionStart` delivery — nothing is copied into a project: `plugins/promode/hooks/` (`hooks.json` + `promode-main-context.sh`) injects the brief from `plugins/promode/PROMODE_MAIN_AGENT.md`, read via `${CLAUDE_PLUGIN_ROOT}`, so a plugin update delivers the new brief automatically (`promode-audit` flags stale leftovers from the retired per-project copy-install).

Principles are deliberately duplicated — the inline copy is load-bearing in each home, and the rationale travels with the rule (never dedupe the *why* out of a copy): a shared principle lives in the brief (main agent) **and** every relevant agent definition (subagents), some blocks in several defs at once. When you change one, sync **all** its homes — runbook: [`sync-a-shared-principle.md`](runbooks/sync-a-shared-principle.md).

### Runbooks

Repeatable operational procedures (release/version bump, adding a subagent, syncing a principle, verifying hook delivery) are captured as runbooks — see [`RUNBOOKS.md`](RUNBOOKS.md).
