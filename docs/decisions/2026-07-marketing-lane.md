# Decided: the marketing lane — a CMO/SM agent pair + mined `mk-` doctrine (2026-07 marketing lane)

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Maintainer-ratified 2026-07-15 (lane shape) / 2026-07-16 (item-by-item MK ratification, `tasks/38-mk-opinion-candidates.md` RATIFICATION block).

**Status: ratified and implemented.** The defs + docs landed in tasks 39–40; the register sync landed in task 41 (this node's sibling). Unlike the roster-restructure node, this records a decision already true of the repo.

## What was decided

The **marketing layer of the PD5 traceability hierarchy** (goals → **marketing** → feature definitions → feature tests) had no owning agent. It gets a full lane, symmetric with engineering (CTO/SE/ME) and product (CPO/SPD):

- **`chief-marketing-officer`** — `model: inherit`, no effort field. Drafts the crucial, hard-to-reverse **marketing** one-way doors for main-agent ratification: positioning & messaging strategy, brand/category strategy, the channel portfolio, growth strategy, launch strategy, the marketing-plan artifact, and pricing *presentation*/packaging (pricing *level* stays CPO/CTO). Owns the marketing layer of PD5 — strategy nodes in `docs/marketing/` that **cite** goals and `docs/product/PERSONAS.md` personas, never fork copies. Same inherit + cost-ceiling rationale as CTO/CPO.
- **`senior-marketer`** — `model: opus`, `effort: high`. The execution rung: campaigns, ads/creative, copy & copy-editing, cold/outbound email, LP content, SEO/AI-search artifacts, launches at execution level, VOC research runs, recurring loops. Every artifact cites the strategy node + persona it serves, or the gap is the finding.
- **Per-domain mechanics** live in ten `plugins/promode/docs/marketing-*.md` routed docs reached by def-directed conditional reads — the specialism axis is **docs, not defs** (the engineer-lane pattern), the M5-compliant transposition of the source repo's SKILL.md/references split.

### The CPO carve (task 39)

Positioning, growth strategy, and channel strategy were **removed from the CPO remit** and moved to CMO. Boundary text runs both directions. **Growth is the shared seam:** a genuinely joint product+marketing growth call is drafted by CPO and CMO **in parallel, each unprimed by the other's answer**, then the main agent synthesises — mirroring the existing CTO↔CPO joint-call rule. CPO retains the goal hierarchy, persona establishment/major revision, kill/build, and the user-need claim side (PD4/A1).

### Three-tier treatment of the mined doctrine

92 candidates were mined from the source repo; ~57 became register `mk-` opinions, tiered:
1. **Tier 1 (name-only)** — a framework the pinned model reliably knows; the opinion wraps the bare name with when/which/why, carried inline (CMO decision altitude or SM `<house-doctrine>`).
2. **Tier 2 (routed-doc)** — a named system the model half-knows; the def carries the decision + a doc pointer, mechanics spelled out once in a `marketing-*.md` doc. (Tier 1-vs-2 doubt was resolved by **cold-probing the pinned model**, task 40 — `mk-orb-channels` upgraded to tier-1 substance, `mk-seven-sweeps`/`mk-guarantee-by-business-model`/`mk-hook-is-three-components` confirmed tier-2, `mk-define-before-automate` confirmed tier-1.)
3. **Tier 3 (spelled-out + currency)** — contradicts model priors or postdates training; full statement + why + verified-as-of + a re-verify trigger. Time-pinned platform behaviour is marked **`⌛` (market-pinned)** in the register — a distinct marker from `⚙` (harness-pinned) because it re-verifies against the live platform, not on a Claude Code change.

Five mined `kin:` flags resolved as **extensions of existing register items, never rival slugs**: `mk-marketing-context-file`→K7/K8, `mk-persona-proxy-ladder`→PD3, `mk-two-tier-loop-actions`→O11, `mk-expert-panel-scoring`→R4, `mk-agentic-stack-thesis`→M0. Time-pinned platform *payloads* (§4 Meta/Google/LinkedIn/budget-learning bundle, §8 engine mechanics) get **no per-payload register row** — one opinion, `mk-platform-doctrine-time-pinned`, replaces them and governs their dated doc sections.

### Platform payloads: link upstream, don't vendor (Decision A)

Perishable platform material lives in **dated sections that link the upstream source by URL** (`raw.githubusercontent.com/coreyhaines31/marketingskills/...`) and are fetched/currency-checked at use time, rather than vendoring full copies that rot. The durable era-level stances are stated plainly in the docs; the perishable numbers/settings are quarantined, dated, and link out.

### `mk-organic-before-paid` (Decision B)

Accepted with the maintainer's rationale travelling with the rule: getting organic right is a good foundation to build paid on anyway — paid then amplifies something proven rather than amplifying what's broken.

## Why

Full-lane symmetry: marketing one-way doors (a category you stake, a positioning the whole funnel inherits) are as expensive to unwind as an entity-model or a goal-hierarchy call, so they earn the same inherit-tier draft-for-ratification treatment. Housing the specialism mechanics in routed docs (not the def) keeps each def cold-readable and lets a fork keep/drop specialisms individually. The source repo (Corey Haines' marketing skills) is a coherent, opinionated practitioner corpus whose SKILL.md/references split maps cleanly onto promode's def/routed-doc altitude split — but it ships as *skills* (voluntary invocation, M5) and much of it is model-derivable tutorial (M1), so it is mined for opinions, not imported wholesale.

## Rejected alternatives (durable reasons — don't re-suggest)

- **(a) Execution rung only, no inherit seat.** Rejected: marketing one-way doors would then have no frontier-tier drafter — the exact asymmetry (a guardian sitting a tier below the artifact it guards) that the CPO split (task 23) was created to fix for product. Marketing deserves the same fix.
- **(b) CMO as a comms/copy agent only.** Rejected: too thin to justify inherit-tier tokens. The inherit seat is earned by the *strategic* one-way doors (positioning, channel portfolio, growth, category), not by copy — copy is SM/worker execution.
- **(c) Wholesale import of all ~47 source skills.** Rejected on M5 (skills are voluntary-invocation, non-determinate) **and** M1 (opinions-not-tutorials): ~35/47 are model-derivable frameworks or perishable tool/spec catalogs. The lane carries the ~57 opinions that survive the mine, not the tutorials.
- **(d) A sonnet marketing execution rung.** Rejected: the mechanical tail (bulk variant generation, directory/form submission, visual artifacts) is already covered by the existing roster — generic workers (fast/cheap), `gui-driver`, and SPD's lookbook loop — reached via SM's hand-off boundaries. A dedicated sonnet marketer would be a duplicate-config rung with no distinct body.
- **(e) Vendoring the platform payloads into the docs.** Rejected in favour of link-upstream + currency-check (Decision A): vendored platform tactics rot silently, and a dated copy invites acting on stale settings. Linking the source + mandating a live check keeps the rot visible and the currency the agent's responsibility.
- **(f) `mk-okf-protocol-bet` as a register opinion.** **Not ratified** — deferred to `IDEAS.md` (a v0.1 spec from June 2026 that nothing crawls yet; revisit if any AI engine starts reading OKF). The concrete, cheap, reversible agentic-buying items (`mk-machine-readable-for-buyer-agents`, `mk-allow-citation-bots`) *were* ratified.

## Provenance

Source: [github.com/coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) — MIT-licensed, Corey Haines. 16 skills read to full depth (SKILL.md + all `references/`), mined 2026-07-15 (`tasks/38-mk-opinion-candidates.md`). Mining ≠ endorsing: **every quantitative claim carried into the lane is the source repo's practitioner claim, unverified by us** — tier-3/⌛ items keep that status explicitly, and a load-bearing claim is currency-checked live before it's acted on.

## Verified vs assumed

- The lane shape, CPO carve, three-tier treatment, Decisions A/B, and the OKF deferral are **maintainer-ratified decisions** (2026-07-15/16), not harness facts — nothing here re-verifies on a harness change.
- `model: inherit` (CMO) and `model: opus` + `effort: high` (SM) rest on the harness facts in [`2026-07-effort-dispatch-constraint.md`](2026-07-effort-dispatch-constraint.md) — re-verify per that node.
- **Not independently verified:** the source repo's quantitative claims (reply-rate declines, %-of-ARR bands, 6–27× / 69% figures, etc.) — all carried as the repo's, unverified; and the cold-probe tier verdicts (task 40) were mildly primed for `mk-hook-is-three-components`.
