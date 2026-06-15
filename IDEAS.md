# Ideas backlog

Raw, not-yet-spec'd ideas for promode.

---

## Durable in-repo working state (task docs + worktree parallelism + in-repo memory)

*Added 2026-06-15. Source: HQ assistant practice-scan corpus (`~/code/hq/outputs/assistant-practice-scans/`, esp. 06-13 #4 `/goal`+`./tasks` file-state machine, 06-13 #1 Active-State-Index handoff buckets, 06-15 spec→plan→tasks pipeline) + a design conversation with Mike. Not yet spec'd — this is the intake card; run it through promode's own methodology (clarify outcomes → plan → TDD) before adopting.*

**Theme.** One coherent upgrade with four mutually-reinforcing parts: make promode's *plan/execution state* and its *memory* **durable, in-repo, and agent-readable**, treating ephemeral or out-of-repo state as the thing to eliminate. A parallel task then gets a task doc **and** its own worktree from current HEAD, and its outcome lands back in the repo graph as durable memory. **A–C are the substrate** (durable state + memory); **Part D is the flywheel** — a standing retrospective that operates on the substrate (mines the task docs + transcripts, promotes/prunes the memory, proposes skill/brief tweaks). Without the loop the docs/memory just accumulate; with it, the substrate compounds into self-improvement. Aligns with promode's founding bet (the durable asset is the repo) and with `<after-action-review>`'s existing "write learnings to the doc graph" instinct.

### Part A — Plan/task state as durable markdown docs; Kanban becomes a flow-tracker

**The gap.** The main agent currently writes the plan + per-task brief **straight into the subagent prompt** (plus plan-mode + the transcript) — all ephemeral. `<project-tracking>`'s `KANBAN_BOARD.md` tracks coarse *status* (title + column), and `<planning>` says large features need "outcome/plan docs and a task tree", but nothing makes the *granular decomposition + per-task brief + execution outcome* a persisted, agent-readable artifact. So the reasoning and results evaporate.

**The idea.** Promote the task tree to a real file-state machine — e.g. `tasks/<id>.md`, one doc per task — carrying the brief (reuse `<prompting-subagents>`: orient/specify/why/verified-vs-assumed), acceptance criteria, and on completion the **outcome + decisions made**. `KANBAN_BOARD.md` keeps only the **flow** view (one-line cards linking to their task docs, in `## Ready`/`## Doing`/done) — i.e. how a real Kanban board is meant to be used: board = flow at a glance, ticket = detail. Subagents **read and update their task doc** rather than the brief living only in the prompt. Benefits: durable KB history (why work was structured this way + what each task concluded), cheap fresh-session handoff (read task docs, don't reconstruct from transcripts), and it *serves* context-preciousness (plan state lives on disk; the main agent's window stays lean). **Doc content-schema — adopt the Active-State Index four buckets** (06-13 #1): *unresolved errors · open constraints · established facts · pending goals* — the concrete shape a task/handoff doc carries, so resume + handoff read a known structure rather than free prose.

**Anti-drift rules (load-bearing — this is why promode doesn't already do it).** promode's "tests are the documentation, not markdown" exists so markdown can't lie, and the corpus flagged "context files drift — an agent reads a stale one" as a real failure mode.
- Task docs are a **coordination/queue + decision-log** artifact, **not** a duplicate spec of the code. Code + tests stay the source of truth for *what the system does*; task docs are the source of truth for *what work is in flight and why*.
- **Single source of status.** Status lives in exactly one place — the board column (card position). Task docs hold detail + final outcome and do **not** also carry a live `status:` field, or the two drift.
- **Open-loop only.** A doc carries the live task + last outcome, not a full replay; prior state is recoverable from git/files.
- **Decisions-as-constraints, not prose.**

**Altitude split** (per CLAUDE.md's placement rule):
- *Decision* (main-agent brief): `<planning>` — "persist the task tree as docs, don't just inject the plan into the prompt"; `<project-tracking>` — Kanban = flow-only, cards link to task docs; `<prompting-subagents>` — subagent reads+updates its task doc.
- *Mechanics* (skill): the `tasks/<id>.md` shape, the board↔doc link convention, and the anti-drift rules likely belong in a new skill or an extension of `handoff` (which already writes continuation docs and could read task docs to resume).
- *Feeds*: completed task docs → `DONE.md` + `<after-action-review>` decision nodes.

### Part B — Replace the absolute worktree ban with a conditional rule (VERIFIED enabler)

**Current rule** (`<background-delegation>`): *"NEVER `isolation: worktree` — it forks from the default branch, not your working branch, so the agent works on a stale tree missing your in-progress changes."*

**What's changed.** That rationale describes the **default** (`worktree.baseRef: "fresh"`). The base is now configurable. **Verified on the installed Claude Code (v2.1.159, 2026-06-15):**
- The setting keys exist in the binary: `worktree.baseRef`, `autoMemoryDirectory`, `autoMemoryEnabled`, `CLAUDE_CODE_DISABLE_AUTO_MEMORY` (string `"Failed to update worktree.baseRef in user settings"` confirms it's user-settable).
- Git-level semantics, demonstrated empirically: `baseRef: "fresh"` (origin default) misses **both** unpushed commits and dirty edits — the stale tree the ban warns about. `baseRef: "head"` (local HEAD) **includes unpushed commits** but, under plain `git worktree add` semantics, **not dirty/uncommitted working-tree edits**.
- **Caveat to confirm with a live test:** the binary creates worktrees via a custom bundle/commit-tree path (strings `[gitBundle] baseRef commit-tree`, `bundleBaseRef`), so CC's `baseRef:head` *might* snapshot uncommitted edits into a synthetic commit — unresolved by the plain-git test. **Moot in practice:** promode's "commit continuously" discipline means you commit before fanning out, so `head` worktrees capture everything regardless. Confirm only if we want to support fan-out over a dirty tree.

**The idea.** Set `worktree.baseRef: "head"` in promode's recommended settings, then **downgrade the ban to conditional**: *use worktree isolation (with `baseRef: head`) for genuinely independent parallel tasks from a committed baseline; keep sharing the working tree for chained/dependent work.* This finally gives promode a clean **collision-free parallel-mutation** story (today, parallel implementers share one working tree and can stomp each other — the ban leaves promode without a safe parallel-write path).

**Design pieces this needs.**
- Worktrees prevent *live collisions*, not *semantic merge conflicts* — so it suits tasks touching **disjoint** areas, and the new required step is **merge-back/integration** (main agent or a dedicated integrator). One task doc → one worktree → one branch → merge on done (dovetails with Part A).
- Setting changes are gated by the workspace-trust dialog — relevant for unattended/scheduled runs.

**Altitude split:** *Decision* — rewrite the `<background-delegation>` rule (conditional, with the merge-back requirement) + recommend `worktree.baseRef: head` in settings/README. *Mechanics* — a "parallel-isolation + merge-back" runbook or skill section.

### Part C — Project memory as in-repo markdown (option b: capture buffer → promote)

**Stance.** An out-of-repo auto-memory store (`~/.claude/projects/<project>/memory/`, default) is antithetical to promode's bet: invisible knowledge that doesn't version, sync, or get reviewed. promode already routes learnings to the repo doc-graph via `<after-action-review>`. So: **project memory lives in the repo.**

**Chosen mechanism (b) — capture buffer that gets promoted (mirrors HQ's `inbox/ → notes/`).**
- Redirect the auto-store **into the repo and commit it** (do **not** gitignore — that would defeat versioning): `"autoMemoryDirectory": "<repo>/.promode-memory"` (or similar), `"autoMemoryEnabled": true`. Keys verified present in v2.1.159.
- Treat that dir as a **raw capture buffer**. `<after-action-review>` (and a `consolidate-memory`-style pass — see Part D) **promotes** the good entries into the proper doc graph — subtree `CLAUDE.md`, decision nodes, runbooks — with provenance, and **prunes** the rest. Deliberate, traceable, reviewable knowledge beats auto-formed blobs, but the auto-capture gives a safety net so nothing is lost between AARs.
- **Validity discipline (keeps the durable layer from rotting):** promoted memory + decision nodes use **bi-temporal supersession** — *supersede, don't silently overwrite*: mark a fact superseded with a pointer to what replaced it (git carries the full chain), and preserve the **decision log** (*why option X was rejected*, not just the current choice — the "memory-as-verb" trace summarisation smooths away). Source: Engram (06-11 #3) + the memory-validity cluster (06-10/06-11).

**Altitude split:** *Decision* — a line in `<after-action-review>` / principles: project memory is in-repo; auto-store is a capture buffer, promote+prune each AAR. *Mechanics* — the settings block (README/recommended config) + a promotion/pruning skill (extend or pair with `consolidate-memory`). *Open question:* the auto-store is shared across a repo's worktrees — confirm that's benign (likely fine: one shared memory dir) and decide whether promoted docs live at repo root vs subtree.

### Part D — A standing cross-session retrospective (the flywheel that operates on A–C)

**The strongest, most-recurring finding in the whole scan corpus** (06-14 #1 Proser session-review→skills weekly loop; 4wk Lovable stuck→unstuck + A/B holdout; 06-12 Tokyo "dreaming"; 06-15 omarsar0 session-mining). promode's `<after-action-review>` is excellent but fires **once per task** — nothing runs a *standing pass over accumulated state*. Part D is that pass, and it's what turns A–C from an accumulating pile into a self-improving loop.

- **What it does.** A scheduled/standing agent pass — built on `agent-analyzer` (already inspects JSONL transcripts) — over accumulated **session transcripts + Part-A task docs + the Part-C capture buffer** to: (i) **promote** durable knowledge into the doc graph and **prune** the buffer (the consolidate step Part C defers to); (ii) surface **cross-session recurring** struggles / token-sinks → reviewable skill / brief / agent-def proposals.
- **Sharpeners from the corpus.** Use the **stuck→unstuck transition** as the high-signal *filter* for which sessions are worth mining (Lovable); use **A/B holdout** to test whether an existing skill section still earns its keep before retaining it (one bad skill dropped accuracy 97%→77% in Lovable's data).
- **Guardrail.** Report-only / human-in-the-loop — proposals, never silent self-rewrites (promode's existing discipline; the NOMA negative result, 06-11, is the evidence base for keeping the human in the loop of a self-update system).
- **Altitude split:** *Decision* — a line in `<after-action-review>` extending it from per-task to a *standing cross-session* cadence + scope. *Mechanics* — a new scheduled routine driven by `agent-analyzer` + a consolidate/promote-prune skill (pairs with `consolidate-memory`). Mirrors HQ's own external practice-scan, pointed inward at promode's own transcripts.

**Effort/value.** All four are medium effort, high value, and reinforce each other: **A+C are the substrate, D is the flywheel** (without it, the docs/memory just accumulate), and **B** unlocks safe collision-free parallelism over that substrate. **Part A is the keystone; Part D is the highest-leverage compounding win.** Verify Part B's dirty-tree caveat with a live CC worktree test if we ever need dirty-tree fan-out (otherwise commit-then-fan-out sidesteps it). Report-only until run through promode's methodology.

### Separate workstreams (deliberately *not* folded into this card)

These scan findings are strong but on different axes — own cards when picked up, to keep this theme clean: **verify process & side-effects** (tool-call assertions, out-of-band side-effect checks, "what I did NOT verify" receipt → `verifier`/`<test-strategy>`); **capability-tier rubric + schema-validated subagent returns** (`<delegation-map>`/`<prompting-subagents>`); **LLM-judge discipline** (rubric-per-dimension, pairwise, multi-judge, consensus-audit → `code-reviewer`/`promode-audit`); **skill authoring: landmines-not-docs + inline-exact-conventions** (downstream of Part D, which emits the proposals); **KISS constraint-ladder** (`implementer`); **Rule-of-Two security self-check** (note it in Part B, since more autonomous parallel runs raise the autonomy surface).
