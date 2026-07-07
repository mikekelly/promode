# Gherkin / feature-file style guidance in overlay-mono

_Extracted 2026-07-07 from `/Users/mike/code/overlay-mono` (read-only sweep, main tree). Source material for [tasks/15-gherkin-opinion.md](15-gherkin-opinion.md)._

## 1. Where the guidance lives

Canonical style guide (the one document every scenario author must read first):
- `tinytill/system-tests/features/GHERKIN_STYLE.md` — the house Gherkin style guide (references "BDD 101: Writing Good Gherkin", automationpanda.com)

Supporting guidance and enforcement docs:
- `tinytill/system-tests/features/README.md` — harness mechanics; "Writing new scenarios? Read GHERKIN_STYLE.md first"
- `tinytill/system-tests/features/PRODUCT_SPEC.md` — declares the features directory the **canonical product specification** written as executable Gherkin; tag taxonomy; spec-ahead (`@todo`) workflow
- `tinytill/system-tests/CLAUDE.md` — harness orientation; fail-loud rules, parallelism, "how to add a scenario" checklist (step 1: follow GHERKIN_STYLE.md)
- `tinytill/system-tests/features/step_definitions/README.md` — step-definition organisation template (split-by-family over a shared seam)
- `overlay/CLAUDE.md` §"Acceptance testing boundary" (lines 17–29) — black-box assertion rules for the Rust cucumber suite
- `overlay/backend/CLAUDE.md` (lines 11–12) — the "dual-source rule" for canonical vs runnable feature copies; gherkin-parser caveats
- `overlay/system-tests/features/portal/README.md` — canonical portal Gherkin, no-duplication rules, tier boundaries
- `knowledge/architecture/overlay-network-rebuild-design.md` (lines 212, 410) — Overlay formally "adopts TinyTill's style guide as-is"
- `knowledge/architecture/overlay-tracer-1.md` (§"The Gherkin scenario") — worked rationale for a tracer's single-scenario spec
- `tinytill/docs/product/VOCABULARY.md` — domain vocabulary scenarios (and copy) must use
- `system-tests/CLAUDE.md` (root) — cross-product suite boundary rules and wall-clock/timeout practices

Feature files in practice: `tinytill/system-tests/features/*.feature` (~40 files), `overlay/system-tests/features/*.feature` (+ `portal/`), root `system-tests/features/*.feature`, plus adapted copies in `overlay/backend/test/features/`.

## 2. The style rules (stated or evident, with sources)

From `GHERKIN_STYLE.md` (all direct):

1. **Declarative, not imperative** — "Describe **what** the business cares about, never **how** the system implements it." No internal nouns in feature files: "COSE_Sign1, prev_hash, CBOR, kid_mgr, actor_role, enrollment_id, event_type, DB table names, chain counts, port numbers, HTTP status codes. All of that lives in step definitions."
2. **Business language** — "A merchant or product owner must be able to read every scenario without technical help." Word-for-word substitution table: write `a £15.00 cash order`, not `an order_completed event with total_sales_minor: 1500`; write `the day's takings are closed`, not `a z_close event is appended`; write `a complete, tamper-evident record`, not `the chain has 3 events with correct prev_hash linkage`.
3. **Given/When/Then semantics** — Given = pre-existing context ("Reach that state however necessary; the reader doesn't need to know how"); When = "a single action taken by a user or the system"; Then = "an observable business outcome. **One assertion per `Then` (or `And`)**."
4. **Environment preconditions go in `Before` hooks, not Given steps** — "If it's not a business fact — 'the backend is reachable', 'the database is seeded' — it belongs in a `Before` hook... A `Given` step that says 'the backend is reachable' only adds noise."
5. **One behaviour per scenario, name the behaviour in the title** — "Take a cash order and close out the day" good; "Test the full flow" bad (vague); "Register a manager key and verify kid_mgr derivation" bad (implementation-focused — "belongs in a step comment").
6. **Parameterise steps** — e.g. `When the cashier takes a £{float} cash order`, so scenarios vary values "without duplicating step definitions".
7. **Where implementation detail lives** — step definitions contain "All HTTP calls, COSE signing, CBOR decoding; Database assertions...; Error path guards...; **Comments explaining the why for each assertion**."

Evident-in-practice conventions (from the feature files and surrounding docs):

8. **Third-person named personas / actors** — scenarios name people ("Alice", "Bob", "Maya", "Lee") and businesses ("Headless Cafe", "Harbour Diner", "Brick Lane Coffee"); never "I". Consumer personas documented in `knowledge/product/consumer-personas.md` (cited in the header of `golden_ticket.feature`).
9. **Feature-level narrative in "So that ..., <product> lets ..." form** — e.g. `tracer1-spine.feature`: "So that a merchant can trade from day one and account for the day's takings, TinyTill lets a cashier take orders and close out the day." Used across ~30 tinytill features.
10. **Background for shared journey setup only** — a single business-language Given, e.g. `Given "Headless Cafe" has set up a new till on the engine`.
11. **Tags carry lifecycle + traceability + tier** — from `PRODUCT_SPEC.md`: `@todo` = spec-ahead, excluded from the green run ("As a tracer lands, its scenarios lose `@todo`, gain step definitions, and join the green suite"); `@phase1`/`@northstar`/`@phase2` = product phase; `@tracerN` = which build tracer delivers it; `@local-engine` = no-Docker scenarios bypassing the backend preflight hook; `@open-question` = intent sketched, undecided; family tags (`@catalog`, `@get-paid`, `@auth-foundation`, `@browser`...) for selective runs and tag-scoped `Before` hooks.
12. **Spec-ahead / spec-first** — `PRODUCT_SPEC.md`: the feature directory "is the canonical product specification... most scenarios describe intended behaviour... They are the product decision, written first; implementation follows." Whole-spec parse check: `cucumber-js -p full --dry-run`.
13. **WHY-comments inside feature files** — rationale comments above scenarios, e.g. `staff-handover.feature`: "# Why: staff PIN-tap handover is DEVICE-SCOPE and works fully offline..."; implementation nouns stay in comments/step-defs, but rationale is welcome as comments.
14. **No duplication across tiers/files; one owner per behaviour** — `portal/README.md`: browser-tier specs "do NOT re-test the business logic the domain seam already covers... Threshold math, byte fidelity... are NOT re-asserted here." `screen-coverage-map.md` audits that every scenario is "owned exactly once with explicit cross-references."
15. **Black-box assertions only** — `overlay/CLAUDE.md`: "Do **not** prove product-flow behavior by reading Overlay backend diagnostics or dev endpoints. In Cucumber `When`/`Then` steps, assertions should come from wallet/till projections, signed stream events, public responses, and external simulator APIs. Dev seams under `/v1/dev/*` are allowed only for `Given` fixture setup" — dev seams are Given-fixtures, never Then-evidence. Enforced mechanically by `acceptance_contract.rs` / `src/acceptanceContract.ts`.
16. **Companion NOTES.md files** — implementation decisions, ratified forks, open questions live beside the feature in `<name>.NOTES.md`, keeping the `.feature` clean.
17. **Dual-source rule when a runner can't execute the canonical file** — `overlay/backend/CLAUDE.md`: canonical Gherkin is "the single source of product truth"; adapted execution copies are mirrors — "edit the canonical first, then mirror into the runnable copy. Do NOT treat the copies as the spec."
18. **Fail loud, never soft-skip** — `tinytill/system-tests/CLAUDE.md`: a down backend must fail every scenario with a clear message via the shared tagged `Before`; "never reintroduce a `return`-early `serverAvailable` flag (zero-assertion false green)."
19. **Vocabulary discipline** — `VOCABULARY.md`: merchant-facing/domain words ("payment method" not "tender", "trading period" not "shift/session", "order" not "transaction"); architecture nouns off-limits in merchant language. "Scenarios read in domain language (GHERKIN_STYLE.md, VOCABULARY.md)."
20. **Parser gotcha as rule** (`overlay/backend/CLAUDE.md`): "the `gherkin 2.0.0` parser drops a scenario's first step if it is a bare `When` — open each scenario with `Given`" (Elixir/Cabbage copies).

## 3. Exemplary scenario excerpts

`tracer1-spine.feature` (the flagship; GHERKIN_STYLE.md's "After" example):
```gherkin
@tracer1 @headless
Feature: Trading on a newly set-up till
  So that a merchant can trade from day one and account for the day's
  takings, TinyTill lets a cashier take orders and close out the day.

  Background:
    Given "Headless Cafe" has set up a new till on the engine

  Scenario: Take a cash order and close out the day
    When the cashier takes a £15.00 cash order
    Then the order is recorded in the day's trade

    When the cashier closes out the day
    Then the day's takings are closed
    And the day's trade is a complete, tamper-evident record
```

`multi-staff.feature` (attribution, third-person personas):
```gherkin
  Scenario: Two staff share a till across a shift
    When Alice takes a £4.00 cash order
    And Bob takes over the till
    And Bob takes a £6.50 cash order
    Then the £4.00 order is attributed to Alice
    And the £6.50 order is attributed to Bob
```

`golden_ticket.feature` (Overlay tracer-1 — zero crypto nouns despite COSE/cert/ledger machinery underneath):
```gherkin
  Scenario: A regular joins with a golden ticket and taps for her free coffee
    Given Brick Lane Coffee hands Maya a golden ticket
    When Maya joins Overlay with her phone number and the ticket code
    Then Maya has a free coffee to spend at Brick Lane Coffee
    And Maya has not connected a bank account
    When the barista rings up a coffee and Maya taps
    Then Maya pays nothing
    And the till confirms the payment
    And Maya has no free coffees left
    And Maya has earned her first coffee stamp
```

GHERKIN_STYLE.md also contains a full Before/After pair (imperative, implementation-leaking version vs the declarative rewrite) — worth borrowing as a pattern.

## 4. Organisation, harness, and runner conventions

**TinyTill (TypeScript, cucumber-js):**
- Layout: `system-tests/features/*.feature` + `features/step_definitions/<name>.steps.ts` + `features/step_definitions/support/` (seam modules, not matched by the `*.steps.ts` glob). Config: `requireModule: ['tsx/cjs']`, timeout 15000, default profile `tags: 'not @todo'` (green suite) vs `-p full --dry-run` (whole-spec parse).
- **Headless, seam-driven**: scenarios drive the **real** Operation executor / real Node engine against a Docker backend — "do NOT hand-roll sign+POST". `@local-engine` scenarios drive a purely local engine seam, no Docker. Portable journey drivers are runtime-agnostic so the same journey runs under Cucumber and the real-Hermes smoke — an "engine-output vs backend-state assertion split": portable drivers assert engine output; step files layer `pg`-backed backend assertions on top.
- Step-definition organisation: one step registry; big step files split **by scenario family** over a `support/<family>World.ts` seam holding the shared per-scenario world + `Before` reset hook; "**Never copy-paste a helper between step files**" — ≥2 files in a family → seam module; cross-suite → `src/helpers/`; every file under an 800-line gate; splits move-only with byte-identical registration counts and zero ambiguous steps.
- Speed/wall-clock: `parallel: 6` workers (serial ~14.4s → ~2.6s, ~5x; plateau at N=6 — backend+pg is the ceiling); per-scenario entity isolation via client-side ULIDs; worker-id folded into generated identifiers for cross-worker collision safety (inline generators banned). Never bare `npx cucumber-js` (dependency-confusion malware placeholder on npm) — always the local binary/npm script.
- GUI/emulator checks are "a separate surgical tier" that must not duplicate headless coverage.

**Overlay (Rust, cucumber-rs):** one binary, one module per feature area, gated on `OVERLAY_BACKEND_URL`; "Step definitions ferry bytes between actors through public APIs only"; `acceptance_contract.rs` mechanically guards the black-box boundary. Elixir backend runs adapted Cabbage copies (Background → ExUnit `setup`) per the dual-source rule.

**Root cross-product suite:** composes TinyTill's engine with Overlay's SDK/actors over JSON-stdio; every wait in the actor IPC path is bounded (10–15s HTTP, 25s per IPC request, outer watchdog default 1800s exiting 124) after a 44-minute wedge post-mortem; deliberate-failure probes must prove a stall fails RED bounded, not hangs.

## 5. Stated rationale (the WHY)

- **Readability by non-technical stakeholders is the acceptance test for the spec itself**: "The second version is readable by a non-technical stakeholder. The first is not. All the assertions from the first version still exist — they moved into the step definitions." Portal specs "authored for team-lead + product-owner review **before** implementation."
- **Tests as living documentation / the spec IS the product decision**: the feature layer is "the behaviour a merchant/product-owner expects... the product decision, written first; implementation follows." "The Gherkin must be declarative/business-readable (no impl detail in .feature; it lives in step defs)."
- **Behaviour is the durable contract; implementation nouns churn**: the rebuild design makes Gherkin the definition of all behaviour for a ground-up rebuild — "All behaviour is defined in Gherkin; development is delivered around it" — business-language scenarios survive a full re-implementation.
- **Black-box assertions keep tests honest and force product-visible surfaces**: if a scenario "seems to need... a direct backend shortcut for an action the GUI would perform, add the missing product-visible event/projection/public route instead." The headless suite "must still behave like the real product."
- **Fail-loud over false-green**: soft-skips produce "zero-assertion false green."
- **The product point lives in the Then-lines**: scenarios pin the value proposition; build stages are "internal delivery slices... they do not get their own feature scenarios."
- Pending improvement in their IDEAS.md: tag each `.feature` with the PRD requirement it satisfies (`@req-R5.5`) — traceability rising in value as the suite grows.
