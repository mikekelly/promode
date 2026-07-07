# Promode

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin designed to make efficient use of Fable on usage credits. Promode uses Fable to grow high quality codebases fast whilst keeping costs down.

Promode makes Claude Code opinionated — via a framework you can customise to your development tastes — so it operates *your* way, and proactively pushes you, itself, and its subagents to follow your methodology, so you never have to think about it, let alone enforce it. Describe an outcome, and Claude Code starts working towards it under your rules.

Promode is designed for Fable and its costly inference: very high quality reasoning, relatively expensive compared to Opus and Sonnet. So Promode prescribes Fable for the judgement-dense work — brainstorming, planning, designing, reviewing — while more cost-effective models take the context-intensive implementation that gets delegated to subagents. Frontier tokens are spent only where whole-picture judgement concentrates; the context-heavy grinding happens on cheaper tiers, in fresh contexts.

It's a handful of agent definitions, a couple of slash commands, and one hook. No services, no MCP servers, no lock-in — you can read every prompt it ships. And it's built to be forked: methodology is taste, and this repo is the mikekelly fork — install it as-is if that taste fits, or [fork it](#fork-it) and make it yours.

## Install

```
/plugin marketplace add mikekelly/promode
/plugin install promode
```

Then `/reload-plugins` (or restart Claude Code), and `/promode-audit` to get started — it assesses the project against the methodology and returns a prioritised plan to bring it in line. promode ships its own `SessionStart` hook, so the main-agent brief is delivered automatically in every session where the plugin is enabled (gated to the main agent only); nothing is copied into your project, and updating the plugin updates the brief.

### Optional: Codex as a peer engineer

If you use OpenAI's Codex CLI (install it first), add the official Codex plugin:

```
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/codex:setup
```

With it installed, promode's main agent treats Codex (`/codex:rescue --background`) as a peer senior engineer — on par with the Opus tier, from a different perspective, a peer rather than a reviewer. For high-stakes decisions it tasks Opus and Codex on the same problem in parallel, without showing either the other's answer, and synthesises the best of both.

## The problem it's built around

A vanilla Claude Code has no opinions. It builds software however the model's defaults lean that day, so every session re-litigates taste and methodology from scratch — how much process, when to test, what counts as done, where knowledge should live. The obvious fix, a library of skills, only half-solves it: a skills library leaves the methodology's orchestration to you. You have to remember which skills to invoke, when, and in what order — session after session, you are the enforcement.

Promode's goal is to end that: make Claude Code operate in an opinionated way that drives projects in the direction of *your* preferences — how the harness's features get used, product and engineering methodology, knowledge and memory management, all of it — with the session's main agent enforcing it itself, unprompted. The main agent is both the orchestrator and the enforcer of those opinions, the same opinions are instilled into every subagent, and they arrive structurally — a hook, agent definitions, deterministic dispatch, an imported register — never as a menu waiting to be picked from ([no skills, by design](#no-skills--by-design)). And because preferences evolve, every opinion is held in one evolvable doc — the [opinion register](plugins/promode/docs/opinion-register.md) — so evolving an opinion there is what drives the change in the prompting and tools that carry it. Your promode becomes a living definition of your opinions on how to most effectively use Claude Code and deliver projects with AI agents — which is exactly why [forking](#fork-it) works: your fork's register, your promode.

Holding opinions over a long session runs into the two things that quietly degrade one:

1. **Context fills up.** The more an agent reads, edits, and logs, the larger its context grows and the worse its reasoning and instruction-following get. A session that starts sharp ends sloppy — and a sloppy agent sheds its opinions first.
2. **The agent does the work itself.** Left to its own devices, a capable model writes code inline, piles detail into the main thread, and loses the high-level thread.

So promode keeps the main agent thin: it holds the opinions, the plan, and the conversation, not the diff. Execution goes to subagents that each start fresh, carry the same opinions in their own definitions, do one thing, and return a few lines — the main context stays small, the expensive reasoning stays clear, and the methodology survives the session.

## How it works

**The main agent orchestrates.** It does only what needs the whole picture: talking with you, pinning down what success looks like, planning, reviewing plans, making architectural calls, and synthesising results. Everything else is delegated.

**Subagents execute.** Each delegation is one agent, one deliverable, fresh context. They run in the background — the main agent dispatches and ends its turn, then gets woken when a result lands. Independent work runs in parallel. Subagents commit their changes before reporting, so what comes back is a summary, not a context-bloating dump.

**Model choice is explicit — three tiers by cognitive load.** This is the intro's cost split made mechanical. The main agent runs on the top frontier model (Fable 5 today; allow Opus where it's unavailable — set it with `/model`) and reserves it for orchestration; execution runs a tier below: `senior-engineer` is pinned to Opus for reasoning-heavy work, `fast-worker` to Sonnet for mechanical work, and hard jobs sent to other agents (multi-system debugging, architectural review) are dispatched on the Opus tier rather than inheriting the orchestrator's model. The one deliberate exception is `chief-technology-officer`, which *inherits the session's top tier* (Fable→Fable, Opus→Opus) — crucial, hard-to-reverse design is the execution work that earns your top reasoning tier, so it runs at whatever tier you're paying for, honouring your chosen ceiling rather than escalating above it.

**Where the methodology lives is deliberate** — this is the part that's easy to get wrong:

- The orchestration brief is delivered to the *main agent only*, via a `SessionStart` hook. It is not written into your `CLAUDE.md`, so "delegate everything, never do the work yourself" never leaks into the subagents whose whole job is to do the work.
- Each subagent carries its own methodology in its own definition, so it's self-contained.
- Your `CLAUDE.md` stays yours. Promode treats it as the root of an agent-maintained knowledge graph — an LLM wiki: every agent reads it to orient, and agents add linked docs as they learn things worth keeping. The graph can be hierarchical: major subsystems may have their own concise `CLAUDE.md` launchpads for local must-obey rules, with adjacent `AGENTS.md -> CLAUDE.md` symlinks recommended for harnesses that load that filename. Promode never overwrites existing orientation; it creates a minimal root only if you don't have one.

### Agents

| Agent | Job |
|---|---|
| `chief-technology-officer` | Crucial, hard-to-reverse design — architecture, entity/domain model, large-refactor strategy, critical product-technical calls; drafts designs and plans the main agent ratifies (inherits the session's top tier) |
| `senior-engineer` | Reasoning-heavy implementation — architecture-adjacent changes, complex/multi-system work, hard-bug fixes, algorithm design; TDD (pinned to Opus) |
| `fast-worker` | Mechanical execution — boilerplate, simple edits, formatting, straightforward tests, browser/GUI driving (pinned to Sonnet) |
| `code-reviewer` | Review the change (doesn't run the suite — that's the implementing agent's job) |
| `debugger` | Find the root cause, reproduce with a test, report (doesn't fix unless asked) |
| `verifier` | Exercise the running app from the outside; PASS/FAIL with evidence |
| `environment-manager` | Docker, services, health checks, scripts |
| `product-design-expert` | Product and UX decisions, grounded in realistic customer profiles/personas |
| `agent-analyzer` | Evidence side of after-action reviews — verify an agent's self-debrief against its transcript, autopsy failed/oversized runs, cluster cross-session patterns |
| `auditor` | Run the promode-alignment audit — fan out parallel assessors (one per dimension), synthesise a prioritised improvement plan for the main agent to ratify |
| `constraint-reinforcer` | Hoist buried design constraints (ADRs, knowledge docs, tribal knowledge) into the nearest loaded `CLAUDE.md` orientation so agents can't miss them |

## The opinions

Promode is opinionated on purpose — and every opinion is tracked. The canonical, complete index is the [opinion register](plugins/promode/docs/opinion-register.md): every opinion the brief and the agent definitions instantiate, each with a stable slug, a one-line statement, and the exact homes that carry it (it's `@`-imported into every agent working on this repo, so the slugs are shared vocabulary) — and it's the surface you edit when you [fork](#fork-it). What follows is the map, not the list — the kinds of opinionatedness promode is built around:

- **TDD is not optional.** No implementation without a failing test first. Tests are the specification; behaviour lives in tests, not in prose.
- **Evidence over assumptions.** Read the code, run it, check the output. State assumptions out loud so they can be challenged.
- **Discovery hardens into determinism.** Agents do the open-ended discovery; worthwhile findings become runnable tests, scripts, maps, recognizers, or state graphs so future agents don't rediscover the same thing.
- **Acceptance coverage is layered.** Most behaviour is exercised fast and headless below the UI through an operator seam; the real GUI is a surgical state-graph tier for defects that only surface there.
- **Stay on task.** An agent fixes what it was sent to fix and flags the rest, rather than wandering into adjacent refactors and bloating the diff.
- **Work traces to a reason.** New work connects, through a hierarchy of docs (goals and risks → feature definitions → tests), up to an actual goal. If it can't, either the work is superfluous or the goals are out of date — and the main agent is told to push back, not to invent a goal to justify the work.
- **Decisions ground in who we build for.** Product and UX decisions trace to a realistic customer profile/persona — grounded in real evidence, never invented or flattered to justify a feature. A feature without a clear persona is a red flag, the same way work without a goal is.
- **User needs are claims, not givens.** The workflows and use cases a feature assumes are claims about real people. Cite the signal that grounds each, or flag it as an assumption with a validation path — never a fabricated citation. This is "build something people want" enforced as engineering risk: a wrong user-need assumption propagates into the domain model and architecture, the most expensive layer to unwind, and an evidence-based user story doubles as the high-level acceptance test.

## Fork it

Promode is intended to be forked and customised. A methodology is mostly taste — how much process, which disciplines are non-negotiable, where judgement sits — and taste differs between people. This repository is the mikekelly fork; installing it as-is means adopting this fork's taste, which is a perfectly good default. Where your taste differs, fork it rather than fight it.

The [opinion register](plugins/promode/docs/opinion-register.md) is the focal point of a fork — the customisation surface. Every opinion has a register row: a stable slug, a one-line statement, and the exact homes (brief sections, agent definitions, commands, routed docs) that carry it. And because every clause in the shipped prompts must serve a register item, there is no hidden opinion to trip over. Changing promode's mind is mechanical, not archaeological:

1. **Change the opinion in the register** — reword it, replace it, or delete the row.
2. **Sync its homes** — the row names every file that carries it; the [sync runbook](runbooks/sync-a-shared-principle.md) walks the multi-home update.
3. **The fork is now coherently yours.** Even removing a whole component — a subagent, a command, a routed mechanics doc — is register-guided: the register's Components section maps which components exist to serve which opinions, so a component whose opinions you reject is deleted deliberately, not discovered later.

## No skills — by design

Promode ships **no skills**. A skill's invocation is voluntary — the model may or may not fire it off a description competing in a listing — and that non-determinism has no place in how a methodology reaches its agents. Every capability lives on a **non-voluntary surface** instead (the full decision, with the rejected alternatives: [`docs/decisions/2026-07-skills-elimination.md`](docs/decisions/2026-07-skills-elimination.md)):

- **Dedicated agents** — big just-in-time mechanics that are one agent's whole job, reached by deterministic delegation-map dispatch: `auditor` and `constraint-reinforcer` (see the agents table above). Same context economics as a skill — the definition loads only when dispatched.
- **Slash commands** (`plugins/promode/commands/`) — user-typed flows: `/promode:handoff` writes the handoff doc a fresh session resumes from after a `/clear` or `/compact` (the main agent also fires it proactively — that decision is in its brief, not left to listing luck); `/promode:promode-audit` dispatches the auditor.
- **Routed mechanics docs** (`plugins/promode/docs/`) — cross-cutting knowledge several agents need occasionally: `discovery-to-determinism.md` (layered acceptance testing below the UI, crystallising discovery into deterministic code) and `design-system-lookbook.md` (the visual analogue: design source-of-truth + lookbook + live-refresh preview). Each consuming agent definition carries a conditional "when the dispatch is X, first read …" — an in-system-prompt imperative instead of a listing gamble.
- **Everything else is guaranteed-loaded** — in the hook-delivered brief (e.g. the task-docs plan-persistence mechanics) or baked into the agent definitions.

## Recommended settings

Optional, but they unlock two promode behaviours. Add to your project `.claude/settings.json` (settings take effect after you accept the workspace-trust prompt — relevant for unattended runs):

```jsonc
{
  // Parallel worktree isolation that includes your in-progress branch.
  // Default worktrees fork from the repo's DEFAULT branch (origin/HEAD) — a stale
  // tree missing your work. "head" forks from your current branch HEAD (committed
  // work included), making independent parallel subagents safe. Commit before you
  // fan out; worktrees prevent live collisions, not semantic merge conflicts.
  "worktree": { "baseRef": "head" },

  // Keep project memory IN the repo (versioned, synced) instead of the out-of-repo
  // default (~/.claude/projects/<project>/memory/). Treat this dir as a capture
  // BUFFER — promode promotes worthwhile entries into the CLAUDE.md knowledge graph
  // and prunes the rest during after-action review. Commit it; do NOT gitignore it.
  "autoMemoryEnabled": true,
  "autoMemoryDirectory": "./.promode/memory"
}
```

(Verified against Claude Code 2.1.x: these keys exist; `worktree.baseRef: "head"` carries your branch's committed/unpushed commits into the worktree — not uncommitted edits, so commit first.)

## Requirements

- Claude Code (a vanilla install is fine)
- `git` — subagents commit their work
- `jq` — used by the hook
