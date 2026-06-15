# Ideas backlog

Raw, not-yet-spec'd ideas for promode.

---

## Durable in-repo working state (task docs + worktree parallelism + in-repo memory)

*Added 2026-06-15. Source: HQ assistant practice-scan corpus (`~/code/hq/outputs/assistant-practice-scans/`, esp. 06-13 #4 `/goal`+`./tasks` file-state machine, 06-13 #1 Active-State-Index handoff buckets, 06-15 spec→plan→tasks pipeline) + a design conversation with Mike. Not yet spec'd — this is the intake card; run it through promode's own methodology (clarify outcomes → plan → TDD) before adopting.*

**Theme.** One coherent upgrade with three mutually-reinforcing parts: make promode's *plan/execution state* and its *memory* **durable, in-repo, and agent-readable**, treating ephemeral or out-of-repo state as the thing to eliminate. A parallel task then gets a task doc **and** its own worktree from current HEAD, and its outcome lands back in the repo graph as durable memory. Aligns with promode's founding bet (the durable asset is the repo) and with `<after-action-review>`'s existing "write learnings to the doc graph" instinct.

### Part A — Plan/task state as durable markdown docs; Kanban becomes a flow-tracker

**The gap.** The main agent currently writes the plan + per-task brief **straight into the subagent prompt** (plus plan-mode + the transcript) — all ephemeral. `<project-tracking>`'s `KANBAN_BOARD.md` tracks coarse *status* (title + column), and `<planning>` says large features need "outcome/plan docs and a task tree", but nothing makes the *granular decomposition + per-task brief + execution outcome* a persisted, agent-readable artifact. So the reasoning and results evaporate.

**The idea.** Promote the task tree to a real file-state machine — e.g. `tasks/<id>.md`, one doc per task — carrying the brief (reuse `<prompting-subagents>`: orient/specify/why/verified-vs-assumed), acceptance criteria, and on completion the **outcome + decisions made**. `KANBAN_BOARD.md` keeps only the **flow** view (one-line cards linking to their task docs, in `## Ready`/`## Doing`/done) — i.e. how a real Kanban board is meant to be used: board = flow at a glance, ticket = detail. Subagents **read and update their task doc** rather than the brief living only in the prompt. Benefits: durable KB history (why work was structured this way + what each task concluded), cheap fresh-session handoff (read task docs, don't reconstruct from transcripts), and it *serves* context-preciousness (plan state lives on disk; the main agent's window stays lean).

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
- Treat that dir as a **raw capture buffer**. `<after-action-review>` (and a `consolidate-memory`-style pass) **promotes** the good entries into the proper doc graph — subtree `CLAUDE.md`, decision nodes, runbooks — with provenance, and **prunes** the rest. Deliberate, traceable, reviewable knowledge beats auto-formed blobs, but the auto-capture gives a safety net so nothing is lost between AARs.

**Altitude split:** *Decision* — a line in `<after-action-review>` / principles: project memory is in-repo; auto-store is a capture buffer, promote+prune each AAR. *Mechanics* — the settings block (README/recommended config) + a promotion/pruning skill (extend or pair with `consolidate-memory`). *Open question:* the auto-store is shared across a repo's worktrees — confirm that's benign (likely fine: one shared memory dir) and decide whether promoted docs live at repo root vs subtree.

**Effort/value.** All three are medium effort, high value, and reinforce each other; Part A is the keystone. Verify Part B's dirty-tree caveat with a live CC worktree test if we ever need dirty-tree fan-out (otherwise commit-then-fan-out sidesteps it). Report-only until run through promode's methodology.
