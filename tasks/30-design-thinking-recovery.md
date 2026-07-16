# Task 30 — Design-thinking session recovery (master doc + recovery record)

## Brief
- **Orient** — this doc IS the spec: a recovery record distilled from the lost session's full claude.ai transcript. The corpus to change: `plugins/promode/docs/opinion-register.md`, `plugins/promode/docs/design-system-lookbook.md` + `live-reload-server.md` (both to be superseded), `plugins/promode/PROMODE_MAIN_AGENT.md` (§test-strategy), agent defs (SPD, VER, EM, AUD, CPO), `docs/decisions/`.
- **Specify** — reconstruct the three owner-ratified doctrine rounds below onto this branch (`gallant-mclaren-71e822`), as three round-commits via tasks 31 (rounds 2+3) and 32 (round 4), then a fresh unprimed review (task 33). Success: every recorded ratified fact honoured; guards green (`scripts/check-hooks.sh`, `scripts/check-claude-md-imports.sh`); M3 supersession discipline throughout.
- **Why** — the original branch was lost with the device; the *decisions* survived in the transcript. Reconstruction re-executes ratified decisions; it must NOT re-litigate them.
- **Verified vs assumed** — every quoted decision below is verbatim-sourced from the transcript (verified). Exact original prose of the applied edits is LOST (assumed): where the record under-specifies wording, compose in the corpus's existing register/style. The recorded "fifteen per-home edits" of round 2 is a count, not an enumeration — derive a coherent home set from the recorded facts.
- **Not / exit** — do not fake the lost audit trail (task docs 30–39 of the original branch are not recreated; decision nodes carry a reconstruction-provenance note instead). Exit: task 33 review APPROVED, board closed.

## State
- **Established facts** — recovery record below; local corpus is at pre-session state (T21/DOC-lookbook intact).
- **Open constraints** — provenance note in every reconstructed decision node: "Reconstructed 2026-07-16 from the session transcript (session_01GrFCMrJXRCos7saa5G2Dbf) after the original unpushed branch `claude/design-thinking-promode-2bc555` was lost with its device."
- **Pending goals** — task 31 → task 32 → task 33 → push/PR (user decides).

## Outcome
Closed 2026-07-16. All three ratified rounds reconstructed on this branch (commits `51105df`, `59e95fc`, `cbd53cd`); fresh unprimed review (task 33) returned **APPROVED, no blocking findings** (`3176326`), with guards re-run independently. The exact original prose remains unrecoverable by design — decision nodes carry the reconstruction-provenance note, and the lost cloud session (unarchived, still live on claude.ai) can later serve as a diff oracle if the CLI is re-authed and teleport becomes possible. Two reviewer bookkeeping findings corrected at closure (chunk-4 size narration slips in tasks 31/32). Parked follow-ups re-recorded below (§Pending work) remain open: perception-gap/memorability check, voice-before-visuals, derived design-system kit.

---

# Recovery record — session_01GrFCMrJXRCos7saa5G2Dbf ("Design thinking in ProMode methodology")

Recovered 2026-07-16 from the shared claude.ai transcript (device that hosted the session died).
Session URL: https://claude.ai/code/session_01GrFCMrJXRCos7saa5G2Dbf

## Branch state at session death

Branch: `claude/design-thinking-promode-2bc555` — **unpushed, exists neither locally nor on GitHub**.
Known commits (in order, from the transcript):

| commit | content |
|---|---|
| 84453b2 | CTO draft, task 30 (`tasks/30-reference-conformance-doctrine.md`) — lookbook → reference-conformance doctrine |
| fb85ec1 | task docs 31–32 + board cards |
| 544523d | Applied swap: new `reference-conformance.md` (incl. DESIGN.md recognise-and-demote note) + decision node (6 rejected alternatives), 15 per-home edits, register T23–T29 replacing T21/DOC-lookbook (superseded in place), both lookbook docs deleted; check-hooks green (brief chunk 4 at 8,871/10,000) |
| 2043746 | T24 homes-column fix (adds B) + board/DONE closure of tasks 31–32 |
| bf7df48 | CPO draft, task 34 (`tasks/34-anti-slop-doctrine.md`) — PD12 anti-slop doctrine |
| 6246843 | task docs 35–36 + board cards |
| 5813240 | Applied PD12 edits (register row, SPD `<decisions-not-defaults>` block + copy governance, auditor items 5–6, refcon boundary rewrite, decision node w/ 7 rejected alternatives) |
| f51cd87 | Split-out leftover: task-32 reviewer's Outcome write |
| (unnamed) | Board/DONE closure of tasks 35–36 ("nine commits total" at that point) |
| f5a7fae | CTO revision draft, task 37 (`tasks/37-refcon-methodological-thinning.md`) — refcon thinned to storage-agnostic methodology |

## Where the session stopped

The user ratified task 37 ("Ok, sounds good") **plus a probe-record amendment** (see below). The session died before dispatching the apply/review chain (**tasks 38/39 — never run**).

## What each round decided (ratified content)

### Round 1 — design-thinking video (no corpus change)
Video was Satori Graphics visual-design mindsets, not d.school design thinking. Parked follow-ups (recorded in task 30): perception-gap/sequence-recall verification, voice-before-visuals, PD3 anti-persona sharpening ("admiring peer-designer" as visual-work anti-persona). Rejected: "AI cannot touch this" framing.

### Round 2 — lookbook → reference-conformance (tasks 30–32, ratified + applied + APPROVED)
Modeled on overlay-mono's direction:
- T23 `reference-screens-are-truth` ⚙ — reference artboards (claude.ai/design) are truth for layout/styling/copy
- T24 `token-doc-advisory` — DESIGN_SYSTEM.md demoted: reconciled UP from references, lags by design, never gates (homes incl. B)
- T25 `per-area-mirror` — area model, deterministic CLI mirror (etag-guarded, no LLM in transport)
- T26 `conformance-gate-scoring-diff` — Design Fidelity Score: content-cropped, text-masked pixel-diff + ΔE2000, named strict|dev|lenient profiles, per-screen contact sheet
- T27 `two-separated-guards` — drift sign-off ledger (design-pins.lock.json) vs sync etag guard
- T28 `preview-out-of-gate-path` — live preview for iteration; gates consume deterministic renders; `live-reload-server.md` deleted, no successor
- T29 `copy-is-design` — copy voice governed via VOCABULARY.md
- New routed doc `reference-conformance.md` (replaces `design-system-lookbook.md`); ecosystem DESIGN.md convention recognised-and-demoted (advisory predecessor, reconcile under references)
- Promode ships no gate implementation; per-project engineer-built test-first. Tool names (Playwright, pixelmatch) live only in the routed doc as swappable defaults.

### Round 3 — anti-slop / PD12 (tasks 34–36, ratified + applied + APPROVED zero findings)
From github.com/yetone/kill-ai-slop (unlicensed — read, never vendor):
- PD12 `decisions-not-defaults` — every element of a shipped visual/copy artifact is a decision someone can defend; AI slop is the absence of one (a machine default nobody chose); framed as PD2's generative twin; unchosen-minimalism clause (stripping to the model's tasteful-safe house style is the newest default, not a decision)
- SPD: `<decisions-not-defaults>` authoring block; red flag: "defended as 'that's what it generated'"; VOCABULARY.md owns dated per-project banned machine-voice patterns (copy tells ride T29, no new row)
- Auditor refcon check items 5–6 — incl. "are the references themselves decided?" (the gate replays whatever the reference contains — undecided reference crystallises slop and enforces it forever)
- refcon frontend-design boundary rewritten around decided-vs-default triage; kill-ai-slop catalog cited in exactly one home as time-bound orientation
- No upstream-scanner recommendation (no license, 2 days old, Tailwind-specific); projects crystallise their own dated grep tell-scan, detection-only, never auto-fix
- No brief edit (PD9 routing already covers). Memorability stays parked: PD12 asks "who chose this?", never "is this memorable?"

### Round 4 — refcon methodological thinning (task 37, RATIFIED, NOT APPLIED)
Owner correction: rounds 2's doctrine hardcoded overlay-mono's storage topology. Ratified as drafted **plus probe-record amendment**:
- New doctrinal spine: product design docs (personas, feature definitions, Gherkin scenarios) → reference screens → deterministic comparison gate with calibrated tolerance. Upstream link = one clause on T23 (scenario names behaviour, reference names appearance, both trace to the same feature; "visual orphan" finding)
- Venue-agnosticism as three minimum properties (replaces mirror/sync doctrine): (1) discoverable/addressable from the knowledge graph (screen names its governing reference + version), (2) deterministically obtainable at an exact version (no LLM in any transport), (3) movement is observable
- Row fates: T25, T27 demoted in place to explicitly-conditional hosting patterns (slugs kept; strikethrough reserved for abolished concepts). Storage-agnostic core of T27 extracted as new **T30 `approvals-pin-reference-version`** — sign-offs record the exact reference version judged against; movement flips screens to stale-approval; re-baseline is deliberate
- T26: tolerance first-class — false negatives from font rasterisation/AA/platform rendering are the gate's characteristic failure mode (over-strict gate trains bypass); leeway engineered (masking, perceptual metrics, named profiles), never eyeball/verdict-softening
- Wording fix everywhere: "deterministic offline renders" → "deterministic, version-pinned renders"
- **Probe-record amendment** (from the main session's live DesignSync schema read): DesignSync manages claude.ai/design projects through the user's login; list/read (list_files, get_file), plan-gated incremental writes; (a) cloud-resident references addressable/fetchable by project+path — no local sync need exist; (b) no per-file version/etag parameter visible, so T30's pinning must be honest that some venues offer only coarse movement signals; (c) tool exposed to main session but NOT subagents (⚙-flag, dated) — argument for "deterministically obtainable by some mechanical means the project wires", never naming a tool. Replaces the CTO's "not present in this environment" negative.

### Pending work at death
1. Task 38: verbatim apply of ratified task 37 + amendment (same pattern as 31/35)
2. Task 39: fresh unprimed review (same pattern as 32/36)
3. Push branch / open PR (user was offered, never done)

Parked follow-ups still open: perception-gap/memorability check, voice-before-visuals, derived design-system kit.
