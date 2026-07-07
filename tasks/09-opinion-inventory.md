# Opinion inventory: the brief + all nine subagent definitions

Extraction date: 2026-07-07. Corpus read in full: `plugins/promode/PROMODE_MAIN_AGENT.md` (all 3 chunks) and all nine `plugins/promode/agents/*.md`. Context read: the ratified authoring register (`plugins/promode/skills/promode-audit/references/agent-knowledge-wiki.md` → "Authoring agent definitions") and `runbooks/sync-a-shared-principle.md`. Skills are out of extraction scope; where an opinion's mechanics live in a skill, the pointer is noted.

**File keys:** B = `PROMODE_MAIN_AGENT.md` · SE = `senior-engineer.md` · FW = `fast-worker.md` · CTO = `chief-technology-officer.md` · CR = `code-reviewer.md` · DBG = `debugger.md` · VER = `verifier.md` · EM = `environment-manager.md` · PDE = `product-design-expert.md` · AA = `agent-analyzer.md`. `B§x` = the brief's `<x>` section; `SE§tdd` = that def's `<test-driven-development>` section, etc.

**Home markers:** `verbatim` (byte-shared or same-sentence family across homes) · `calibrated` (deliberately reworded for the pin or the role) · `decision↑` (the whether/when, main-agent altitude) · `mechanics↓` (the how, subagent/skill altitude).

**Verified facts used below (not assumptions):**
- The `<test-driven-development>` blocks in SE and CTO are **checksum-identical** (sha256 `8562ef13…`, verified with the runbook's awk command); FW's block differs (`0aa97431…`), per the documented calibration in `runbooks/sync-a-shared-principle.md`.
- Designed duplication (brief ↔ defs, per-pin calibration) is house policy (`CLAUDE.md`, sync runbook) and is NOT flagged as a finding; only substantive drift or undocumented divergence is.

---

## Domain: meta (corpus governance)

These govern how the corpus itself is written. Primary homes are partly outside the extraction corpus (wiki, runbooks, repo `CLAUDE.md`); included because the assessment can't be read without them.

### M1 `opinions-not-tutorials`
An agent def never teaches its pinned model how to do what it already knows; it instills promode's opinions and doctrine the model can't derive — scaffolding calibrated to the pin, and doctrine ≠ prescription (def size judged by that distinction, not line count).
- domain: methodology · homes: wiki §Authoring-agent-definitions (canonical, ratified 2026-07-07; outside corpus); manifest across all nine defs (e.g. sparse AA/CTO vs. more-scaffolded FW)
- rationale attached: yes (over-prescription degrades stronger models; v2.26.0 slimming, v2.31.0 CTO expansion cited)
- flags: none · **rec: stay** — freshly ratified; it is the yardstick this inventory measures against

### M2 `principles-live-in-two-homes-by-design`
Main agent gets principles from the hook-delivered brief; subagents carry theirs inline in their defs; a doc link never substitutes for the inline copy.
- domain: methodology · homes: repo `CLAUDE.md` (decision↑); `runbooks/sync-a-shared-principle.md` (mechanics↓); B header comment (verbatim restatement of the why)
- rationale attached: yes (a pointer may not be read; brief isolation keeps "delegate everything" out of workers)
- flags: none · **rec: stay** — load-bearing for the whole delivery architecture

### M3 `rationale-travels-with-the-rule`
Never dedupe the *why* out of any copy of a duplicated principle; a rule stripped of its rationale gets misapplied.
- domain: methodology · homes: sync runbook §Why-two-homes (canonical; maintainer ruling 2026-07-02); auto-memory note; manifest corpus-wide (nearly every entry below carries its why in every home)
- rationale attached: yes (the why is the frame for judgement calls the rule can't anticipate)
- flags: one systematic exception found — see P11 (behavioural-authority is rationale-bare in all five homes) · **rec: stay**

### M4 `principle-complete-brief-never-demote-to-pointer`
The brief must be principle-complete; if it exceeds the 10k hook cap, split at section boundaries — never demote a principle to a pointer to fit.
- domain: orchestration · homes: B header comment (verbatim); repo `CLAUDE.md` §Design-constraints (verbatim); enforced by `scripts/check-hooks.sh`
- rationale attached: yes (silent truncation; pointers may not be read)
- flags: none · **rec: stay** — CI-enforced; exemplary crystallised opinion

---

## Domain: orchestration (brief-resident decisions)

By design these reach the main agent only (brief isolation); agent columns are n/a unless a def carries a mechanics-side counterpart.

### O1 `delegate-by-default`
The main agent is a team lead, not an IC: converse, clarify, plan, review, ratify, synthesise, run AARs — everything else goes to an agent; the remedy for context pressure is always delegation, never stopping early, trimming scope, or suggesting a fresh session.
- domain: orchestration · homes: B§role (decision↑); B§principles "Context is precious" (verbatim bullet)
- rationale attached: yes (reasoning degrades as context grows)
- flags: none · **rec: stay** — the plugin's founding opinion

### O2 `main-agent-ratifies-cto-drafts`
Plan reviews and final architectural calls stay with the main agent (and user); crucial hard-to-reverse design is *drafted* by the CTO agent and ratified above it.
- domain: orchestration · homes: B§role + B§delegation-map (decision↑); CTO§your-role "You draft; … The final call is not yours" (mechanics↓, calibrated)
- rationale attached: yes (frontier tier reserved; human-in-loop on one-way doors)
- flags: none · **rec: stay**

### O3 `workflow-order-with-spike-detours`
Orchestrate roughly: brainstorm → clarify outcomes → anchor in knowledge base → plan → execute → AAR; at any step detour into a spike when a decision needs a *reactable* answer rather than a debated one.
- domain: orchestration · homes: B§workflow (decision↑; the spike detour routes to PDE/SE — see O29)
- rationale attached: partial (each step's why lives in its own section; the ordering itself is asserted)
- flags: none · **rec: stay**

### O4 `fire-and-forget-background-delegation`
Always `run_in_background: true`, end the turn, let the notification wake you; never TaskOutput, never poll the output file, never foreground an agent.
- domain: orchestration · homes: B§background-delegation (decision↑ + mechanics)
- rationale attached: yes (redundant fetches; transcript overflow; foreground kills parallelism/steering)
- flags: none · **rec: stay** — harness-verified behaviour ("both verified live")

### O5 `steer-resume-vs-fresh-spawn`
Resume/steer an existing agent (SendMessage) when the follow-up builds on context it already holds — including planned serial reuse; spawn fresh for uncontaminated perspectives (reviews, verification).
- domain: orchestration · homes: B§background-delegation (verbatim); B§subagent-scoping "One deliverable per dispatch…" + "Reviews and verification always get a fresh spawn" (verbatim restatement)
- rationale attached: yes (orientation + cache economics; fresh eyes are the point of review)
- flags: **redundancy beyond design** — the only opinion stated twice *within* the brief in near-equal depth (both chunks); recent commits have been trimming exactly this class of within-file restatement
- **rec: adjust** — keep both mentions but collapse one to a cross-reference clause; frees brief budget

### O6 `worktree-isolation-conditional`
Worktrees are forbidden for chained/dependent work; with `baseRef: head` they're right for genuinely independent parallel tasks — commit first, one task/worktree/branch, merge back deliberately.
- domain: orchestration · homes: B§background-delegation (decision↑)
- rationale attached: yes (default fork point is stale w.r.t. in-progress work)
- flags: none · **rec: stay** — harness-coupled; re-verify on harness change per CLAUDE.md's design goal

### O7 `transcript-recovery-via-inspector`
Never read a raw transcript/`.output` file whole; inspect compactly via the `recovering-subagents` tooling.
- domain: orchestration · homes: B§background-delegation "Recovery" (decision↑); AA§mechanics (mechanics↓, calibrated: "don't hand-roll queries… gotchas the inspector already encodes"); skill pointer `recovering-subagents`
- rationale attached: yes (context overflow)
- flags: none · **rec: stay**

### O8 `one-dispatch-one-deliverable`
Every delegation states the deliverable (one sentence), the NOT-do, and the exit condition; prefer two tight agents over one broad one.
- domain: orchestration · homes: B§subagent-scoping (decision↑); mirrored in task-doc template (task-docs skill, pointer); the NOT-do is the dispatcher side of P10
- rationale attached: yes (scope too broad if unsayable; drift)
- flags: none · **rec: stay**

### O9 `diagnose-or-fix-never-both`
Diagnosis and fixing are separate dispatches unless trivial.
- domain: orchestration · homes: B§subagent-scoping + B§debugging-snags "scoped to diagnose-and-reproduce" (decision↑); DBG§your-role "Only implement the fix if… explicitly asks" (mechanics↓, calibrated); VER§principles "Verify OR fix, never both" (calibrated)
- rationale attached: partial — DBG/VER homes carry role-level whys; the brief states the rule bare (the why — a fixer marks their own homework / scope drift — is implicit)
- flags: none (explicit-ask override is consistent across homes) · **rec: stay**; optionally attach the one-line why in B§subagent-scoping

### O10 `unprimed-dispatch`
When briefing verifier or reviewer, never state the expected answer or hoped-for confirmation — say what to examine, not what to conclude.
- domain: orchestration · homes: B§subagent-scoping (decision↑, dispatcher side); receiver-side counterpart R3 (CR distrust-the-narration)
- rationale attached: yes (primed eyes pass defects fresh eyes catch)
- flags: coverage gap candidate — VER has no receiver-side defence against a primed brief (CR does); minor, since the brief controls the dispatch
- **rec: stay**; consider a one-line VER counterpart when VER is next touched

### O11 `rule-of-two`
No autonomous run lets one agent hold private data + untrusted input + a consequential external action without a human gate; split or checkpoint.
- domain: orchestration · homes: B§subagent-scoping (decision↑); B§promode-audit (named as audit dimension); audit-skill mechanics (pointer)
- rationale attached: partial (the triad is stated; the threat model behind it is assumed known)
- flags: none — correctly main-agent-only (the main agent shapes delegations) · **rec: stay**

### O12 `lowest-capability-tier`
New capability: primitive → custom tool → subagent → MCP; a heavier tier than the job needs is wasted context and surface.
- domain: orchestration · homes: B§delegation-map (decision↑)
- rationale attached: yes
- flags: superficial tension with O13's "prefer opus" — different axes (mechanism tier vs model tier); see conflicts list
- **rec: stay**

### O13 `three-model-tiers`
Frontier = orchestration + CTO only; opus = deep-reasoning execution; sonnet = mechanical execution. Never inherit the frontier model by accident; when unsure, don't downgrade — prefer opus.
- domain: orchestration · homes: B§model-tiers (decision↑); pinned in each def's `model:` frontmatter (mechanics↓)
- rationale attached: yes (cognitive-load tiers; frontier reserved)
- flags: none · **rec: stay**

### O14 `parallel-peer-answers-for-high-stakes`
For high-stakes decisions, task the deep tier and Codex on the same problem in parallel, never showing either the other's answer, then synthesise; Codex is a peer, not a reviewer.
- domain: orchestration · homes: B§model-tiers (decision↑)
- rationale attached: partial (independence is implied by "never showing either the other's answer"; the anchoring-avoidance why is unstated)
- flags: availability-conditional (gated on `/codex:rescue` present) — correctly worded · **rec: stay**; optionally attach the anchoring why

### O15 `brief-not-tutorial`
Subagent prompts give orient / specify / why / verified-vs-assumed — a brief, not a tutorial, because methodology is baked into the defs.
- domain: orchestration · homes: B§prompting-subagents (decision↑); task-doc template mirrors it (task-docs skill, pointer); M1 is its authoring-side twin
- rationale attached: yes (fresh context; silent assumption inheritance)
- flags: none · **rec: stay**

### O16 `condensation-requires-inventory`
A task that condenses or deletes prose must produce an inventory: each distinct rule the cut text carried, shown surviving in a named home.
- domain: orchestration · homes: B§prompting-subagents (decision↑; single home)
- rationale attached: yes (loss caught by implementer, not reviewer)
- flags: single-home but correctly so (a dispatch-shaping rule) · **rec: stay** — this task is itself an instance

### O17 `typed-returns-for-gather-work`
Gather/structured work (especially on cheaper models) returns through a schema validated at the tool layer, not prose to re-parse.
- domain: orchestration · homes: B§prompting-subagents (decision↑)
- rationale attached: yes (~50%→~99% reliability claim)
- flags: none · **rec: stay**

### O18 `clarify-outcomes-first`
Pin testable acceptance criteria — what and why, never implementation; grill one question at a time in dependency order, offering your recommended answer; questions answerable from the codebase get answered there; skip only for obvious fixes or user opt-out.
- domain: orchestration · homes: B§clarifying-outcomes (decision↑)
- rationale attached: yes (react-not-author; challenge busywork)
- flags: none · **rec: stay**

### O19 `plans-persist-as-task-docs`
Multi-task plans are persisted as one markdown doc per task (brief + state + outcome), the canonical task state; delegating = pointing the agent at its doc; agents record the Outcome before reporting.
- domain: orchestration · homes: B§planning (decision↑); mechanics in task-docs skill (pointer); consumer side in SE/FW/CTO/DBG/VER §reporting "If your brief references a task doc…" (verbatim family, payload calibrated per role)
- rationale attached: yes (plans in context evaporate with the turn)
- flags: **coverage gap** — CR has no record-your-verdict-in-the-task-doc line (its five executing peers all do; a review verdict is exactly canonical task state); EM also lacks it (weaker case — env tasks are less often doc'd); AA lacks it (defensible: AAR evidence feeds the main agent, not a task doc)
- **rec: adjust** — add the task-doc line to CR; decide EM deliberately (add or document n/a)

### O20 `kanban-flow-single-source-of-status`
`KANBAN_BOARD.md` is the flow view (one-line cards), `IDEAS.md` raw ideas, `DONE.md` completed; the column owns status — task docs never carry a competing live `status:` field.
- domain: orchestration · homes: B§project-tracking (decision↑)
- rationale attached: yes (competing status sources)
- flags: none · **rec: stay**

### O21 `frame-plans-as-delegation`
Write plans as "delegate X to Y", never "implement X" — recency bias makes what you read your instruction.
- domain: orchestration · homes: B§planning (decision↑)
- rationale attached: yes (recency bias)
- flags: none · **rec: stay**

### O22 `task-sizing-and-parallelism`
Size each task for one agent (small enough to avoid drift, large enough to avoid overhead); plan upfront before context fills; run independent tasks in parallel with checkpoints between chained ones.
- domain: orchestration · homes: B§planning (decision↑); CTO§your-role constraint 2 mirrors it from the drafting side (calibrated — see A5)
- rationale attached: yes
- flags: none · **rec: stay**

### O23 `slice-by-verifiability`
Every task independently verifiable: one question, one seam, one review surface, one verdict; broad-verb slices aren't tasks yet.
- domain: orchestration · homes: B§planning (decision↑)
- rationale attached: yes (re-slice test given)
- flags: none · **rec: stay**

### O24 `fog-discipline`
Plan only to the fog edge; keep the fog as named unknowns — a precise question you can state now, not answer — never pre-sliced fake tasks.
- domain: orchestration · homes: B§planning (decision↑)
- rationale attached: yes (the fog test)
- flags: none · **rec: stay**

### O25 `reslicing-is-progress`
Adjust the plan the moment the work proves it stale; reslicing is not failure.
- domain: orchestration · homes: B§execution (decision↑)
- rationale attached: implicit (framing is the rationale)
- flags: none · **rec: stay**

### O26 `main-agent-is-tdd-enforcement-point`
Plans without test-first acceptance criteria aren't ready; a report whose diff lacks failing-test-first evidence, or that wandered beyond its brief, gets rework, not acceptance.
- domain: orchestration · homes: B§execution + B§planning "test-first acceptance criteria" (decision↑); enforced downstream by CR (R-cluster) and carried by implementers (P2)
- rationale attached: yes (TDD is the first discipline to slip)
- flags: none · **rec: stay**

### O27 `verification-checkpoints`
Insert a verifier pass where a later-discovered regression would hurt: after a logical unit, before a new area, after integration, before "done"; the verifier reports, the main agent dispatches fixes.
- domain: orchestration · homes: B§execution (decision↑); VER def entire (mechanics↓)
- rationale attached: yes
- flags: none · **rec: stay**

### O28 `assert-the-action-happened`
Verify the expected tool-call/side-effect actually fired — absence is a failure even when output looks right; irreversible actions (commit/push, send, delete) are confirmed out-of-band, never by self-report.
- domain: testing · homes: B§execution (decision↑); VER§principles two bullets (mechanics↓, calibrated); SE/CTO§tdd "Assert the action, not just the output" (verbatim, with the prompt-tweak example); FW§tdd (calibrated — example shortened)
- rationale attached: yes in every home (output-only tests stay green while the action silently stops)
- flags: none — a model multi-home opinion · **rec: stay**

### O29 `spikes-answer-questions` (family head — see T11, PD10)
When a decision needs a reactable answer, build a throwaway prototype: keep the answer (decision node / commit message), delete the code; anything absorbed re-enters through TDD.
- domain: methodology · homes: B§workflow (decision↑); SE/CTO§tdd "Logic spikes are the one sanctioned exception" (verbatim mechanics↓); PDE§reacting-beats-imagining (calibrated UI-variant mechanics↓)
- rationale attached: yes (people react, they don't author; the exception never covers leftovers)
- flags: FW deliberately lacks the spike exception (documented calibration — spikes need design judgement)
- **rec: stay**

### O30 `aar-meta-and-actionable`
After substantial work run a meta-level review (why it went well/poorly, what systemic change helps); every finding must be actionable, and findings are acted on now, routed by kind (doc / decision node / runbook / brief-or-def fix).
- domain: orchestration · homes: B§after-action-review (decision↑); AA def (evidence mechanics↓)
- rationale attached: yes
- flags: none · **rec: stay**

### O31 `self-debrief-is-testimony-not-evidence`
Re-wake the agent for a first-person debrief first (cheap for small runs), but treat it as testimony — an agent can't see its own blind spots; agent-analyzer verifies load-bearing testimony against the transcript.
- domain: orchestration · homes: B§after-action-review (decision↑, verbatim family); AA§your-role (mechanics↓, verbatim family + "divergence is itself a finding")
- rationale attached: yes in both homes
- flags: none · **rec: stay**

### O32 `cross-session-retrospective`
Promode's distinctive miss is cross-session scope: on a recognised stuck→unstuck repeat, dispatch analysis across recent transcripts + task docs; A/B-test doubtful skill sections before keeping them.
- domain: orchestration · homes: B§after-action-review (decision↑); AA job 3 (mechanics↓)
- rationale attached: yes (per-task reaction misses recurring patterns)
- flags: none · **rec: stay**

### O33 `propose-never-self-rewrite`
Methodology fixes from retrospectives are report-only — the human stays in the loop of any self-update.
- domain: orchestration · homes: B§after-action-review (decision↑)
- rationale attached: yes (human in the loop)
- flags: none · **rec: stay**

### O34 `tier-upgrade-reaudit`
On a model-tier upgrade, audit in reverse: guardrails tuned for a weaker model can degrade a stronger one — re-evaluate which still earn their place.
- domain: orchestration · homes: B§after-action-review (decision↑); authoring-register twin "calibrate scaffolding to the pin" (wiki, outside corpus)
- rationale attached: yes
- flags: none · **rec: stay**

### O35 `memory-as-capture-buffer`
Auto-memory is a capture buffer, not the store: promote worthwhile entries into the CLAUDE.md graph (with provenance), prune the rest; promoted facts supersede with a pointer, never silently overwrite; keep the decision log summarisation smooths away.
- domain: knowledge/memory · homes: B§after-action-review (decision↑)
- rationale attached: yes
- flags: none · **rec: stay**

### O36 `audit-fan-out-and-audit-as-a-lens`
Full alignment assessment fans out parallel assessors (promode-audit skill); a light targeted check asks the one owning agent to audit its dimension — each dimension mirrors what that agent upholds.
- domain: orchestration · homes: B§promode-audit (decision↑); skill mechanics (pointer)
- rationale attached: yes (dimensions mirror owners)
- flags: none · **rec: stay**

### O37 `escalate-early-bounded-attempts`
Every agent has explicit stop-and-report triggers; ~3 failed approaches is the shared bound (SE/FW green-test attempts, DBG investigation approaches); ambiguity, out-of-scope changes, and missing credentials always escalate.
- domain: methodology · homes: SE/FW/DBG/EM/VER/CTO/AA/PDE §escalation (mechanics↓, each calibrated to role); dispatcher side implicit in O8's exit condition
- rationale attached: partial (FW carries the strongest why: "escalating early is the fast path"; most homes list triggers bare)
- flags: **CR has no `<escalation>` section** — defensible (REWORK *is* its escalation, and R2's "say REWORK with exactly what evidence you need" covers the can't-decide case), but it is the only def without one and the omission is undocumented
- **rec: stay**; document or add CR's escalation equivalence when next touched

### O38 `know-your-lane-asymmetry`
FW stops and escalates when work needs design judgement; SE absorbs trivial work rather than bouncing it back; CTO re-dispatches routine implementation. The asymmetry (bounce up, absorb down) is the opinion.
- domain: orchestration · homes: FW§your-role "Know your lane" (mechanics↓); SE§your-role "just do it rather than bouncing it back" (mechanics↓); CTO§escalation (calibrated)
- rationale attached: yes (grinding above your brief produces plausible-but-wrong code; round-trips cost more than trivial work)
- flags: none — complementary by design, not a conflict · **rec: stay**

---

## Domain: methodology (shared working principles)

### P1 `evidence-over-assumptions`
Read the code, run it, check the log; never infer behaviour from names; verify before deciding; assumptions acted on are stated so they can be challenged.
- domain: methodology · homes: B§principles (decision↑, fullest form); SE/FW§principles (verbatim pair); CR§principles (calibrated: trace actual behaviour, "looks right" isn't review); DBG§principles (calibrated: stack trace vs "probably"); EM§principles (calibrated: actual status); VER§principles (calibrated: seen it work); AA§your-role (calibrated: verify or refute, never inherit); PDE (calibrated into evidence-grounded personas, PD3); CTO (calibrated into the assumptions note + evidence-backed stories)
- rationale attached: yes in B/SE/FW ("assuming X based on Y" is recoverable; silent isn't); role homes carry role-fitted whys
- flags: none — the most completely propagated opinion in the corpus · **rec: stay**

### P2 `tdd-non-negotiable`
RED→GREEN→REFACTOR always; no implementation without a failing test first; fix-by-inspection forbidden; baseline the suite before and after.
- domain: testing · homes: B§principles (decision↑); SE§tdd + CTO§tdd (verbatim — checksum-verified); FW§tdd (calibrated per runbook: fewer design-altitude bullets, no spike exception, extra non-code closing check); DBG (calibrated: repro-with-failing-test + fix-by-inspection-forbidden); CR (enforcement side: test-realness checks); n/a VER/EM/PDE/AA
- rationale attached: yes throughout
- flags: none — the flagship designed duplication, checksum-guarded and runbook-documented · **rec: stay**

### P3 `tests-are-the-documentation`
Behaviour lives in tests, not markdown; reviewers read tests as the spec; test names speak the domain's language.
- domain: testing · homes: B§principles (verbatim bullet); CR§principles (calibrated: "they're your spec"); SE/FW/CTO§tdd domain-vocabulary bullet (carries the phrase as its rationale)
- rationale attached: yes
- flags: none · **rec: stay**

### P4 `always-explain-the-why`
The why is the frame for judgement calls — in tests, comments, commit messages, review findings, decisions.
- domain: methodology · homes: B§principles (verbatim); SE/FW§principles (verbatim pair); DBG§principles (calibrated: helps future debugging); CR§principles (calibrated: "violates X because Y"); PDE (calibrated: DECISIONS.md Why field); CTO (calibrated: decision log in reporting)
- rationale attached: yes — and M3 is this opinion applied to the corpus itself
- flags: none · **rec: stay**

### P5 `kiss-small-diffs`
Solve today's problem, not tomorrow's hypothetical; the simplest thing that passes the tests; don't scope-creep.
- domain: software design · homes: B§principles (decision↑); SE/FW§principles (verbatim pair); CTO (calibrated: "as simple as the actual problem allows", "the smaller architecture is the goal"); CR (calibrated: no-unnecessary-complexity check + don't scope-creep the review); DBG (calibrated: fix the bug, not the neighbourhood); PDE (calibrated into PD1's cut-features stance)
- rationale attached: yes
- flags: none · **rec: stay**

### P6 `constraint-ladder`
Before writing (SE/FW: the GREEN step) or admitting a design element (CTO), run the five-step elimination ladder: need to exist? → stdlib? → platform? → existing dependency? → smallest extension? Only five nos earn new code.
- domain: software design · homes: SE§constraint-ladder + FW§constraint-ladder (verbatim pair); CTO§constraint-ladder (calibrated: admission check, "a design decision commits far more future code than any diff"); brief carries only the KISS decision above it (deliberate altitude split — mechanics stay down)
- rationale attached: yes (cheapest code is unwritten code; KISS as pre-check not consolation)
- flags: none · **rec: stay**

### P7 `crystallise-discovery-into-determinism`
Agents discover; deterministic code replays the finding for free — findings harden into maps, graphs, scripts, tests, never remain prose.
- domain: methodology · homes: B§principles (decision↑); CR should-pass check (enforcement); FW§gui-driving (mechanics: leave the reusable artifact); VER (uses the state-graph tier); EM§principles (env is the loop's substrate); mechanics in `discovery-to-determinism` skill (pointer); B§prompting-subagents ("say what deterministic artifact should exist") is its dispatch hook
- rationale attached: yes
- flags: none · **rec: stay**

### P8 `crystallised-failure-triage`
A failing crystallised check is a question for judgement: flake (harden), intended change (re-crystallise), or regression (raise/debug) — classify before chasing.
- domain: testing · homes: B§principles tail (decision↑); DBG§feedback-loop ¶1 (mechanics↓, verbatim family)
- rationale attached: yes (two of three outcomes are misdiagnoses that waste a repro loop)
- flags: none · **rec: stay**

### P9 `traceable-by-construction`
Code crossing the client↔backend boundary threads a correlation/tracer ID logged filterably on both sides, built in as the feature is written and covered like behaviour.
- domain: architecture · homes: B§principles (decision↑ — explicitly names its mechanics homes); SE/FW§principles (verbatim pair, build side); CTO§your-role (calibrated: designed-in, not retrofitted); DBG§debugging-workflow (use side + "no ID is itself a finding"); CR must-pass (enforcement: uncorrelated boundary logs are REWORK)
- rationale attached: yes in all five homes (token economy, faster debugging)
- flags: none — the corpus's best example of a deliberate five-role split · **rec: stay**

### P10 `stay-on-task-flag-dont-fix`
Don't fix unrelated issues or refactor adjacent code; note them for the main agent to triage — each home names its role's on-task carve-out (speeding your own test loop, scripting your own health-check loop, sharpening your repro).
- domain: methodology · homes: SE/FW§principles (verbatim pair); DBG§principles (calibrated carve-out); EM§principles (calibrated carve-out); CR (calibrated: review what was requested); VER (calibrated: verify-or-fix, O9); dispatcher side = O8's NOT-do
- rationale attached: yes (via carve-outs; triage belongs to the orchestrator)
- flags: none · **rec: stay**

### P11 `behavioural-authority-precedence`
When sources of truth conflict: passing tests > failing tests > explicit specs in docs/ > code > external documentation.
- domain: methodology · homes: SE/FW/CTO/CR/DBG §behavioural-authority (verbatim ×5); absent from B, VER, EM, PDE, AA
- rationale attached: **no — in any home.** The only widely-duplicated block that states the rule bare everywhere; under M3 this is the corpus's clearest rationale gap (why do passing tests outrank specs? — verified behaviour beats intended beats declared, but no home says so)
- flags: rationale gap (all homes); coverage debatable for B (the main agent adjudicates rework disputes and could use the precedence) and VER (it judges expected-vs-observed)
- **rec: adjust** — attach a one-line why to the block (one sync edit across five homes per the runbook); treat B/VER coverage as a register decision, not an obvious add

### P12 `commit-before-reporting`
Executing agents commit their changes (including repro tests and diagnostics) before reporting.
- domain: methodology · homes: SE/FW §your-role done-means + frontmatter descriptions (verbatim family); CTO (execute-path: "commit before reporting"); DBG (done-means item 4)
- rationale attached: partial — stated as part of "done", the why (work in an unmerged worktree evaporates; out-of-band verifiability per O28) is implicit
- flags: **coverage gap candidate — EM creates and updates management scripts but carries no commit discipline**; nothing tells EM its script changes must land in git before reporting
- **rec: adjust** — add commit-before-reporting to EM (it writes files); optionally attach the why in one home

### P13 `reports-succinct-info-dense`
The final message is all the main agent sees: succinct, information-dense, no preamble, payload calibrated per role (verdict / root cause / design + decision log / status).
- domain: orchestration · homes: all nine defs §reporting (pattern-verbatim, payload calibrated)
- rationale attached: yes (the "all the main agent sees" clause is the rationale, present in all nine)
- flags: none · **rec: stay**

### P14 `assumptions-note-in-reports`
Reports carry an explicit "not verified / assumptions" line so "done" isn't mistaken for "fully checked".
- domain: methodology · homes: B§prompting-subagents verified-vs-assumed (decision↑, dispatch side); SE/FW§reporting (verbatim pair); CTO§reporting (calibrated: assumptions the main agent challenges before ratifying); VER§reporting (calibrated: "not verified" scope note on PASS); CR (partial: "flag unverified assumptions" in principles, not reporting); DBG (partial: evidence-not-speculation discipline)
- rationale attached: yes where present
- flags: minor unevenness — EM reports status with no assumptions note; CR's lives outside its reporting contract. Low stakes
- **rec: stay**; fold into EM only if EM is touched for P12

### P15 `file-organization-for-context`
Large files burn agent context: one responsibility per file; split oversized files; big test suites in their own files.
- domain: software design · homes: SE/FW§file-organization (verbatim pair)
- rationale attached: yes
- flags: single-pair home; plausibly wider (CTO shapes module layout) — but CTO's KISS calibration covers the spirit · **rec: stay**

### P16 `backwards-compatibility`
Before changing public interfaces, schemas, or contracts, consider who depends on them; a design-level contract change names dependants and the migration story.
- domain: architecture · homes: SE/FW§principles (verbatim pair); CTO§your-role (calibrated up: "a contract change without a migration story is a cost silently pushed onto every dependant")
- rationale attached: yes (CTO home carries the strongest why)
- flags: none · **rec: stay**

### P17 `done-means-cluster`
"Done" = full suite green + acceptance criteria met + changes committed + dug-up knowledge captured (+ task-doc outcome recorded).
- domain: methodology · homes: SE/FW§your-role (verbatim pair); DBG done-list (calibrated); VER done-means (calibrated: exercised + verdict + evidence)
- rationale attached: partial (components carry their own whys elsewhere: P12, K2, O19)
- flags: none · **rec: stay**

---

## Domain: knowledge/memory

### K1 `llm-wiki-graph`
Durable project knowledge is an interlinked markdown graph rooted at `CLAUDE.md`: auto-loaded orientation at the root, linked docs beneath, optional subtree launchpads with `AGENTS.md -> CLAUDE.md` symlinks; never clobber existing orientation; bootstrap a minimal root if missing.
- domain: knowledge/memory · homes: B§agent-knowledge (decision↑: enforcement + routing; bootstrap-is-first-delegation); SE/FW/DBG/EM §agent-knowledge (verbatim family); CTO§agent-knowledge (calibrated to decisions); PDE§agent-knowledge (calibrated + docs/product as named area); CR must-pass (enforcement: symlink + mirrored rules); EM adds "this agent often runs first in a fresh repo"
- rationale attached: yes (knowledge dug once, never re-derived; that's what keeps future sessions cheap)
- flags: **coverage gap candidates — VER and AA have no `<agent-knowledge>` section at all.** Defensible by role (VER reports rather than writes — the missing-seam finding routes capture via the main agent per B§agent-knowledge; AA's findings likewise feed AAR routing), but the defence is written nowhere, and AA's cross-session patterns are precisely durable-knowledge material
- **rec: adjust** — record the deliberate omission (register/def comment) or give VER/AA a one-line "report knowledge for capture; you don't write the graph" clause; don't bolt on full capture sections

### K2 `capture-rule`
Real effort uncovering something undocumented that a future agent needs → write a cold-readable doc and link it in; the main agent dispatches capture when a report surfaces knowledge the agent didn't capture.
- domain: knowledge/memory · homes: SE/FW/DBG/EM/PDE §agent-knowledge capture paragraphs (verbatim family); B§agent-knowledge (decision↑: dispatch capture before it evaporates); CTO (calibrated: decisions are the capture)
- rationale attached: yes ("you learned it by doing, so it's grounded"; evaporation)
- flags: none · **rec: stay**

### K3 `decision-nodes`
A decision earns its own node when it's hard to reverse, surprising without context, and a real trade-off — record what was decided, what was rejected, and why.
- domain: knowledge/memory · homes: B§after-action-review (decision↑); SE§agent-knowledge, DBG§agent-knowledge (verbatim family); CTO§agent-knowledge (calibrated: "your decisions are exactly the kind"); PDE (calibrated: DECISIONS.md format)
- rationale attached: yes
- flags: **undocumented divergence — FW's `<agent-knowledge>` lacks the decision-node sentence** while carrying the rest of the family text. Plausibly deliberate (FW rarely makes trade-off decisions) but, unlike FW's TDD calibration, it is documented nowhere (the sync runbook covers only the TDD block)
- **rec: adjust** — either restore the sentence to FW or note the calibration in the sync runbook / register; silent divergence is what this inventory exists to catch

### K4 `runbooks-prefer-scripts`
A repeatable operational procedure earns a runbook linked from a `RUNBOOKS.md` hub; prefer a script where steps can be automated, with the runbook linking to it.
- domain: knowledge/memory · homes: B§after-action-review (decision↑); SE/FW/EM §agent-knowledge (verbatim family, "deploy, migration, build/run setup, recovery"); DBG (calibrated: "a recurring failure class worth a repeatable response"); EM§script-maintenance is the same opinion's script half (E2)
- rationale attached: yes
- flags: none (DBG's wording is role-calibration, substance aligned) · **rec: stay**

### K5 `one-idea-one-home-cold-readable`
Each doc is cold-readable and states one idea in one place; links carry the graph; loaded orientation stays compact; cite nodes in briefs, don't paste content.
- domain: knowledge/memory · homes: SE/FW/DBG capture tails (verbatim family; DBG adds "prefer a small linked doc over bloating CLAUDE.md"); B§agent-knowledge ("cite the relevant nodes, don't paste"); wiki §graph-rules (canonical, outside corpus)
- rationale attached: yes (context tax; attention dilution — fullest in wiki)
- flags: none · **rec: stay**

### K6 `mirror-critical-rules-inline`
A critical rule for a subtree is mirrored inline in that subtree's `CLAUDE.md` (nearest *loaded* orientation), not only linked from root; enforced at review.
- domain: knowledge/memory · homes: SE/FW/DBG/EM/CTO/PDE §agent-knowledge maintaining-orientation (verbatim family); CR must-pass (enforcement: "missing loaded orientation for a critical rule is REWORK"); B§agent-knowledge (graph health as AAR concern); reinforce-design-constraints skill (mechanics pointer)
- rationale attached: yes (an agent violated a rule it had no way to know — the skill's framing)
- flags: none · **rec: stay**

### K7 `orient-before-acting`
Every agent reads the knowledge graph (root `CLAUDE.md`, following links) before working; briefs point at nodes.
- domain: knowledge/memory · homes: B§agent-knowledge (decision↑: orient from it, point delegations at it); SE/FW/CR/DBG/EM/PDE/VER/CTO role/workflow sections (verbatim family: "Orient before…"); AA (calibrated: its orientation is the notification + transcript)
- rationale attached: partial (mostly stated as step 1; the why is O1's context economics)
- flags: none · **rec: stay**

### K8 `docs-product-as-named-subtree`
Product knowledge lives in `docs/product/` — not a parallel graph but a named area within it, because design systems/decisions/vocabulary form a cohesive body maintained as a unit.
- domain: product design · homes: PDE§your-role + §your-docs (single home, mechanics↓; B routes to it via §product-considerations and §feature-knowledge-base PERSONAS path)
- rationale attached: yes (grouping keeps institutional knowledge discoverable)
- flags: none · **rec: stay**

---

## Domain: testing (TDD block members and seam doctrine)

### T1 `one-test-at-a-time-vertical`
Never batch tests then code (horizontal slicing tests imagined behaviour); go vertical — one test → pass → next, each informed by the last.
- domain: testing · homes: SE/CTO§tdd (verbatim, checksum-covered); FW§tdd (verbatim bullet)
- rationale attached: yes · flags: none · **rec: stay**

### T2 `confirm-red-for-the-expected-reason`
A new test must fail because the behaviour is missing — read the failure message; failing for an unrelated reason proves nothing.
- domain: testing · homes: SE/CTO/FW§tdd (verbatim across all three)
- rationale attached: yes · flags: none · **rec: stay**

### T3 `outside-in`
Start from user-visible behaviour; outside-in bottoms out outside the system at the operator seam, exercising real logic.
- domain: testing · homes: SE/CTO/FW§tdd (verbatim bullet); SE§operator-seam (the bottoming-out clause); VER§principles (calibrated: user-visible behaviour, not internal units); B§test-strategy (decision-level frame)
- rationale attached: yes · flags: none · **rec: stay**

### T4 `trace-user-need-test-to-evidence`
A feature/acceptance test encoding a user need must trace to an evidence-based user story; an unbacked assumption is REPORTED, never silently baked into the domain model.
- domain: testing · homes: SE/CTO§tdd (verbatim); B§feature-knowledge-base (decision↑, fullest form — see PD4); CR should-pass (enforcement, non-blocking); PDE§lenses (product side)
- rationale attached: yes in every home (the propagation-cost why travels everywhere — model M3 compliance)
- flags: FW absence is documented calibration (runbook: "fewer design-altitude bullets") · **rec: stay**

### T5 `reproduce-bugs-with-failing-test-first`
No bug fix without a failing reproduction; the repro lives with the other tests, not as a one-off script.
- domain: testing · homes: SE/CTO/FW§tdd (verbatim bullet); DBG§workflow step 5 + §principles (mechanics↓, fullest form)
- rationale attached: yes · flags: none · **rec: stay**

### T6 `mock-only-at-system-boundaries`
Mock external APIs, DB, time, randomness — never your own modules; prefer real sandbox/test environments; tag slow tests to keep the dev loop fast.
- domain: testing · homes: SE/CTO/FW§tdd (verbatim bullet)
- rationale attached: **no** — stated bare in all three homes (the mocking-your-own-modules-tests-the-mock why is unstated)
- flags: rationale gap (minor; well-known doctrine the pinned tiers hold from training — arguably M1-compliant as a bare opinion pin)
- **rec: stay** — bare is acceptable here per M1; note for the register

### T7 `independent-oracle-no-tautology`
Expected values come from an independent source of truth (hand-derived, spec, known-good oracle); an assertion recomputing the expected value the code's way passes by construction.
- domain: testing · homes: SE/CTO/FW§tdd (verbatim); CR must-pass (enforcement: "reject the tautological test")
- rationale attached: yes · flags: none · **rec: stay**

### T8 `assert-the-design-contract`
Assertions state what the code *should* do (spec/design-sourced), never calibrate to current behaviour — that encodes today's bugs as baseline.
- domain: testing · homes: SE/CTO/FW§tdd (verbatim)
- rationale attached: yes · flags: none · **rec: stay**

### T9 `stochastic-outcomes-as-distributions`
Stochastic behaviour is asserted across seeds/samples with explicit tolerances; a single-sample pin is a blind test, not a weak one.
- domain: testing · homes: SE/CTO/FW§tdd (verbatim)
- rationale attached: yes · flags: none · **rec: stay**

### T10 `domain-vocabulary-test-names`
Test names use the project's canonical domain vocabulary where a glossary node exists — tests are documentation, so they speak the domain's language.
- domain: testing · homes: SE/CTO/FW§tdd (verbatim); rationale is P3
- rationale attached: yes · flags: none · **rec: stay**

### T11 `logic-spikes-exception`
The one sanctioned TDD exception: a pure, portable state module behind a disposable shell to answer a domain/algorithm question; the answer is the deliverable; absorbed code re-enters through TDD.
- domain: testing · homes: SE/CTO§tdd closing ¶ (verbatim); family head O29; FW absence documented
- rationale attached: yes · flags: none · **rec: stay**

### T12 `operator-seam-bulk-below-ui`
Where a UI fronts real logic, the bulk of acceptance coverage runs headless through a below-UI operator seam (fast, deterministic, CI-cheap); building/extending the seam is first-class, test-driven work.
- domain: architecture · homes: B§test-strategy (decision↑); SE§operator-seam (builder mechanics↓); CTO§operator-seam (architect: seam placement is an architectural call, not a testing detail); CR must-pass (enforcement: through-the-UI coverage with a seam available is REWORK); VER workflow/principles (cheapest-faithful-path); DBG§feedback-loop (repro path, calibrated); EM§principles (env substrate, calibrated); mechanics in `discovery-to-determinism` skill (pointer)
- rationale attached: yes in every home
- flags: none — seven calibrated homes, promode's widest and cleanest opinion propagation · **rec: stay**

### T13 `one-seam-two-operators`
The seam serving tests is the same architectural investment an agent tool could build on — but the agent half is an unproven structural prediction (n=1): design toward it, never rely on it, never build it speculatively, and never expose test god-mode (reset/seed/freeze/auth-bypass) as a production agent surface.
- domain: architecture · homes: B§test-strategy (decision↑); SE§operator-seam (verbatim family + "one adapter is a hypothetical seam; two adapters is a real one"); CTO§operator-seam (verbatim family + "a designed-in incident")
- rationale attached: yes, with unusual epistemic honesty (the n=1 flag is itself part of the opinion)
- flags: none · **rec: stay**

### T14 `extend-existing-seam-not-parallel`
Prefer exposing/cleaning an existing API/service-layer/CLI over inventing a second entry point — a parallel seam drifts, and then tests exercise the drift.
- domain: architecture · homes: SE§operator-seam (verbatim family); CTO§operator-seam (verbatim family, carries the drift why); B§test-strategy ("preferring an existing API/service-layer/CLI")
- rationale attached: yes · flags: none · **rec: stay**

### T15 `ui-tier-surgical-tiers-not-merged`
The UI tier is slow, surgical, verification-only — reserved for behaviour that only manifests through the real GUI; re-testing headless-covered logic at the UI tier is the central anti-pattern.
- domain: testing · homes: B§test-strategy (decision↑); CR must-pass ×2 (enforcement); VER§principles seam-first (verbatim family); SE§operator-seam "keep the UI a thin shell" (calibrated: builds the tier, doesn't cover with it); DBG (calibrated: drop down from the GUI to reproduce)
- rationale attached: yes · flags: none · **rec: stay**

### T16 `seam-changes-are-architectural`
Introducing or reshaping a seam beyond a local extension is an architectural move: SE proposes rather than imposes; CTO owns placement; the main agent ratifies.
- domain: architecture · homes: SE§operator-seam + §escalation (mechanics↓); CTO§your-role (owner); B§test-strategy ("a high-leverage architectural call")
- rationale attached: yes · flags: none · **rec: stay**

### T17 `selectors-never-coordinates`
GUI automation keys off stable selectors/identifiers (testID, distinctive text), never hardcoded coordinates; validate each step against the live tree.
- domain: testing · homes: FW§gui-driving (mechanics↓); CR should-pass (enforcement); SE§operator-seam (pointer clause); canonical mechanics in `discovery-to-determinism` skill
- rationale attached: partial in defs (bare rule + skill pointer; the brittleness why lives in the skill)
- flags: none — correct altitude (mechanics live in the skill) · **rec: stay**

### T18 `proportionality-defer-harness-abstraction`
Apply seam/tier/crystallise checks in proportion to the change; don't demand a reusable test harness or shared library until a second app/surface has exercised it.
- domain: testing · homes: CR§review-criteria closing ¶ (single home)
- rationale attached: yes (deferred abstraction)
- flags: single-home, plausibly wider — SE/CTO build what CR here declines to demand; the constraint-ladder's step 5 covers the reuse half but not the "second consumer earns the abstraction" half
- **rec: adjust (consider)** — candidate to mirror the second-consumer rule into SE/CTO ladder territory via the register; not urgent (CR gates it in practice)

### T19 `testability-primitives`
The test layer depends on three env primitives: automated bring-up to known-good, a real reset (truncate/reseed, not best-effort cleanup), per-test data isolation; hidden shared state reads as flakiness.
- domain: testing · homes: EM§script-maintenance (single home, mechanics↓)
- rationale attached: yes
- flags: appropriately single-home (EM owns env) · **rec: stay**

### T20 `reproducible-env-is-the-cost-budget`
Bring-up/reset/isolation flakiness dominates the cost of automated testing; determinism here pays back across every run — load-bearing, not housekeeping.
- domain: testing · homes: EM§principles (single home; explicitly ties to P7's loop and T12's below-UI economics)
- rationale attached: yes · flags: none · **rec: stay**

### T21 `design-lookbook-visual-analogue`
Visual/design work gets the same loop as code: a two-layer design source-of-truth (DESIGN_SYSTEM.md) + rendered lookbook + live-refresh preview — taste captured once, replayed deterministically; covers marketing artifacts.
- domain: product design · homes: B§test-strategy (decision↑); PDE§your-docs (mechanics↓, calibrated); canonical mechanics in `design-system-lookbook` skill (pointer)
- rationale attached: yes (visual analogue of the headless loop; tests-trace-to-specs parallel)
- flags: none · **rec: stay**

---

## Domain: debugging

### D1 `repro-loop-is-the-core`
A fast, deterministic pass/fail signal for the bug is the core of debugging — spend disproportionate effort building one (preference-ordered ladder given), then iterate on the loop itself; for non-deterministic bugs chase reproduction *rate*. Hard gate: no red-capable reproduction command, no hypothesis phase. Work inward, then outward.
- domain: methodology · homes: DBG§debugging-workflow + §feedback-loop (single home, mechanics↓); B§debugging-snags carries the decision-level redirect
- rationale attached: yes (2-second loop vs 30-second flake; anchoring)
- flags: none · **rec: stay**

### D2 `ranked-falsifiable-hypotheses`
Generate 3–5 ranked, falsifiable hypotheses before testing any; each states its prediction ("if X, changing Y kills the bug") — no prediction is a vibe.
- domain: methodology · homes: DBG§debugging-workflow step 3 (single home)
- rationale attached: yes (single-hypothesis debugging anchors on the first plausible idea)
- flags: none · **rec: stay**

### D3 `debug-hygiene`
Test one variable at a time; prefer a debugger/REPL breakpoint over logs; tag every debug line with a unique prefix (`[DEBUG-a4f2]`) so cleanup is one grep; filter cross-boundary bugs by tracer ID.
- domain: methodology · homes: DBG§debugging-workflow step 4 (single home; tracer-ID half is P9's use side)
- rationale attached: yes
- flags: minor: SE also implements hard-bug fixes but carries no debug-hygiene; acceptable (DBG owns diagnosis; SE receives a repro) · **rec: stay**

### D4 `system-tests-verify-not-debug`
Never use slow system tests as the debugging feedback loop (the fail→speculate→rerun trap); reproduce in a focused loop, run system tests once confident.
- domain: testing · homes: B§debugging-snags (decision↑: watch for and redirect the anti-pattern); DBG§feedback-loop (mechanics↓, with the tier-latency table)
- rationale attached: yes (each cycle wastes minutes)
- flags: none · **rec: stay**

### D5 `prevention-is-part-of-the-finding`
Every debrief names what would have caught the bug earlier — a missing seam, type, assertion, tracer ID, or log — feeding the main agent's review. (Family: "absence is a finding" — see V5.)
- domain: methodology · homes: DBG§documenting-findings (single home)
- rationale attached: yes (actionable, feeds review)
- flags: none · **rec: stay**

### D6 `record-the-confirmed-hypothesis`
State the confirmed hypothesis in the final report and the commit message, so the next debugger learns which prediction survived.
- domain: knowledge/memory · homes: DBG§documenting-findings (single home)
- rationale attached: yes · flags: none · **rec: stay**

---

## Domain: review

### R1 `two-axis-review`
Review spec (did it do what was asked) and standards (does it follow this repo's conventions) as independent axes, kept separate in the report.
- domain: methodology · homes: CR§two-axis (single home)
- rationale attached: yes (clean code masking wrong thing, and vice versa)
- flags: none · **rec: stay**

### R2 `reviewer-does-not-run-tests`
The implementing agent runs the suite; the reviewer judges the code and test-realness by reading; suspected broken suite/coverage = REWORK with the evidence needed, never guessing.
- domain: methodology · homes: CR§review-workflow (single home)
- rationale attached: yes — unusually complete (the trade-off it costs is stated, plus the compensating discipline)
- flags: none · **rec: stay** — model M3-compliant single-home opinion

### R3 `distrust-the-narration`
Commit messages, comments, and task-doc framing are the author's claims, not evidence — weight them at zero where they conflict with the diff; bites hardest on security-relevant diffs; read the deletions.
- domain: methodology · homes: CR§principles (single home; receiver side of O10)
- rationale attached: yes (a plausible story is exactly the attack)
- flags: none · **rec: stay**

### R4 `judging-discipline`
Subjective calls get deliberate judging: a rubric per dimension (never one gestalt verdict); pairwise comparison when "better" can't be pre-defined; consensus-audit — distrust frictionless approval of risky changes and attack uncontested assumptions before approving.
- domain: methodology · homes: CR§judging-discipline (single home)
- rationale attached: yes
- flags: single-home, plausibly wider — the consensus-audit stance ("suspicion rises with the absence of disagreement") applies verbatim to the main agent ratifying CTO designs; nothing in B carries it
- **rec: adjust (consider)** — candidate one-line mirror into B's ratification flow (§role or §model-tiers) via the register

### R5 `dismissed-findings-need-stated-reasons`
A finding you dismiss gets "considered, not blocking because X" — an unexplained omission looks like a miss; plus don't nitpick within project norms.
- domain: methodology · homes: CR§rework-guidance (single home)
- rationale attached: yes (leaves a trail)
- flags: none · **rec: stay**

### R6 `crisp-verdicts`
Judging agents return unhedged verdicts: CR APPROVED/REWORK; VER PASS/FAIL; PDE Approve/Refine/Reject ("clear guidance, not diplomatic hedging").
- domain: methodology · homes: CR§reporting/§review-workflow; VER§reporting; PDE§giving-feedback (calibrated triplet)
- rationale attached: yes in PDE; implicit in CR/VER (the orchestrator needs a decision, not commentary)
- flags: none · **rec: stay**

---

## Domain: verification

### V1 `running-app-is-the-proof`
"Tests pass" is not verification; a change is verified when the real running app was exercised from the outside and the behaviour observed.
- domain: testing · homes: VER§your-role + §principles (mechanics↓); B§execution (decision↑: checkpoints exercise the running app)
- rationale attached: yes · flags: none · **rec: stay**

### V2 `prove-the-change-is-real-first`
Before judging output, confirm the change took effect (byte/behaviour diff vs baseline) — a critique of an unchanged artifact verifies a no-op.
- domain: testing · homes: VER§principles (single home)
- rationale attached: yes · flags: none · **rec: stay**

### V3 `replay-the-reporters-framing`
Bug-fix verification replays the reporter's exact steps/parameters/viewport first; your own probing supplements, never substitutes.
- domain: testing · homes: VER§principles (single home)
- rationale attached: implicit (substitute framing can miss the reported path)
- flags: none · **rec: stay**

### V4 `seed-bad-state-for-resilience`
When the change is about error-handling/resilience, verify recovery: seed a deliberately bad/failed state and confirm self-correction, not just the happy path.
- domain: testing · homes: VER§principles (single home)
- rationale attached: yes (resilience is the point)
- flags: none · **rec: stay**

### V5 `absence-is-a-finding` (family)
A missing piece of infrastructure or evidence is itself the deliverable finding, never silently worked around or invented: missing below-UI seam (VER), missing tracer ID (DBG), missing persona (PDE: "surface it, don't invent one"), missing user-need evidence (CTO: "that's the finding"), missing traceable goal link (B: "a red flag, not a paperwork gap").
- domain: methodology · homes: VER§principles flag-slow/flaky; DBG§workflow step 4; PDE§red-flags; CTO§escalation + role constraint; B§feature-knowledge-base (each calibrated — a convergent stance, not copied text)
- rationale attached: yes in each home
- flags: none — worth naming as one opinion in the future register even though no two homes share wording · **rec: stay**

### V6 `verify-via-the-verify-skill`
VER drives the app through Claude Code's built-in `/verify` skill (which knows how the project runs), escalating if unavailable or unfit.
- domain: orchestration · homes: VER§verification-workflow (single home); B§delegation-map routes "via /verify"
- rationale attached: partial (reuse of the harness's app-launch knowledge is implied)
- flags: harness-coupled (built-in skill dependency) — consistent with the repo's optimise-for-current-harness goal, decays silently if the built-in changes · **rec: stay**; register should mark it harness-pinned

---

## Domain: product design

### PD1 `skeptical-default-most-features-cut`
Most feature requests are solutions looking for problems; the default answer is no — cut, don't add, especially anything "in case"; ask what problem it solves and who actually has it.
- domain: product design · homes: PDE§your-role/§how-you-think/§red-flags (mechanics↓, fullest); B§clarifying-outcomes ("challenge busywork") + B§feature-knowledge-base ("focus is the default; resist goal proliferation") (decision↑, calibrated)
- rationale attached: yes · flags: none · **rec: stay**

### PD2 `defaults-over-settings`
Make decisions instead of adding settings: defaults over options, constraints over configurability — "settings are where decisions go to die"; options compound.
- domain: product design · homes: PDE§how-you-think + §red-flags (single home)
- rationale attached: yes · flags: none · **rec: stay**

### PD3 `personas-evidence-grounded-name-the-who`
Every user-facing change names the documented persona it serves (`docs/product/PERSONAS.md`); personas must be realistic — grounded in real customer evidence, with an anti-persona; a change that can't name one is as suspect as one with no goal.
- domain: product design · homes: B§feature-knowledge-base + §product-considerations (decision↑); PDE§lenses/§your-docs PERSONAS format/§red-flags (mechanics↓, calibrated)
- rationale attached: yes (personas supply the who; goals the why)
- flags: none · **rec: stay**

### PD4 `user-needs-are-evidence-bearing-claims`
Workflows/processes/use cases a goal rests on are claims about real people: cite the grounding signal (research, tickets, usage data) or flag the assumption with a validation path — never silent, never fabricated; evidence is graded, not all-or-nothing.
- domain: product design · homes: B§feature-knowledge-base (decision↑, fullest); PDE§lenses (mechanics↓, verbatim family); SE/CTO§tdd T4 (test-level enforcement); CR should-pass (review-level); CTO role constraint 1 (design-level)
- rationale attached: yes in all five homes — the propagation-cost why (A1) travels with every copy; the corpus's flagship M3 exemplar
- flags: none · **rec: stay**

### PD5 `traceability-hierarchy`
Every change traces up goals→marketing→feature definitions→feature tests, each layer linking up to a goal; no traceable link is a red flag (superfluous work or stale goals — surface it); changing the top clears a higher bar than the feature below.
- domain: product design · homes: B§feature-knowledge-base (decision↑, single home — enforcement is the main agent's "be a stickler" job)
- rationale attached: yes (self-describing repo; the two-explanations fork)
- flags: single-home but correctly altitude-placed · **rec: stay**

### PD6 `post-hoc-justification-trap`
Post-hoc justification is one trap in three guises — a stretched/invented goal, a flattered persona, a fabricated citation — and none is a valid fix; make the user defend the goal, not just the feature.
- domain: product design · homes: B§feature-knowledge-base (decision↑); PDE§red-flags (mechanics↓: invented/flattered/stretched personas; absent persona is the finding)
- rationale attached: yes · flags: none · **rec: stay**

### PD7 `scenario-as-the-bridge`
An evidence-based user story expressed as a high-level executable scenario IS the bottom-layer feature test — one artifact bridging product docs and the acceptance suite; Gherkin is one option, not a mandate.
- domain: testing · homes: B§feature-knowledge-base (decision↑); PDE§your-docs (mechanics↓: handing a ready acceptance spec); SE/CTO§tdd T4 parenthetical (verbatim clause)
- rationale attached: yes · flags: none · **rec: stay**

### PD8 `ship-simple-copy-proven`
Rather ship something simple than plan something perfect; copy proven patterns over inventing new ones; shipping over discussing.
- domain: product design · homes: PDE§your-role/§how-you-think (single home)
- rationale attached: implicit (character framing)
- flags: none · **rec: stay**

### PD9 `pde-consult-routing`
Consult PDE when a change is user-facing / adds UI/flows / has real trade-offs / touches growth-retention-psychology / rests on an unvalidated user-need assumption; skip for pure backend, obvious fixes, purely technical changes.
- domain: orchestration · homes: B§product-considerations (decision↑); PDE frontmatter description (mirror)
- rationale attached: yes · flags: none · **rec: stay**

### PD10 `reacting-beats-imagining` (mechanics of O29)
Tacit taste is extracted with reactable artifacts: 3 (max 5) radically different variants, mounted inside the existing app (a standalone route is a vacuum), switchable, hidden from production; expect compositional feedback; capture the answer, delete the prototype.
- domain: product design · homes: PDE§reacting-beats-imagining (mechanics↓, single home; decision↑ home is B§workflow via O29)
- rationale attached: yes (people know it when they see it; isolation makes everything look fine)
- flags: none · **rec: stay**

### PD11 `holistic-product-lenses`
Every product decision gets the persona, psychology (cognitive load, habit), behavioural-economics (defaults, framing, friction), network-effects, and growth lenses — surfaced when relevant, not forced.
- domain: product design · homes: PDE§lenses + §your-role expertise list (single home)
- rationale attached: partial (lens list asserted; "don't miss obvious opportunities" is the operating why)
- flags: none · **rec: stay**

---

## Domain: architecture (CTO cluster)

### A1 `entity-model-is-highest-stakes`
The entity/domain model is the highest-stakes artifact: an unvalidated user-need assumption propagates into it, and it's the most expensive layer to unwind — so getting the user need wrong is the costliest mistake the project can make.
- domain: architecture · homes: CTO§your-role constraint 1 (mechanics↓, artifact framing); B§feature-knowledge-base "Why this is the costliest mistake" (decision↑); PDE§lenses (product framing); embedded as the rationale clause of T4/PD4 in SE/CR
- rationale attached: yes — this opinion largely *is* a rationale, deliberately duplicated (M3)
- flags: none · **rec: stay**

### A2 `reversibility-weighted-depth`
Spend design depth on genuine one-way doors; decide cheap-to-reverse things quickly; say which is which.
- domain: architecture · homes: CTO§your-role (mechanics↓); B routing "crucial, hard-to-reverse design" (decision↑); K3's node criterion is its knowledge-side twin
- rationale attached: yes · flags: none · **rec: stay**

### A3 `recommendation-plus-strongest-rejected`
Deliver a recommendation with the strongest rejected alternatives and why — not a survey; the decision log is what future sessions need most because summarisation smooths it away.
- domain: architecture · homes: CTO§reporting + §your-role (mechanics↓); B§after-action-review "keep the decision log" (decision↑, verbatim family); O35 memory rule carries the same why
- rationale attached: yes · flags: none · **rec: stay**

### A4 `designs-are-delegations`
CTO delivers plans as delegation-ready tasks (sized, dependencies and parallelism named, checkpoints placed, deliverable/out-of-scope/exit per task, tier-routed); executes itself only when design and diff are inseparable — and then TDD binds it fully.
- domain: architecture · homes: CTO§your-role constraint 2 (mechanics↓); mirrors O8/O22/O27 from the drafting side (calibrated)
- rationale attached: yes · flags: none · **rec: stay**

---

## Domain: environment

### E1 `environment-safety-envelope`
Never: delete data volumes unrequested, expose 0.0.0.0 in prod contexts, store secrets in scripts/compose, run destructive commands without confirmation context. Always: check what's running first, preserve data on rebuild, report security concerns, suggest .env for sensitive config.
- domain: methodology · homes: EM§environment-safety (single home)
- rationale attached: **no** — bare never/always lists (mostly self-evident safety items)
- flags: rationale-bare; low priority (M1: a sonnet pin knows why secrets don't go in compose files) · **rec: stay**

### E2 `script-repeated-operations`
Repeated manual commands, complex startups, env-specific config, and health checks get scripts (`scripts/`, executable, usage comments, common names) — the script half of K4.
- domain: methodology · homes: EM§script-maintenance (single home; K4 homes carry "prefer a script" everywhere)
- rationale attached: partial · flags: none · **rec: stay**

---

## Domain: agent analysis

### AN1 `notification-before-transcript`
Two shortcuts before opening any transcript: the task-notification already carries the result + usage (often enough); use the transcript only for what the notification can't give (tool sequence, retries, failure points).
- domain: orchestration · homes: AA§mechanics (single home)
- rationale attached: yes (context economy)
- flags: none · **rec: stay**

### AN2 `transcript-red-flags`
Assess runs for: repeated retries of the same action, unaddressed errors, summary/transcript mismatch, going off-track, a report more confident than the run it summarises.
- domain: methodology · homes: AA§performance-assessment (single home)
- rationale attached: implicit · flags: none · **rec: stay**

### AN3 `divergence-is-a-finding`
Where testimony and transcript diverge, the divergence itself is a finding — an agent that misremembers its own run has a blind spot worth naming.
- domain: methodology · homes: AA§your-role (single home; the mechanics side of O31)
- rationale attached: yes · flags: none · **rec: stay**

---
---

# Assessment summary

## 1. Conflict list

**No hard contradictions found.** Copies of designed-duplicate opinions are substantively aligned (TDD blocks checksum-verified; principle families consistent). Tensions and divergences, in descending order of substance:

| # | Finding | Class | Where | Assessment |
|---|---------|-------|-------|------------|
| C1 | FW's `<agent-knowledge>` omits the decision-node sentence its family carries (SE/DBG verbatim, CTO/PDE calibrated) — and unlike FW's TDD calibration, no runbook/register documents it | undocumented divergence | FW vs K3 family | The exact class of silent divergence this inventory exists to catch; either deliberate-and-undocumented or drift. See K3 rec |
| C2 | `behavioural-authority` block is rationale-bare in all five homes — the only wide duplicate violating rationale-travels-with-the-rule | rationale gap | SE/FW/CTO/CR/DBG | One sync edit fixes all homes (runbook procedure). See P11 rec |
| C3 | Steer/resume-vs-fresh-spawn stated twice within the brief at near-equal depth | within-file redundancy | B§background-delegation ↔ B§subagent-scoping | Not designed duplication (that's brief↔defs); trim one to a cross-ref. See O5 rec |
| C4 | "Reach for the lowest capability tier" (O12) vs "when unsure, don't downgrade — prefer opus" (O13) | surface tension only | B§delegation-map ↔ B§model-tiers | Different axes (mechanism tier vs model tier); rationales already disambiguate; no change needed |
| C5 | "TDD is non-negotiable" (B§principles, absolute) vs sanctioned spike exceptions (SE/CTO/PDE) | resolved tension | B ↔ defs | B§workflow itself sanctions spikes ("throwaway code that answers a question"), and the defs scope the exception tightly; consistent, though B's principles bullet never nods to the exception |
| C6 | CR demands seam-based coverage ("where one reasonably exists") while SE must not create seams unilaterally (propose-don't-impose) | designed handshake | CR ↔ SE/CTO | Reconciled by CR's "reasonably exists" qualifier + T18 proportionality + SE's escalation path; no drift |
| C7 | EM "full autonomy to… fix environment issues" vs shared "flag, don't fix" | resolved by carve-out | EM internal | Env *is* EM's task; the carve-out is explicit in its stay-on-task bullet |
| C8 | DBG's runbook trigger is "recurring failure class"; SE/FW/EM say "repeatable operational procedure" | calibration, not drift | K4 family | Role-fitted wording, same substance |

## 2. Coverage matrix

Marks: **●** held (verbatim/substantive) · **◐** held calibrated (deliberately refitted to role/pin) · **○** absent where the role plainly (or arguably) warrants it — a gap flag · **·** n/a for the role. Footnotes: † debatable gap (register decision); ‡ documented designed absence.

Single-home role-local opinions (D1–D6, R1–R5, V2–V4, PD2/PD8/PD10/PD11, E1–E2, AN1–AN3, T18–T20, K8, O16–O24, etc.) are ● in their named home and · everywhere else; they are omitted as rows. Orchestration opinions with no def-side counterpart (O1, O3–O6, O11–O18, O20–O26, O30, O32–O36) live in B only *by design* (brief isolation) and are likewise omitted.

| Opinion | B | SE | FW | CTO | CR | DBG | VER | EM | PDE | AA |
|---|---|---|---|---|---|---|---|---|---|---|
| P1 evidence-over-assumptions | ● | ● | ● | ◐ | ◐ | ◐ | ◐ | ◐ | ◐ | ◐ |
| P2 tdd-non-negotiable | ● | ● | ◐ | ● | ◐ | ◐ | · | · | · | · |
| P3 tests-are-documentation | ● | ◐ | ◐ | ◐ | ● | · | · | · | · | · |
| P4 explain-the-why | ● | ● | ● | ◐ | ● | ● | · | · | ◐ | · |
| P5 kiss-small-diffs | ● | ● | ● | ◐ | ◐ | ◐ | · | · | ◐ | · |
| P6 constraint-ladder | · | ● | ● | ◐ | · | · | · | · | · | · |
| P7 crystallise-discovery | ● | ◐ | ◐ | · | ◐ | ◐ | ◐ | ◐ | ◐ | · |
| P8 crystallised-failure-triage | ● | · | · | · | · | ● | · | · | · | · |
| P9 traceable-by-construction | ● | ● | ● | ◐ | ◐ | ◐ | · | · | · | · |
| P10 stay-on-task | ◐ | ● | ● | ◐ | ◐ | ● | ◐ | ● | · | · |
| P11 behavioural-authority | ○† | ● | ● | ● | ● | ● | ○† | · | · | · |
| P12 commit-before-reporting | · | ● | ● | ● | · | ● | · | ○ | · | · |
| P13 succinct-reports | · | ● | ● | ● | ● | ● | ● | ● | ● | ● |
| P14 assumptions-note | ● | ● | ● | ● | ◐ | ◐ | ● | ○ | · | ◐ |
| P17/O19 task-doc-outcome | ● | ● | ● | ● | ○ | ● | ● | ○ | · | · |
| K1 llm-wiki-graph | ● | ● | ● | ◐ | ◐ | ● | ○† | ● | ◐ | ○† |
| K2 capture-rule | ● | ● | ● | ◐ | ◐ | ● | ○† | ● | ● | ○† |
| K3 decision-nodes | ● | ● | ○ | ● | · | ● | · | · | ◐ | · |
| K4 runbooks-prefer-scripts | ● | ● | ● | · | · | ◐ | · | ● | · | · |
| K6 mirror-critical-rules | ◐ | ● | ● | ● | ● | ● | · | ● | ● | · |
| K7 orient-before-acting | ● | ● | ● | ● | ● | ● | ● | ● | ● | ◐ |
| T1/T2/T6–T10 tdd-mechanics cluster | · | ● | ● | ● | ◐ | · | · | · | · | · |
| T3 outside-in | ◐ | ● | ● | ● | · | · | ● | · | · | · |
| T4/PD4 user-need-evidence | ● | ● | ·‡ | ● | ◐ | · | · | · | ● | · |
| T5 repro-bug-failing-test | · | ● | ● | ● | · | ● | · | · | · | · |
| T11/O29 spikes | ◐ | ● | ·‡ | ● | · | · | · | · | ◐ | · |
| T12 operator-seam | ● | ● | · | ● | ● | ◐ | ● | ◐ | ◐ | · |
| T13 one-seam-two-operators | ● | ● | · | ● | · | · | · | · | · | · |
| T14 extend-not-parallel | ● | ● | · | ● | · | · | · | · | · | · |
| T15 tiers-not-merged | ● | ● | ◐ | ● | ● | ◐ | ● | ◐ | · | · |
| T16 seam-is-architectural | ● | ● | · | ● | · | · | · | · | · | · |
| T17 selectors-not-coordinates | · | ◐ | ● | · | ● | · | ◐ | · | · | · |
| T21 lookbook-analogue | ● | · | · | · | · | · | · | · | ● | · |
| O2/A4 draft-vs-ratify | ● | · | · | ● | · | · | · | · | · | · |
| O7 transcript-inspector | ● | · | · | · | · | · | · | · | · | ● |
| O9 diagnose-or-fix | ● | · | · | · | · | ● | ● | · | · | · |
| O10/R3 unprimed/distrust-narration | ● | · | · | · | ● | · | ○† | · | · | · |
| O28 assert-action-happened | ● | ● | ◐ | ● | · | · | ● | · | · | · |
| O31/AN3 testimony-not-evidence | ● | · | · | · | · | · | · | · | · | ● |
| O37 escalation-defined | · | ● | ● | ● | ○† | ● | ● | ● | ● | ● |
| O38 lane-asymmetry | · | ● | ● | ◐ | · | · | · | · | · | · |
| P16 backwards-compat | · | ● | ● | ◐ | · | · | · | · | · | · |
| PD3 personas | ● | · | · | · | · | · | · | · | ● | · |
| PD5 traceability-hierarchy | ● | · | · | · | · | · | · | · | ◐ | · |
| R6 crisp-verdicts | · | · | · | · | ● | · | ● | · | ● | · |
| V5 absence-is-a-finding | ● | · | · | ● | · | ● | ● | · | ● | · |
| A1 entity-model-highest-stakes | ● | ◐ | · | ● | ◐ | · | · | · | ● | · |

**Gap flags in the matrix, summarised:** CR task-doc line (O19); EM commit discipline (P12) + assumptions note (P14) + task-doc line; FW decision-node sentence (K3, undocumented); VER/AA knowledge-capture (K1/K2, plausibly deliberate but undocumented); CR escalation section (O37, defensible); brief/VER behavioural-authority (P11, debatable); VER receiver-side unprimed defence (O10, minor).

## 3. Per-opinion stay / go / adjust

Recommendations only — the maintainer and main agent make the calls. Full reasoning inline in each entry above; this table is the roll-up.

**Adjust (7):**

| Opinion | Recommendation |
|---|---|
| O5 steer-resume-vs-fresh | Collapse one of the brief's two near-equal statements to a cross-ref clause — within-file redundancy, not designed duplication |
| O19 plans-as-task-docs | Add the record-your-verdict task-doc line to CR (all five executing peers have it); decide EM deliberately |
| P11 behavioural-authority | Attach a one-line why to the precedence block (one sync edit, five homes) — the sole wide duplicate that is rationale-bare everywhere; treat B/VER coverage as a register decision |
| P12 commit-before-reporting | Add commit discipline to EM — it writes scripts but nothing says they must land in git before reporting |
| K1/K2 knowledge-capture (VER, AA) | Document the deliberate omission, or add a one-line "report knowledge for capture; you don't write the graph" clause — don't bolt on full capture sections |
| K3 decision-nodes (FW) | Restore the sentence or document the calibration — currently the only *undocumented* divergence in a designed-duplicate family |
| T18 proportionality / R4 judging-discipline | Consider-tier: candidates to widen (second-consumer rule toward SE/CTO; consensus-audit toward the brief's ratification flow) — register decisions, not urgent |

**Go (0):** No opinion earned a removal recommendation. Every extracted opinion traces to an attached (or skill/wiki-housed) rationale, none is contradicted elsewhere in the corpus, and the harness-coupled ones (O4, O6, V6, O14) are correctly conditionalised — they need *re-verification cadence* (per the repo's optimise-for-current-harness goal), not removal.

**Stay (all others):** All remaining entries — including every designed duplication (P1, P2, P9, T4/PD4, T12, O28 are the exemplars) — carry documented rationale, consistent substance across homes, and role-correct calibration.

## 4. Seeds for the opinion register (task 10)

- The register should record, per opinion: slug, canonical statement, home list with verbatim/calibrated/altitude markers, the rationale's canonical home, and any *documented* calibrations (so C1-class silent divergence becomes checkable — a checksum-or-register discipline generalising the runbook's TDD awk check).
- Mark harness-pinned opinions (O4, O6, V6, O14) for re-verification on harness change.
- Name the convergent families that share no wording but are one stance (V5 absence-is-a-finding; R6 crisp-verdicts; O38 lane-asymmetry) — these are invisible to grep and only a register keeps them coherent.
