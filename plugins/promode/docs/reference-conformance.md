# Reference conformance: reference screens are the visual truth

Routed mechanics doc — consuming agent defs direct a read of this file when a dispatch involves curating or mirroring design reference screens, building or running a visual conformance gate, reconciling a design-system/token doc, governing copy voice, triaging generated design/copy output for machine defaults (anti-slop), or wiring preview/render services for visual work. (Supersedes `design-system-lookbook.md` + `live-reload-server.md`, 2026-07 — decision node: `docs/decisions/2026-07-reference-conformance.md`.)

<objective>
Promode runs a fast feedback loop for *logic*: the headless operator seam gives an agent a deterministic pass/fail signal, and the discovery⇄determinism flywheel crystallises judgement into checks (`discovery-to-determinism.md`, beside this doc). This doc is the visual analogue — and its load-bearing move is where the truth lives:

**Reference screens are the truth for layout, styling, and copy.** Design is *decided* in reference artboards, in a real design venue (claude.ai/design today — venue ⚙, re-verify on ecosystem change), mirrored deterministically into the repo, and *enforced* by a conformance gate that scores implemented screens against them. The mapping to the logic loop: references ≈ the executable spec, the mirror ≈ the crystallised map, the gate ≈ the test runner. Taste is decided once, in the references, and replayed deterministically — never re-decided ad hoc per session, and never fabricated (a hex here, a spacing value there) by an agent working from prose.

What this *replaces*: the previous doctrine made a repo-maintained token doc (`DESIGN_SYSTEM.md`) the source of truth, rendered by a lookbook, with a live-refresh loop as the feedback signal. That inverted the real authority — designers (human or agent) decide in screens, not in YAML — and left conformance to eyeballing. The token doc survives, demoted (below); the lookbook does not — the mirrored references *are* the rendered truth, and curated screenshots live inside the mirror.
</objective>

<references-are-truth>
Every product area keeps its reference screens in the design venue; an implementation is *correct* when it conforms to its reference — layout, styling, **and copy** (copy is design: the words on a reference are as normative as its spacing). Disagreement with a reference is settled by changing the reference (a design decision, made in the venue), never by quietly shipping the divergence.
</references-are-truth>

<token-doc-advisory>
**`docs/product/DESIGN_SYSTEM.md` is demoted to advisory.** It is reconciled **up** from the references — a derived summary of the tokens and rationale the references exhibit — so it *lags by design* and **never gates**: no check fails because an implementation disagrees with the token doc; checks fail against references. Its value is orientation (an agent skimming tokens and the *why* behind them before touching visual code) — worth keeping current, never worth trusting over a reference.

**Ecosystem note — recognise and demote.** The community convention (Google Labs' `design.md` spec, VoltAgent's variant) puts a normative `DESIGN.md` at the repo root. Recognise it when you meet it: it is this doctrine's *advisory predecessor*. Don't delete it — reconcile it under the references (fold it into the advisory `docs/product/DESIGN_SYSTEM.md`, linked from `CLAUDE.md`) and strip it of gate authority. A token doc that gates is the drift bug this doctrine exists to kill: two truths, and the cheaper-to-edit one wins.
</token-doc-advisory>

<per-area-mirror>
References reach the repo through a **deterministic per-area mirror**: a CLI sync, etag-guarded (fetch only what changed), landing under `docs/product/references/<area>/`. Two hard rules:

- **No LLM anywhere in the transport.** The mirror is dumb, deterministic plumbing — an agent judging, resizing, "cleaning up", or summarising in the sync path turns the truth channel into a game of telephone.
- **The mirror is never hand-edited.** It is a cache of the venue's state; fixing a mirrored file instead of the venue reference forks the truth.

Curated screenshots (real-product inspiration, pre-system reference material) live *inside* the mirror as ordinary reference content — they need no separate lookbook artifact.
</per-area-mirror>

<conformance-gate>
Implemented screens are scored against their references by a deterministic gate producing a **Design Fidelity Score**: content-cropped, text-masked pixel diff plus ΔE2000 perceptual colour difference, with **named profiles** (`strict` | `dev` | `lenient`) so the required fidelity is a declared, reviewable choice — and a **per-screen contact sheet** (reference / render / diff side by side) so a failure is judged in seconds, not re-investigated.

The gate consumes **deterministic offline renders** — pinned viewport, fonts, and data — never a live preview (see below).

**Promode ships no gate implementation.** The gate is per-project, built by the engineer lane **test-first** like any other production code. Tool names here are swappable defaults, not doctrine: Playwright for renders, pixelmatch for the diff — replace freely per stack; the doctrine is the score's shape and determinism, not the tools.
</conformance-gate>

<two-guards>
Two failure modes, two **separate** guards — never merged into one check, because they ask different questions of different people:

- **Drift sign-off ledger** (`design-pins.lock.json`) — records which reference version each implemented screen was approved against. Answers "has *our approval* gone stale?" A reference change flips its screens to needing re-approval; signing off is a deliberate act, not a side effect of a green sync.
- **Sync etag guard** — answers "has the *mirror* fallen behind the venue?" Purely mechanical freshness; no judgement content.

Merging them is the classic error: a sync that auto-blesses new references destroys the ledger's meaning, and a ledger that blocks syncing hides upstream movement.
</two-guards>

<preview-out-of-gate-path>
**Live preview serves iteration; the gate consumes deterministic offline renders. Keep the paths separate.** An edit→see-instantly loop (the project's own dev server / HMR) is the right signal while *working*; it is never evidence. Wiring preview output into verification imports its nondeterminism (timing, fonts, live data) into the gate and trains everyone to distrust red. The previously shipped static live-reload server (`live-reload-server.md`) is retired **without successor** — use the project's dev server; a project with none can spin up any static server, which is not doctrine worth carrying.
</preview-out-of-gate-path>

<copy-is-design>
Copy voice is governed, not improvised: **`docs/product/VOCABULARY.md`** owns the project's voice — canonical terms, tone rules — and reference copy is truth exactly as reference layout is. An implementation that "improves" the words has diverged from the design as surely as one that moved the button.
</copy-is-design>

<boundary-with-frontend-design>
**The boundary with `frontend-design` is decided-vs-default triage, not structure-vs-taste.** Anthropic's `frontend-design` skill generates aesthetic direction; this doc governs what that output must clear before it becomes truth. Every element of a candidate reference — layout, type, colour, motion, spacing, copy voice — is triaged **decided vs default**, and only decided elements enter a reference. AI slop is a machine default nobody chose (PD12 `decisions-not-defaults`), and the failure mode this triage exists for sits upstream: **the conformance gate replays whatever the reference contains, so an undecided reference crystallises slop and enforces it forever.** Unchosen minimalism counts — stripping to the model's tasteful-safe house style is the newest default, not a decision. Dispatch to `frontend-design` for generation; decide, then capture the result in the references, where the mirror and gate replay it deterministically.

**Time-bound orientation (dated 2026-07; tells drift with model generations — treat as orientation, never doctrine):** `github.com/yetone/kill-ai-slop` catalogues the current machine-default tells in visual style and copy voice. It is **unlicensed — read it, never vendor it.** Projects crystallise their *own* dated tell-scan — a grep over the repo's copy for the patterns `VOCABULARY.md` bans — **detection-only, never auto-fix** (an auto-fixer swaps one undecided output for another). This paragraph is the catalog's single home in the promode corpus (K5): defs carry the discipline, never the tells.
</boundary-with-frontend-design>

<who-does-what>
- **`senior-product-designer`** — curates the references per area, reconciles `DESIGN_SYSTEM.md` up from them, owns `VOCABULARY.md`.
- **Engineer lane** (dispatched by the main agent) — builds the mirror CLI and the conformance gate, test-first.
- **`environment-manager`** — runs the mirror sync and any preview server as managed dev services; keeps the preview out of the gate path.
- **`verifier`** — judges visual conformance from the gate's output (score, profiles, contact sheet) against the mirror; a missing gate or mirror is a *finding*, not a licence to eyeball.
- **`auditor`** — assesses the whole loop as the "Design references & visual conformance" dimension.
</who-does-what>
