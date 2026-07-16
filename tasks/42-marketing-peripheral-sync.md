# Peripheral sync: brief + README for the marketing lane

## Brief
- **Orient** — `plugins/promode/PROMODE_MAIN_AGENT.md` (the brief; note the `<!-- CHUNK -->` mechanics), `plugins/promode/hooks/hooks.json`, `scripts/check-hooks.sh`, README (agents table + opinions map). Precedent: `tasks/25-peripheral-sync.md`. The committed register state from task 41 is the source of truth.
- **Specify** — one consistent brief+README pass:
  - **Brief** — `<delegation-map>`: add the CMO line (crucial hard-to-reverse *marketing* one-way doors → `promode:chief-marketing-officer`, inherit, drafts for ratification) and the senior-marketer line (marketing execution, opus/high); adjust the CPO line for the carve. `<product-considerations>` (or a sibling marketing block if it reads better — smallest change wins): route marketing one-way doors to CMO, execution to senior-marketer. `<model-tiers>`: CMO joins the inherit-seats list + the informed-tier-consent trigger list (O39). `<feature-knowledge-base>`: one sentence making the marketing layer's knit concrete (marketing docs in `docs/marketing/` cite goals + personas) — only if it earns its words; the hierarchy sentence already names marketing.
  - **README** — agents table rows for CMO + senior-marketer; "The opinions" human map gains the MK section pointer; recommended-settings untouched.
  - **Gates** — `scripts/check-hooks.sh` and `scripts/check-claude-md-imports.sh` green after edits; if brief growth crosses a 10k chunk cap, split at a section boundary AND register the new chunk in `hooks.json` per M4/CM rules — never demote a principle to a pointer.
- **Why** — the brief is the main agent's only delivery surface for routing decisions (M2); an unrouted seat is dead weight, and a silently-truncated brief is worse than an unedited one (hence the gates).
- **Verified vs assumed** — assumed register (33) is final; divergence found while syncing is a finding to report, not fix inline.
- **Not / exit** — do NOT edit the register, defs, or decision nodes. Exit: brief + README committed, both check scripts shown green in the report + Outcome.

## State
- **Established facts** — chained on task 41.

## Outcome
Done. One consistent brief + README pass syncing the marketing lane to the peripheral homes, per the post-task-33 register (source of truth).

**Brief (`PROMODE_MAIN_AGENT.md`):**
- `<role>` (chunk 1): added CMO to the C-suite cross-ref ("crucial marketing one-way doors to `chief-marketing-officer`"), "both draft" → "all draft" — no enumeration (task-37 dedup honoured; canonical scopes stay in `<delegation-map>`).
- `<delegation-map>` (chunk 1): extended the single canonical C-suite enumeration — carved `positioning, growth strategy` OUT of the CPO line, added the Marketing line (CMO one-way doors: positioning & messaging, brand/category, channel portfolio, growth strategy w/ the joint-CPO **parallel, each unprimed** rule, launch strategy, marketing-plan artifact, pricing presentation/packaging → CMO inherit; execution: campaigns/ads/copy/email/SEO-AI-search/launches/VOC → senior-marketer opus/high, routes one-way doors up, visual/brand via SPD lookbook, code to engineers). No second enumeration introduced.
- `<model-tiers>` (chunk 2): CMO joined the inherit-seats list ("two C-suite" → "three"; added "marketing → CMO"); O39 informed-tier-consent trigger list now names CMO + "marketing-strategy one-way-door call", and CTO/CPO → CTO/CPO/CMO in the escalation-path clause.
- `<feature-knowledge-base>` (chunk 3): one sentence making the marketing layer concrete — strategy nodes in `docs/marketing/` (CMO-owned) cite goals + personas, never fork; a marketing move tracing to no goal is the same red flag as a feature with none (serves PD5/K8/PD6-fourth-guise).
- `<product-considerations>` (chunk 4): added a "Marketing routes the same way" paragraph routing one-way doors → CMO (canonical list cross-ref to `<delegation-map>`, joint-growth parallel-unprimed) and execution → senior-marketer, grounded in `docs/marketing/`.

**README:** carved the CPO agents-table row (dropped `positioning, growth strategy` to match the brief carve — kept table self-consistent), added CMO + `senior-marketer` rows matching existing voice; added a "Marketing is a first-class lane with an owner" bullet to "The opinions" map pointing at the register's Marketing section.

**Gates:** `scripts/check-hooks.sh` green before AND after; `check-claude-md-imports.sh` green. Chunk payloads (additionalContext, vs 10k cap) — baseline 8800/6825/6661/8375/8369; after 9199/6724/6763/8776/8110 (raw wc -c 9558/6939/6956/8987/8369). All under cap → no split, `hooks.json` unchanged (still 5 chunks).

**Decisions/notes:** (1) Carved the CPO README row for table consistency even though the task named only "add CMO+SM rows" — leaving `positioning, growth strategy` on CPO would contradict the new CMO row in the same table. (2) Chunk 1 is the tight one (9199 payload, ~800 headroom); left un-split per minimal-diff since it's under cap.

**Not verified / assumptions:** treated the committed register (task 41/43 state) as final per the brief; did NOT re-derive register correctness. No register divergence found while syncing (O2/O13/O39/PD5/PD9/K8 B-cited homes matched what I wrote). Gates are the only verification run — no runtime/agent-dispatch check of the brief's live delivery.
