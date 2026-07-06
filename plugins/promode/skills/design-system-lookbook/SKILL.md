---
name: design-system-lookbook
description: "Establish a design source-of-truth (a DESIGN.md-style two-layer doc of tokens + rationale), build a lookbook that renders it, and wire a live-refresh preview server so visual work gets a fast edit→see feedback loop. Use when setting up or restructuring a design system / design tokens, creating a DESIGN.md or design source-of-truth, building a lookbook, or wanting live preview / live reload of design or marketing artifacts — landing pages, decks, one-pagers, marketing material previews."
---

<objective>
Promode runs a fast feedback loop for *logic*: the headless operator seam gives an agent a deterministic pass/fail signal, and the discovery⇄determinism flywheel crystallises judgement into checks (see `discovery-to-determinism`). Visual/design work has no such loop by default — only an ad-hoc screenshot diff.

This skill extends the **same principle to visual work**. Three artifacts, each the visual analogue of a logic-testing artifact:

| Logic loop | Visual loop |
|---|---|
| Feature tests / specs | **Design source-of-truth** (`DESIGN_SYSTEM.md`) |
| Headless client exercising the seam | **Lookbook** rendering the tokens |
| Fast test runner | **Live-refresh preview server** |

The source-of-truth is to UI what feature-tests are to logic — the persistent, normative reference that kills drift. The live-refresh lookbook is to design what the fast test runner is to code — the instant signal that makes iteration cheap. Together they **crystallise *taste* into *determinism***: capture an aesthetic decision once, replay it deterministically across every prompt and session.

This skill owns **structure & process**. It explicitly defers **aesthetic taste** — what good typography, color, and motion actually *look* like — to the `frontend-design` skill.
</objective>

<the-source-of-truth>
**The problem it solves.** An LLM makes inconsistent visual decisions across prompts and sessions — it drifts, and it fabricates tokens (a hex code here, a spacing value there) that were never decided. The fix is a persistent, repo-level reference the agent reads before any visual work. The community converged on this in 2026 (Google Labs' open-source `design.md` alpha spec; VoltAgent's parallel 9-section convention); the proven shape is **two layers in one file**:

- **YAML front-matter = machine-readable design tokens** — the normative *what*. Exact hex codes, the typography scale, spacing, border-radius, elevation. An agent (or a build step) reads these as data; they leave no room to fabricate.
- **Markdown body = `##` sections of human-readable rationale** — the *why*. For the judgement calls and off-system edge cases that tokens can't enumerate ("use the warning color only for destructive, irreversible actions — never for mere emphasis").

**Keep token, rule, AND rationale in one file.** A Figma export gives you the *what* but drops the *why* — and the *why* is exactly what an agent needs to make a consistent call on a case the tokens don't cover.

**Recommended sections** (ordered, from Google's spec — present this as *the* structure, not a menu):

1. **Overview** — what the product is, the design intent in a sentence or two
2. **Colors** — palette with exact tokens, semantic roles (primary/surface/danger…)
3. **Typography** — families, the scale, weights, line-heights
4. **Layout** — grid, spacing scale, breakpoints
5. **Elevation & Depth** — shadow/z tokens and when each applies
6. **Shapes** — border-radius scale, corner conventions
7. **Components** — per-component token bindings and variants
8. **Do's and Don'ts** — the rationale that tokens can't encode

(VoltAgent's richer variant adds *Visual Theme & Atmosphere*, *Responsive Behavior*, and an *Agent Prompt Guide* — fold those in only if the product genuinely needs them; start with the eight above.)
</the-source-of-truth>

<where-it-lives-in-promode>
**This is promode's divergence from the community convention — load-bearing.** The community calls the file `DESIGN.md` at the repo root. **In promode it is `docs/product/DESIGN_SYSTEM.md`** — the existing file the `product-design-expert` agent already maintains — restructured into the two-layer format above and framed as "promode's `DESIGN.md`." It is a **node in the agent-knowledge graph, linked from `CLAUDE.md`**. Explicitly **not** a project-root `DESIGN.md`, and **not** inlined into `CLAUDE.md`.

Why placement matters:
- **Promode's discipline is "link from `CLAUDE.md`, don't proliferate root files / don't bloat the always-loaded root."** A design system is a cohesive body that lives as a subtree under `docs/product/` (alongside `PERSONAS.md`, `DECISIONS.md`), reachable from the root — not scattered, not crammed into the launchpad.
- **Verified research caveat:** coding agents do **not** auto-load arbitrary root `.md` files — only `CLAUDE.md` is auto-loaded. So a root `DESIGN.md` would need an explicit link from `CLAUDE.md` *anyway*. Reaching it on-demand through the graph is strictly better than a root file that's neither auto-loaded nor on-demand discoverable.

Recognise the name `DESIGN.md` (it's what the ecosystem says); place it at `docs/product/DESIGN_SYSTEM.md`.
</where-it-lives-in-promode>

<the-lookbook>
The **lookbook** is the rendered visual reference — the source-of-truth made visible. It **traces up** to the design source-of-truth exactly as tests trace to specs: every swatch, type sample, and component state is the tokens, rendered. Two valid flavours:

- **Living lookbook** *(preferred where a component system exists)* — renders the project's **actual** components and key screen states against the tokens (Storybook-like, but lightweight). Because it imports the real components, it **can't drift** from the real UI; a token change or a component change shows up immediately.
- **Reference lookbook** *(before a component system exists)* — curated real-design screenshots, each tagged with its layout pattern, color tokens, typography, and composition. Used as inspiration/target while building toward the system.

**Location:** `docs/product/lookbook/` with an `index.html` entry — a node in the graph, linked from the design source-of-truth and `CLAUDE.md`.
</the-lookbook>

<the-live-refresh-loop>
**Principle.** Design *and* marketing artifacts — the lookbook, landing-page proposals, decks, one-pagers — need an **edit file → browser updates instantly** loop. That is the fast feedback signal for visual work, and it is what powers the agent's screenshot-diff verification: Anthropic's sanctioned loop is *paste the design target → screenshot the rendered output → list the diffs → fix → repeat*. Without instant refresh, every iteration pays a manual reload tax.

**Mechanics.** A static file server that **watches** the artifact files and **pushes a reload** to the browser over SSE (or websocket) on change. Small, framework-agnostic, dependency-light — see [`references/live-reload-server.md`](references/live-reload-server.md) for a copy-pasteable ~60-line Node implementation plus the browser client snippet.

**CRITICAL NUANCE — don't build a second dev server.** If the project's stack already has HMR / live-reload (Vite, Next, etc.), **use that.** The reference implementation is for **static HTML artifacts** — lookbooks, decks, landing pages — that have *no* dev server of their own. Reach for it only there.

**Who runs it in promode:**
- **`environment-manager`** owns the preview server as a **managed dev service** (starts it, keeps it healthy, reports its URL).
- **`senior-engineer`** builds the lookbook and any static artifacts from the reference, test-first where there's logic to test (mechanical assembly can go to **`fast-worker`**).
- **`verifier`** screenshots the rendered output **against the lookbook / source-of-truth** as the visual acceptance check.
</the-live-refresh-loop>

<boundary-with-frontend-design>
This skill = **structure & process** (the source-of-truth, the lookbook, the feedback loop). Anthropic's `frontend-design` skill = **aesthetic taste** (what good typography, color, and motion actually look like). **Dispatch to `frontend-design` for the taste; use this skill to capture that taste in the source-of-truth and replay it deterministically** through the lookbook and preview loop.
</boundary-with-frontend-design>

<success_criteria>
- A two-layer **design source-of-truth** exists at `docs/product/DESIGN_SYSTEM.md` — YAML token front-matter + `##` rationale sections — and is **linked from `CLAUDE.md`** (a graph node, not a root file, not inlined).
- A **lookbook** at `docs/product/lookbook/index.html` renders those tokens (living where a component system exists, reference otherwise) and **traces up** to the source-of-truth.
- A **live-refresh loop** gives visual work an instant edit→see signal — reusing the project's existing HMR if it has one, else the reference static server.
- Aesthetic taste was sourced from `frontend-design`, then **captured** in the source-of-truth so it replays deterministically — not re-decided ad hoc each session.
</success_criteria>

<references>
- [`references/live-reload-server.md`](references/live-reload-server.md) — copy-pasteable, dependency-light Node static server + file-watcher + SSE reload endpoint, plus the browser client snippet. For static HTML artifacts only (use the project's HMR if it has one).
</references>

<related>
- **`discovery-to-determinism`** — the logic-side flywheel and operator seam this skill is the visual analogue of.
- **`frontend-design`** (Anthropic) — aesthetic taste; the source of the decisions this skill captures.
- **`product-design-expert`** agent — maintains `docs/product/` (incl. the design source-of-truth) and traces design to personas/goals.
</related>
