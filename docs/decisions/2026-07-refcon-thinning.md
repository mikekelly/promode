# Decided: refcon methodological thinning — storage-agnostic doctrine, T30

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Owner correction, ratified in the design-thinking session as drafted **plus the probe-record amendment below**; the session died before the apply/review chain ran, so this was ratified-unapplied work. Register: T23 (spine + venue-agnosticism clauses), T25/T27 (demoted in place), **T30 `approvals-pin-reference-version`** (new), T26 (tolerance first-class), T28 (wording). Revises [`2026-07-reference-conformance.md`](2026-07-reference-conformance.md) in place.

> **Reconstruction provenance:** Reconstructed 2026-07-16 from the session transcript (session_01GrFCMrJXRCos7saa5G2Dbf) after the original unpushed branch `claude/design-thinking-promode-2bc555` was lost with its device. The decisions below are verbatim-sourced from that transcript's recovery record (`tasks/34-design-thinking-recovery.md`); the prose is recomposed.

## What was decided

**The correction:** round 2's doctrine hardcoded overlay-mono's storage topology — the repo mirror, the sync transport, the etag guard, the drift lockfile. Those are one project's implementation choices, not methodology; a project with cloud-resident references (arguably DesignSync's intended model) couldn't follow half of it. The doctrine thins to what is storage-agnostic:

- **Doctrinal spine:** product design docs (personas, feature definitions, Gherkin scenarios) → reference screens → deterministic comparison gate with calibrated tolerance. The upstream link is **one clause on T23**, not a new row: the scenario names the *behaviour*, the reference names the *appearance*, both trace to the same feature — a reference nothing upstream explains is a **"visual orphan"** finding.
- **Venue-agnosticism as three minimum properties** (replaces the mirror/sync doctrine): (1) discoverable/addressable from the knowledge graph — each implemented screen names its governing reference + version; (2) deterministically obtainable at an exact version — **no LLM in any transport** (this rule survives venue-agnosticism explicitly, undiluted); (3) movement is observable.
- **Row fates:** T25 (per-area mirror) and T27 (two guards) **demoted in place** to explicitly-conditional hosting patterns — slugs kept. The storage-agnostic core of T27 is extracted as **T30 `approvals-pin-reference-version`**: sign-offs record the exact reference version judged against; reference movement flips affected screens to stale-approval; re-baseline is deliberate. Matters most cloud-resident, where a reference can move with no repo event.
- **T26 tolerance first-class:** false negatives from font rasterisation / anti-aliasing / platform rendering are the gate's characteristic failure mode — an over-strict gate trains everyone to bypass it. The leeway is *engineered* (masking, perceptual metrics, named profiles), never eyeball judgement or verdict-softening.
- **Wording fix everywhere:** "deterministic offline renders" → "deterministic, version-pinned renders" — a cloud-fetched pinned reference isn't offline, but it is deterministic; the pin is what matters.

## Revise-in-place vs formal supersession

The T23–T29 rows were **days old** at ratification, so they are revised **in place** rather than struck through and re-issued: the register's strikethrough convention stays reserved for **abolished concepts** (T21, PDE), and T25/T27's concepts aren't abolished — they're demoted to conditional patterns under kept slugs, each row naming this node so the demotion is never mistaken for the original stance (M3: the supersession record travels with the row).

## DesignSync probe record — dated 2026-07-10, ⚙ re-verify on any DesignSync/harness change

From the main session's live read of the DesignSync tool schema (DesignSync manages claude.ai/design projects through the user's login; list/read via `list_files`/`get_file`, plan-gated incremental writes). This **replaces** the CTO draft's earlier "not present in this environment" negative:

- **(a)** Cloud-resident references are directly **addressable and fetchable by project+path** — no local sync need exist for a project to satisfy the three properties.
- **(b)** The visible schema exposes **no per-file version/etag parameter** — so T30's pinning must be honest that some venues offer only **coarse movement signals**; pin an honest proxy (content checksum, dated snapshot), never invented precision.
- **(c)** The tool is exposed to the **main session but NOT to subagents** (⚙, dated) — an argument for phrasing property (2) as "deterministically obtainable by some mechanical means the project wires", **never naming a tool**: the agent that runs the gate may not hold the tool the main session holds.

## Decision log — rejected alternatives (durable reasons; don't re-suggest)

- **Formal supersession of T25/T27** (strikethrough + new slugs). Rejected: rows days old; strikethrough is reserved for abolished concepts, and these concepts survive as conditional patterns — see the revise-in-place ruling above.
- **Keeping the mirror as doctrine-with-exceptions.** Rejected — the core correction: mirror/sync/etag/lockfile are one project's storage topology; doctrine that half the venues can't follow isn't methodology, it's a ported implementation.
- **Naming DesignSync (or any tool) as the obtainment mechanism.** Rejected: probe fact (c) — the tool is main-session-only, and tools drift; the doctrine says "some mechanical means the project wires".
- **Weakening no-LLM-in-transport as part of the venue-agnostic rewrite.** Rejected explicitly: it survives as part of property (2), doctrine regardless of hosting.
