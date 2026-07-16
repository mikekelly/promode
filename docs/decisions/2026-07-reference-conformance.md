# Decided: lookbook → reference-conformance doctrine (T23–T29)

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Owner-ratified and fresh-review APPROVED in the design-thinking session; modeled on overlay-mono's direction. Register opinions: **T23–T29**, superseding **T21 `design-lookbook-analogue`** and **DOC-lookbook** in place. Doctrine home: [`plugins/promode/docs/reference-conformance.md`](../../plugins/promode/docs/reference-conformance.md).

> **Reconstruction provenance:** Reconstructed 2026-07-16 from the session transcript (session_01GrFCMrJXRCos7saa5G2Dbf) after the original unpushed branch `claude/design-thinking-promode-2bc555` was lost with its device. The decisions and rejected-alternative reasons below are verbatim-sourced from that transcript's recovery record (`tasks/34-design-thinking-recovery.md`); the prose is recomposed. Where an entry is recast from a recorded ratified stance rather than a verbatim "rejected: X" quote, it says so.

> **Revised in place by the round-4 thinning** ([`2026-07-refcon-thinning.md`](2026-07-refcon-thinning.md)): the storage topology this round hardcoded — per-area mirror, sync transport, etag guard, drift lockfile — was demoted to explicitly-conditional hosting patterns (T25/T27), with T27's storage-agnostic core extracted as T30 and "deterministic offline renders" corrected to "deterministic, version-pinned renders". The rest of the doctrine below (T23/T24/T26/T28/T29, the O16 inventory, the rejected alternatives) stands.

## What was decided

The visual truth moves out of a repo-maintained token doc and into **reference screens**:

- **T23 `reference-screens-are-truth` ⚙** — reference artboards (claude.ai/design today — venue ⚙) are the truth for layout, styling, and copy.
- **T24 `token-doc-advisory`** — `DESIGN_SYSTEM.md` demoted: reconciled UP from the references, lags by design, never gates (homes incl. B). The ecosystem's root-`DESIGN.md` convention is **recognised-and-demoted**: the advisory predecessor, reconciled under the references rather than deleted.
- **T25 `per-area-mirror`** — per-product-area model; a deterministic CLI mirror, etag-guarded, no LLM in the transport.
- **T26 `conformance-gate-scoring-diff`** — Design Fidelity Score: content-cropped, text-masked pixel diff + ΔE2000, named strict|dev|lenient profiles, per-screen contact sheet; consumes deterministic offline renders.
- **T27 `two-separated-guards`** — drift sign-off ledger (`design-pins.lock.json`) vs sync etag guard, never merged.
- **T28 `preview-out-of-gate-path`** — live preview for iteration; gates consume deterministic offline renders; `live-reload-server.md` deleted, **no successor**.
- **T29 `copy-is-design`** — copy voice governed via `VOCABULARY.md`.
- **Promode ships no gate implementation** — per-project, engineer-built, test-first. Tool names (Playwright, pixelmatch) live only in the routed doc as swappable defaults.
- New routed doc `reference-conformance.md` replaces `design-system-lookbook.md`; both old docs (`design-system-lookbook.md`, `live-reload-server.md`) deleted from live routing, rules inventoried below (O16).

## Decision log — rejected alternatives (durable reasons; don't re-suggest)

1. **Lookbook as a surviving fallback artifact** (keep `docs/product/lookbook/` alongside the references). Rejected: curated screenshots survive *inside the mirror* as ordinary reference content — a separate lookbook is a second rendered truth that drifts from the first.
2. **In-repo-only truth** (repo files stay the normative source; the venue is just where drafts happen). Rejected: the mirror already *is* the in-repo truth — deterministic, versioned, diffable; making a hand-maintained repo copy normative re-opens exactly the drift/fabricated-token failure the doctrine kills.
3. **Keeping the live-refresh loop wired into verification** (the lookbook doctrine had `verifier` screenshot the live-served page as the visual acceptance check). Retired as a recorded correction: the preview is an iteration signal, not evidence — gates consume deterministic offline renders; wiring the preview into the gate path imports nondeterminism and trains everyone to distrust red. *(Recast from the recorded "live-refresh-into-verification wiring retired" correction.)*
4. **Carrying the 8-section `DESIGN.md` structure forward** (Google-spec section list as *the* structure). Retired as a recorded correction: tutorial-grade (M1) — a normative section template for a doc that is no longer normative; the advisory token doc carries tokens + rationale without a mandated skeleton. *(Recast from the recorded "8-section DESIGN.md structure retired as tutorial-grade" correction.)*
5. **Shipping a gate implementation in the plugin.** Rejected: the gate is per-project production code that rides TDD in the project's own stack; a shipped harness would be a premature shared abstraction with one consumer and would freeze tool choices as doctrine. *(Recast from the recorded ratified stance "Promode ships no gate implementation; per-project engineer-built test-first".)*
6. **Mandating specific tools (Playwright, pixelmatch) as doctrine.** Rejected: tool names live only in the routed doc as swappable defaults — the doctrine is the score's shape (masked pixel diff + perceptual metric + named profiles + contact sheet) and its determinism, not any tool. *(Recast from the recorded ratified stance on tool names.)*

## O16 inventory — rules carried by the two deleted docs

Every distinct rule the cut prose carried, shown surviving in a named home or deliberately retired with its why.

| Rule (from `design-system-lookbook.md`) | Fate |
|---|---|
| Visual work needs a deterministic feedback loop analogous to the logic loop | Survives — refcon `<objective>`; T23–T26 |
| A persistent reference kills cross-session drift and fabricated tokens | Survives, relocated — the truth is now the mirrored references (T23/T25); the anti-fabrication rationale lives in refcon `<objective>` and the auditor check |
| Two-layer `DESIGN_SYSTEM.md` (tokens + rationale), keep token/rule/rationale together | Survives demoted — the token doc remains a tokens+rationale artifact, now advisory (T24, refcon `<token-doc-advisory>`, SPD `<your-docs>`) |
| 8 recommended sections (Google spec) / VoltAgent variant | **Retired** — tutorial-grade (M1) for a doc that is no longer normative (recorded correction; rejected alt 4) |
| Recognise the ecosystem `DESIGN.md` name; don't put it at repo root; graph node under `docs/product/`, linked from `CLAUDE.md`, never inlined | Survives sharpened — recognise-**and-demote** (refcon `<token-doc-advisory>`, T24); placement discipline unchanged (SPD `<your-docs>`, `<bootstrapping>`) |
| Root `.md` files aren't auto-loaded; only `CLAUDE.md` is | Survives — general knowledge-graph doctrine (wiki, K1); no longer needs restating in the visual doc |
| Lookbook renders the source-of-truth (living/reference flavours), traces up like tests to specs | **Superseded** — the mirrored references *are* the rendered truth; curated screenshots live inside the mirror (rejected alt 1) |
| Live-refresh edit→see loop is the fast signal for visual/marketing artifacts | Survives narrowed — preview serves *iteration only*, explicitly out of the gate path (T28, refcon `<preview-out-of-gate-path>`) |
| Don't build a second dev server — reuse the project's HMR | Survives — refcon `<preview-out-of-gate-path>` |
| Screenshot-diff verification against the lookbook (verifier) | **Superseded** — verification is gate-judged (Design Fidelity Score over deterministic offline renders), never preview/eyeball (T26/T28; VER's calibrated home; recorded correction, rejected alt 3) |
| Ownership: EM runs the preview server; SE builds artifacts test-first; mechanical assembly to ME | Survives adapted — EM runs mirror sync + preview as managed services (out of gate path); the gate/mirror build rides the engineer lane test-first (refcon `<who-does-what>`) |
| Boundary: structure/process here, aesthetic taste in `frontend-design` | Survives — refcon `<boundary-with-frontend-design>` |

| Rule (from `live-reload-server.md`) | Fate |
|---|---|
| The ~60-line Node SSE static server + injected client implementation | **Retired, no successor** — implementation prose, not doctrine; a project needing a static preview uses its own dev server or any off-the-shelf static server (T28) |
| SSE over websockets; injected not authored client; `fs.watch` caveats | **Retired with the implementation** — rationale specific to the deleted reference code |
| Dev-only: unauthenticated file server is not a production surface | Survives in spirit — the preview is iteration tooling outside the gate/verification path (T28); EM's environment-safety envelope (E1) already owns the exposure rule |
| EM runs it as a managed service; verifier screenshots against it | Ownership survives for the preview (EM, T28); the verifier half is **superseded** (gate-judged verification — see above) |
