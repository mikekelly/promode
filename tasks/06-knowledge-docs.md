# Knowledge doctrine: glossary + rejected-work conventions, task-doc fog/durability, decision node

## Brief
- **Orient** — `plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md` (the knowledge-graph doctrine; has an Authoring-skills section), `plugins/promode/skills/task-docs/SKILL.md`, repo root `CLAUDE.md` (**hard cap 50 lines — currently 46**), `IDEAS.md`, `DONE.md`.
- **Specify** — committed edits across those files:

  **agent-knowledge-wiki.md — three new conventions:**
  1. **Domain glossary node** — a first-class node type: canonical domain terms, each defined by what it IS (not what it does), with `_Avoid_:` anti-synonym lists; updated **inline the moment a term resolves** (never batched); agents actively challenge vocabulary drift ("the glossary defines *cancellation* as X — you seem to mean Y; which is it?"); large repos may split glossaries per subtree. Why it pays: shared language is token economy, and since tests are the documentation, test names in canonical vocabulary make the documentation coherent.
  2. **Rejected-work KB** — rejections recorded one node per **concept** (not per request), matched by concept similarity ("night theme" matches a dark-mode node); reasons must be durable (never "no time right now"); **never** file an already-implemented request as rejected ("recording it would poison the dedup checks with false rejections"). Purpose: ideation and reviews must not re-suggest rejected concepts.
  3. **Authoring additions** (in the Authoring-skills section): **leading words** — one word already in the model's pretraining (*fog of war*, *tracer bullets*, *tight*) recruits priors a paragraph can't buy; when a behavior under-fires, strengthen the word, not the sentence count. And **examples document the problem, not the solution** — a solution example ("so we keyed it on FRONT_ARC") rots; a problem example teaches.

  **task-docs/SKILL.md — two additions:**
  4. **Fog discipline** — plan tasks only to the fog edge; the fog is carried as *named unknowns*, never pre-sliced into fake tasks; fog test: "you can state the question precisely now — *not* answer it."
  5. **Durability rule** — a dispatch brief consumed immediately may cite file paths; a task doc that may sit in Ready describes **behavioral contracts and interfaces** instead — paths rot, contracts don't.

  **New decision node — "considered and rejected" from the 2026-07 community-skills evaluation** (dzhng/skills + mattpocock/skills), one node capturing four rejections with their why:
  - *Smart-zone / deliberate session-ending* — conflicts with the brief's "remedy for context pressure is always delegation"; the orchestrator-plus-fresh-subagents architecture is the structural fix the doctrine patches around.
  - *Refactoring outside the TDD loop* — the two authors disagree with each other (no convergence signal); promode keeps RED→GREEN→REFACTOR.
  - *Issue-tracker-as-durable-memory* — competes with task docs + board (one home per fact).
  - *"Prompt the positive" as a ban on prohibitions* — adopted only as an authoring lens; promode's audited best passages are load-bearing prohibitions with rationale.
  Place it per the wiki's own conventions (a linked doc, e.g. `docs/decisions/…`), reachable from the root `CLAUDE.md` graph. **CLAUDE.md is at 46/50 lines** — if adding a link would breach the cap, link from an existing loaded node instead and say so in the Outcome.

  **IDEAS.md — one new bullet:** an inbound-triage skill (mattpocock's triage state machine: canonical label roles, PR-as-issue triage, agent briefs, out-of-scope KB) — source: https://github.com/mattpocock/skills — parked, not yet spec'd.
- **Why** — methodology adoptions ratified by the maintainer 2026-07-06; the rejections node applies the adopted "don't re-suggest it" rule to this very evaluation.
- **Verified vs assumed** — file locations verified; the wiki's internal section names assumed — read before editing.
- **Not / exit** — do NOT touch the brief or agent defs (other tasks own them; the brief's glossary/prototype hooks land there). CLAUDE.md stays ≤ 50 lines. Exit: committed in your worktree, Outcome recorded below.

## State (Active-State Index)
- **Unresolved errors** — none
- **Open constraints** — 50-line CLAUDE.md cap; one idea one home (new conventions live in the wiki, referenced elsewhere)
- **Established facts** — adoption decisions above
- **Pending goals / next step** — execute, commit, record Outcome

## Outcome
- **Done** — commit `fd10737` on branch `worktree-agent-a08d0544895abb2f3` (agent worktree; not pushed, no version bump).
- **Wiki** (`plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md`): two new node-type sections after Runbooks — "Domain glossary — a node for canonical vocabulary" and "Rejected work — a node type ideation must check" — plus two new bullets in Authoring skills (leading words; examples document the problem, not the solution), placed above "Fix a misfiring skill at the faulty step".
- **task-docs skill**: two new blocks after `<doc-shape>` — `<fog-of-war>` (plan to the fog edge; named unknowns; fog test = state the question, don't answer it) and `<durability>` (Ready-queue docs describe behavioural contracts/interfaces, not paths).
- **Decision node placement**: `docs/decisions/2026-07-community-skills-rejections.md` — one node, four rejections with durable reasons, opening line marks it as a rejected-work node per the wiki conventions. Linked twice: (1) root `CLAUDE.md`, one new line under the knowledge-graph line ("Concepts considered and rejected — check before proposing methodology ideas") → **47/50 lines, cap held**, no fallback link needed; (2) `IDEAS.md` intro sentence guards the point of ideation ("match by concept, don't re-suggest").
- **IDEAS.md**: inbound-triage-skill bullet added (mattpocock state machine, parked).
- **Key decision**: linked the node from *both* root CLAUDE.md (graph reachability, budget allowed it) and IDEAS.md (the rejected-work KB's actual consumer per its own new convention) — link generously, one home.
- **Verified**: `scripts/check-hooks.sh` + `check-skill-frontmatter.sh` green; relative link targets resolve. Task doc found accurate — no stale claims (wiki section names and 46-line count both matched). Outcome recorded here in the worktree copy: writes to the shared-checkout task-doc path were blocked by worktree isolation, so it reaches the canonical doc on merge.
