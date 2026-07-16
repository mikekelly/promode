# MK opinion candidates — mined from coreyhaines31/marketingskills

## RATIFICATION (maintainer, 2026-07-16) — decisions-as-constraints for tasks 31–35

**Ratified: all 92 candidates ACCEPTED as proposed, except as modified below.** Proposed tiers/homes stand unless a modification touches them.

1. **`mk-founder-reviews-the-numbers` — RECAST, not anti-delegation.** Agents do all preparation and analysis; the raw numbers (not pre-digested summaries) cross the owner's desk on a monthly cadence — *review* is the non-delegable part, because data familiarity is what makes the owner's ratification calls fast and confident. Family: O2/O41 (human ratifies from evidence), not an O1 exception.
2. **The five `kin:` flags resolve as EXTENSIONS of existing register items, never parallel MK items** (maintainer mandate: harmonize; modifying existing items/roles is allowed): `mk-persona-proxy-ladder` → mechanics under PD3/PD4 (SPD keeps `PERSONAS.md` ownership; the marketing lane consumes personas, never forks them); `mk-two-tier-loop-actions` → O11's marketing-automation instantiation; `mk-expert-panel-scoring` → R4's copy instantiation; `mk-marketing-context-file` → K7/K8 — marketing context lives as `docs/marketing/` graph nodes, NO new file convention; `mk-agentic-stack-thesis` → M0 kin, keeping the can't-claim-it-unwired tooth. Related responsibility split: customer/VOC research mechanics (§7) become a routed doc shared by SPD and SM — persona ownership stays SPD, campaign-research ownership goes to SM.
3. **Decision A — time-pinned platform material does NOT enter the register as content.** The ⚙-heavy payloads (§4 bundles `mk-meta-decision-system`/`mk-google-account-doctrine`/`mk-linkedin-doctrine`/`mk-budget-respects-learning`; §8's engine-specific mechanics) live in **dated routed docs kept THIN: link the upstream source files by URL (raw.githubusercontent.com paths into coreyhaines31/marketingskills) and fetch current content at use time, rather than vendoring full copies that rot.** One NEW register opinion replaces them all: `mk-platform-doctrine-time-pinned` — platform playbooks are dated, routed, and an agent MUST currency-check load-bearing claims (web-verify against the live platform/upstream) before acting on them. Era-level strategic stances (`mk-creative-is-the-targeting`, `mk-statics-over-polished-video`, `mk-cited-not-ranked`, `mk-citation-is-not-recommendation`, `mk-google-vs-other-engines-split`, `mk-third-party-beats-own-site`, `mk-honest-machine-checked-claims`, `mk-geo-evidence-stack`, `mk-fan-out-topical-clusters`, `mk-outbound-shrinking-window`) DO get register items with verified-as-of dates. *(Interpretation note: the maintainer said "use a URL link" — read as link-upstream-don't-vendor; flagged for correction, and cheap to change in task 32 if misread.)*
4. **Decision B — `mk-organic-before-paid` ACCEPTED.** Maintainer's why (travels with the rule): getting organic right is a good foundation on which to build paid anyway — paid then amplifies something proven rather than amplifying what's broken.
5. **Decision C — `mk-okf-protocol-bet` NOT ratified**; deferred to `IDEAS.md` (revisit if any engine starts reading OKF). `mk-machine-readable-for-buyer-agents` and `mk-allow-citation-bots` ACCEPTED (concrete, cheap, reversible).
6. **Role fit confirmed (no new roles/seniorities):** ~15 decision-altitude items → CMO def; ~10 cross-cutting execution stances → senior-marketer def inline (its doctrinal core); ~60 domain items → per-domain routed docs (specialism axis is docs, not defs — engineer-lane pattern), consolidated per task 32; mechanical tail routes to the existing roster (bulk generation → fast/cheap-worker, directory/form submission → gui-driver, visual artifacts → SPD lookbook loop); `marketing-council` = a dispatch pattern, not a role.

**Status: PROPOSALS for item-by-item ratification. Nothing here is register doctrine until the maintainer ratifies it as *his*.** *(Superseded 2026-07-16 by the ratification block above — retained for the record.)* Source: https://github.com/coreyhaines31/marketingskills (MIT, Corey Haines) — 16 skills read to full depth (SKILL.md + all `references/`), mined 2026-07-15. Mining ≠ endorsing: every quantitative claim below is the repo's, unverified by us; every tier-3 item carries that status explicitly. This doc gates the marketing lane (tasks 31–35).

**Tier convention (ratified 2026-07-15):**
1. **Name-only** — framework the pinned model (inherit/opus) reliably knows: the candidate wraps the bare name with the when/which/why; never spell out.
2. **Routed-doc** — named system the model only half-knows: def carries the decision + doc pointer; mechanics spelled out once in a routed doc. (Tier 1-vs-2 doubt → probe the pinned model cold before deciding.)
3. **Spelled-out + currency** — contradicts model priors or postdates training: full statement + why + verified-as-of date + re-verify trigger (⚙-analogue). For every ⚙ item below: **verified-as-of = repo state at mining, 2026-07-15; the claim itself is the repo's, unverified**.

**Homes key:** CMO = chief-marketing-officer def (inherit — positioning, growth strategy, channel strategy, one-way doors) · SM = senior-marketer def (opus/high execution) · RD-\<x\> = proposed routed doc (doc names are placeholders; tasks 31–35 decide the doc layout — several RDs below will likely merge) · B = brief (rare; only if a routing decision must reach the main agent). **kin:** flags overlap with an existing register item — a merge/calibrate decision at ratification, not a new home.

**Entry format:** slug — statement · src (skill, file if reference-level, tight quote/paraphrase) · tier · ⚙ = perishable · homes · why.

---

## 1. Cross-cutting doctrine

### `mk-grounded-creative-inputs` — All generated marketing assets trace to real source material (winning ads, verbatim reviews, ad comments); no invented claims, stats, or testimonials ever — and if the inputs corpus is empty, stop and ask, never generate ungrounded as a fallback
- src: ad-creative — "ungrounded generation produces plausible-sounding ads based on training data, not on what converts for this brand"; "Do not generate ungrounded concepts as a fallback"
- tier: 2 (corpus layout + decay cadence are mechanics) · homes: SM + RD-creative; decision copy in CMO · kin: PD4 (evidence-graded claims — this is its asset-generation twin)
- why: the single biggest failure mode of AI marketing execution; the stop-if-empty rule is the enforcement tooth.

### `mk-ad-comments-highest-value-input` — Ad comments are the most-skipped, highest-value research input: objections become objection-handling ads, unprompted praise surfaces angles you didn't write
- src: ad-creative — "the most-skipped and highest-value input"
- tier: 1 · homes: SM
- why: a concrete prioritization the model won't default to.

### `mk-verbatim-over-paraphrase` — Customer language is captured verbatim, never paraphrased — "we were drowning in spreadsheets" beats "manual process inefficiency"; the exact words are the copy
- src: customer-research — "Capture exact quotes, not paraphrases… This is gold for copy"
- tier: 1 · homes: SM
- why: paraphrase is the default LLM behaviour; this opinion forbids it.

### `mk-banned-hype-vocabulary` — Ban the course-bro/AI-slop register everywhere: "game-changing/revolutionary/10x/secret/set-it-and-forget-it", "worth $X" with no comparable, "limited time" with no limit; specificity beats superlatives — numbers, named customers, real timelines
- src: offers ("pattern-matches to AI slop / course-bro"), marketing-loops ("Loops are disciplined systems with checkpoints, not magic"), cold-email jargon list
- tier: 1 (the stance) with a short banned-list appendix (tier-2, RD-creative or RD-offers) · homes: SM; CMO decision copy
- why: a house voice rule; three skills carry it independently — it's core Haines doctrine.

### `mk-marketing-context-file` — Marketing work starts from a canonical, project-resident product-marketing context doc (positioning, ICP, voice) read before asking the user anything
- src: every skill — "If `.agents/product-marketing.md` exists… read it before asking questions"
- tier: 1 · homes: CMO + SM · kin: **K7/K8** — promode already has orient-before-acting and `docs/product/`; ratification call is whether marketing context lives in `docs/product/` (recommended) rather than a new file convention
- why: the repo's strongest structural convention; maps cleanly onto the existing knowledge graph.

---

## 2. Offer design

### `mk-offer-is-the-thing` — The offer is the thing, not the page: most "we need better copy" requests are "we need a better offer" requests in disguise — improve the offer before polishing its expression
- src: offers — "Better copy on a weak offer compounds slowly. A stronger offer with average copy converts immediately"
- tier: 1 · homes: CMO (decision altitude — reframes the ask) + SM · kin: PD1 (skeptical-default — same reframe-the-request muscle)
- why: the root diagnostic of the whole offers lane; a genuine do-X-not-Y.

### `mk-value-equation-diagnosis` — Diagnose stuck offers with the value equation (Hormozi): score the four levers, the lowest is the binding constraint, fix ONE lever per iteration — and treat "lower the price" as "raise the numerator or lower the denominator"
- src: offers + references/value-equation.md — "Price is the comparison, not the value"
- tier: 1 (name-only: the model knows the equation; the opinion is lowest-lever-binds + one-lever-per-iteration + the price reframe) · homes: SM
- why: the when/which/why wrap on a famous framework — the tier-1 pattern exactly.

### `mk-proof-before-features-and-guarantees` — Stuck offers usually need more proof, not more features; and build proof before the guarantee — strong proof + weak guarantee beats the reverse
- src: offers references/value-equation.md, guarantee-design.md — "Most stuck offers need proof, not features"
- tier: 1 · homes: SM
- why: contrarian ordering the model won't volunteer.

### `mk-guarantee-by-business-model` — Pick the guarantee type from business model + buyer sophistication (8-type taxonomy, decision tree, two conditions max, 10%-invocation stress-test); the wrong guarantee hurts more than none; anti-guarantees fit premium/self-qualified buyers
- src: offers references/guarantee-design.md
- tier: 2 · homes: SM + RD-offers
- why: half-known taxonomy; the selection tree is repo mechanics.

### `mk-bonuses-close-named-objections` — Every bonus closes one specific named objection (speed/trust/stuck/decision pattern); bonuses are additive to a complete core (if the offer converts without the core, fix the core); stagger delivery — completion is the marketing asset
- src: offers references/bonus-stacking.md — "A buyer who gets all bonuses up-front is more likely to abandon"
- tier: 2 · homes: SM + RD-offers · kin: overlaps its own sibling `no-bonus-inflation` (in offers SKILL) — bundle at ratification
- why: turns "add bonuses" from inflation into objection-handling.

### `mk-real-scarcity-only` — Scarcity is the close, not the offer: fix the value equation first; if you're tempted to fake it you have a value-equation problem, not a scarcity problem; real scarcity is buyer-verifiable and actually enforced; skip scarcity entirely on subscriptions/premium/high-trust offers
- src: offers + references/scarcity-urgency.md — "If you have to fake it, you don't have an offer-design problem"
- tier: 1 · homes: SM; CMO decision copy (trust is a strategic asset)
- why: the honest-marketing keystone; also the diagnostic ("tempted-to-fake = deeper problem") is non-derivable framing.

### `mk-honest-lift-projections` — Project lift honestly: single-component offer changes deliver 10–40%, stacked iterations 2–3×; anyone promising 5× is selling something
- src: offers — verbatim
- tier: 1 (numbers are the repo's, unverified, but the stance is the point) · homes: SM
- why: calibrates client/user expectations against hype.

### `mk-productize-and-name` — Productize services into named, fixed-scope offers ("The 8-Week X"); unnamed services compete on price, named ones on positioning; test the name with "can a buyer text a friend about it?"; and payment structure is its own lever — often add a payment plan instead of lowering the number
- src: offers references/offer-formats.md, offer-anatomy.md
- tier: 1 · homes: SM
- why: three crisp packaging stances in one coherent family.

### `mk-format-matches-business-type` — Match offer format to business type — borrowing across types (direct-response bonus-stacking onto premium B2B) is the biggest offer mistake; for enterprise B2B time-to-value IS the offer; for cohort coaching the room IS the offer
- src: offers references/offer-formats.md, examples.md
- tier: 2 (per-type defaults need a doc) · homes: SM + RD-offers
- why: prevents the most common cross-domain contamination.

### `mk-offers-vs-pricing-boundary` — Offer construction (bonuses, guarantees, scarcity, naming) is for services/courses/coaching/high-ticket/direct-response; in self-serve SaaS the levers are tier structure, value metric, and packaging — route accordingly
- src: offers frontmatter — "If you run pure self-serve SaaS, read pricing first"
- tier: 1 · homes: CMO (routing decision)
- why: a genuine routing opinion; stops offer tactics leaking into SaaS pricing work.

---

## 3. Paid ads — strategy & scaling (durable doctrine)

### `mk-net-cash-over-roas` — Scale to your break-even CPA/ROAS ceiling derived from LTV — not until account ROAS drops below an arbitrary preference; optimize blended business-level ROAS (better: net free cash flow), never per-ad-set ROAS
- src: ads — "a business at a 40 ROAS spending $5k/month, refusing to scale… is the wrong frame"
- tier: 3 (contradicts the ROAS-maximization prior baked into most training data) — but durable, not ⚙ · homes: CMO (growth strategy) + SM
- why: named in the task brief as a tier-3 exemplar; the highest-stakes scaling opinion in the corpus.

### `mk-breakeven-from-deal-math` — Derive breakeven CPL/CPC from your own deal math (deal size × close rate × funnel CVR), never from platform benchmarks; before any new channel, run a ~$100 test — platform estimates and published benchmarks are consistently wrong for specific ICPs
- src: ads references/b2b-paid-playbook.md
- tier: 2 (formulas + kill-rule thresholds are doc mechanics) · homes: SM + RD-paid-ads · kin: P1 (evidence-over-assumptions, channel edition)
- why: replaces benchmark-anchoring with first-party arithmetic.

### `mk-optimize-to-lead-quality` — Feed the algorithm raw form-fills and it buys junk: close the offline-conversion loop (CRM outcomes back to the platform — "when they disagree, the CRM wins") and rank ads by average lead-quality score (Urgency/Budget/Fit), never by CPL or CTR
- src: ads references/b2b-paid-playbook.md — "the single highest-impact move in a B2B ad account"
- tier: 2 · homes: SM + RD-paid-ads
- why: the B2B twin of net-cash>ROAS; quality-blind optimization is the default failure.

### `mk-founder-reviews-the-numbers` — Block 3 hours/month for the owner to physically review the ad numbers themselves — not the analyst's summary, not the media buyer's: "data gives you confidence, confidence gives you speed"
- src: ads — verbatim
- tier: 1 · homes: CMO (it's an operating-cadence call surfaced to the human)
- why: an anti-delegation carve-out — interesting tension with promode's delegate-by-default; worth an explicit ratification call.

### `mk-call-your-lost-leads` — Outbound-call every lead that didn't convert and ask why; the verbatim objections become objection-handling retargeting ads — the insight-to-creative loop most advertisers skip
- src: ads
- tier: 2 (feeds the 4-component retargeting system) · homes: SM
- why: closes the research→creative loop with first-party evidence.

### `mk-retarget-different-offers` — The #1 reason someone didn't buy is the offer wasn't right for them — retarget with DIFFERENT products/offers from the catalog, not the same thing harder; run the 4-component retargeting layer (objection ad / proof carousel / other-offers CBO / value-first audit)
- src: ads — "a 2-3 ROAS audience on the original offer can hit 6+ ROAS on a different offer" (repo's claim, unverified)
- tier: 3 (contradicts the re-show-the-product retargeting prior) — durable logic, quant perishable · homes: SM + RD-paid-ads
- why: named framework + prior-contradicting stance in one.

### `mk-headline-mirroring` — Use ad platforms as the landing-page split-test lab: run 20–40 headline variants, mirror the winner VERBATIM into the LP's H1/subhead — ad→page scent-match is the most underrated paid lever (flip the 90/10 ads/page effort ratio)
- src: ads — "your ad headlines are exposed to ~1000x the audience that actually clicks through"; 15–20% LP lift (repo's claim, unverified)
- tier: 2 · homes: SM
- why: a mechanic the model half-knows (message match) sharpened into a specific loop with an exact discipline (verbatim, not similar).

### `mk-three-live-split-tests` — Standing discipline: at least 3 split tests running somewhere in the funnel at all times — if not, you've capped the improvement curve
- src: ads
- tier: 1 · homes: SM
- why: a simple always-on invariant; compounding rationale travels with it.

### `mk-abm-is-pipeline-influence` — ABM ads are a pipeline-influence motion, not lead-gen: judge on account movement plus a ~20% holdout (the only honest incrementality answer), never CPL; company lists beat contact lists on LinkedIn
- src: ads references/abm-playbook.md
- tier: 2 · ⚙ partial (list-match mechanics) · homes: SM + RD-paid-ads
- why: measurement-honesty doctrine; the holdout is the anti-vanity tooth.

### `mk-search-harvests-demand` — Search harvests existing demand; it cannot create it — near-zero search volume means the budget belongs upstream (social/video), not in more keywords; and bid on brand by default, testing pauses only against TOTAL (paid+organic) brand conversions
- src: ads references/google-search-playbook.md
- tier: 2 · homes: CMO (channel strategy) + SM
- why: channel-selection doctrine at decision altitude, with the brand-bid contrarian rider.

---

## 4. Paid ads — platform-era doctrine (⚙ heavy; every quant is the repo's, unverified)

### `mk-creative-is-the-targeting` — Andromeda-era doctrine: audience knowledge goes into the CREATIVE (headlines, hooks, identity-trigger keywords), not targeting filters — target broadly, write 5 variants speaking to different segments, let the algorithm match; the creative/filter ratio varies by platform (Meta 80/20, Google Search 40/60, LinkedIn 40/60)
- src: ads — "jamming all your audience identifiers into the platform's targeting filters underperforms feeding those same identifiers into the creative"
- tier: 3 ⚙ (postdates training; algorithm-dependent) · homes: SM + RD-paid-ads; CMO carries the decision line · re-verify: any major ad-platform algorithm change
- why: named in the task brief as a tier-3 exemplar; inverts the interest-stacking playbook models learned.

### `mk-statics-over-polished-video` — Creative volume is the constraint, and statics often outperform video (cheaper to deliver, 10× cheaper to produce, enable the volume the algorithm needs): volume > polish, ~1 hr/week producing fresh creative for the winning offer
- src: ads — "down-and-dirty native statics often beat 2.5-month-production VSLs"
- tier: 3 ⚙ · homes: SM + RD-paid-ads · re-verify: Meta delivery-bias changes
- why: named in the task brief as a tier-3 exemplar; directly contradicts "video always wins" priors.

### `mk-identity-trigger-keywords` — Duplicate a winning ad with one niche/identity keyword inserted ("…462 **dental** leads…") — an identity trigger for the viewer AND a targeting signal for the algorithm; farm AI variants per niche and let a CBO allocate
- src: ads (one-keyword hack + AI variant farming + zombie campaigns: relaunch high-conviction zero-spend variants, ~20% resurrect)
- tier: 2 · ⚙ partial · homes: SM + RD-paid-ads
- why: a repeatable scaling mechanic the model half-knows at best.

### `mk-ads-shouldnt-look-like-ads` — The polished-ad aesthetic kills performance: study what natively performs in the niche (burner-account technique), produce ads matching that aesthetic, and run proven organic content as paid — proven content + paid distribution is the highest-leverage move
- src: ads
- tier: 2 · homes: SM
- why: the aesthetic stance is durable even as platforms shift.

### `mk-meta-decision-system` — Run Meta as arithmetic, not vibes: anchor every kill/keep/scale threshold to TCPL (target cost per QUALIFIED lead); two campaigns (scaling ~80% / testing ~20%) over the same audience because inside one CBO proven ads starve tests; require work email on lead forms (intentional friction = quality); Advantage+ only after ~50 conv/week; editing a live winner resets learning, pausing doesn't; budget moves ≤ ~20%
- src: ads references/meta-decision-system.md — "decisions become arithmetic instead of vibes"
- tier: 3 ⚙ (Meta-mechanics bundle) · homes: SM + RD-paid-ads · re-verify: any Meta ads-manager/algorithm change
- why: a coherent operational system; ratify as one bundle — it lives or dies together.

### `mk-google-account-doctrine` — Google Search structure opinions: themed ad groups, not SKAGs; every campaign gets an independent budget (shared budgets let brand starve the campaigns you need data from); Broad match only after 30+ conv/mo AND smart bidding AND a tight negative list; PMax earns budget LAST, never first, never on weak tracking
- src: ads references/google-search-playbook.md — "Broad without all three is a donation to Google"
- tier: 3 ⚙ bundle · homes: SM + RD-paid-ads · re-verify: Google Ads product changes
- why: contradicts older SKAG orthodoxy models may still carry; ratify as a bundle.

### `mk-linkedin-doctrine` — LinkedIn B2B opinions: Audience Expansion OFF, Audience Network OFF; target function+seniority not titles (~3× audience, cheaper); week 2 switch to manual CPC ~20% below the automated average; scale on audience penetration (~35%+ → go horizontal), not spend; thought-leader ads are the platform's biggest arbitrage (~3–6× company-page CTR); retargeting audiences are NON-RETROACTIVE — create them all before launch
- src: ads references/linkedin-b2b-playbook.md
- tier: 3 ⚙ bundle · homes: SM + RD-paid-ads · re-verify: LinkedIn campaign-manager changes
- why: settings-level doctrine that silently decays; the non-retroactive gotcha alone pays for the doc.

### `mk-budget-respects-learning` — Budget increases ~20% at a time, never 30%+ in one move (resets platform learning); wait 3–5 days between increases; never stop campaigns mid-learning-phase
- src: ads
- tier: 3 ⚙ · homes: SM · re-verify: platform learning-phase mechanics
- why: mechanical but violation-prone; cheap to carry.

---

## 5. Ad creative system

### `mk-volume-then-curate` — Generate wide, curate hard: picking 5 winners from 50 concepts beats picking 5 from 10; cycle ALL templates (template diversity IS angle diversity) and never drop template coverage to zero even when scaling winners — today's scaled template is next month's fatigued one; but curate to 2–4 concepts for stakeholder approval (10 is a menu nobody finishes)
- src: ad-creative + references/static-ad-templates.md, creative-review-page.md
- tier: 2 · homes: SM + RD-creative
- why: the generate/curate asymmetry is the core AI-era creative opinion.

### `mk-hook-is-three-components` — A hook is three simultaneous components (visual action / spoken line / caption) that complement, never repeat; every hook test is also an on-ramp test (rewrite seconds 3–15 per hook); diagnose the failing component from the delivery funnel — thumbstop→visual, hold→on-ramp, CTR→offer, CVR→congruence; "a great thumbstop is not a great ad"
- src: ad-creative references/hook-system.md
- tier: 2 · homes: SM + RD-creative
- why: an idiosyncratic named system (the tier-2 pattern from the brief); the diagnostic mapping is non-derivable.

### `mk-evidence-ranked-creative` — Creative direction triangulates three independent signals (account performance / customer language / external organic — any one alone misleads); rank concepts by a 6-tier evidence ladder (own account → customer verbatim → competitor 60+ days → organic → cross-niche → hunch); match production cost to evidence strength (fidelity ladder, one direction only); judge CONCEPTS not ads — three executions of one concept failing kills the concept, one failing kills the execution
- src: ad-creative references/creative-roadmap.md, hook-system.md
- tier: 2 · homes: SM + RD-creative · kin: PD4's evidence-grading, applied to creative
- why: the repo's most promode-shaped system — evidence-graded, ranked, falsifiable.

### `mk-account-state-branches-roadmap` — Diagnose account state before roadmapping: exploration = go wide (iterating on losers multiplies losers; a single-metric improvement counts as a hit); scaling = go deep on the winner but keep exploration alive (the next winner is rarely an iteration of the current one); roadmap to real production capacity or you ship slop; a retro that changes nothing in the roadmap was a meeting
- src: ad-creative references/creative-roadmap.md
- tier: 2 · homes: SM + RD-creative
- why: state-dependent strategy the model won't impose on itself.

### `mk-judge-after-signal` — Allow 1,000+ impressions before judging creative; change one variable per test cycle
- src: ad-creative
- tier: 1 · homes: SM
- why: cheap discipline against premature kills.

### `mk-poster-not-film` — Generated motion ads are animated poster design, not filmmaking: the still carries the idea, motion only makes it breathe; one visual style per campaign; split the pipeline — AI generators for exploratory hero creative, code-based rendering (Remotion) for deterministic brand-exact variations at scale; negative prompts backfire on video models ("no hands" is an attention trap — describe motion as belonging to objects instead)
- src: ad-creative references/motion-video-ads.md, generative-tools.md
- tier: 3 ⚙ (tool-landscape + model-behaviour claims) · homes: SM + RD-creative · re-verify: video-model generation change
- why: the negative-prompt gotcha directly contradicts a common prior; the hero/scale pipeline split is a current-stack opinion.

### `mk-borrowed-ui-formats` — Native-UI reveal formats (iMessage/ChatGPT/Notes/AirDrop) work by borrowing a familiar high-attention UI so the pitch lands before the ad-skip reflex fires — run ONLY as labeled paid, never seeded as "real leaked" content; borrowed authority raises the compliance bar (a fabricated ChatGPT answer is ad copy wearing a lab coat); pick the angle before the script; reveal the brand once, late
- src: ad-creative references/imessage-video-ads.md
- tier: 2 · ⚙ partial (format performance is dated) · homes: SM + RD-creative
- why: a current format family with a strong honesty envelope.

---

## 6. Cold email / outbound

### `mk-peer-not-vendor` — Cold email reads like a sharp colleague who noticed something relevant: their world not yours ("you" dominates "I/we"), every sentence earns its place, one interest-based low-friction ask ("Worth exploring?") — never a meeting request in first touch
- src: cold-email
- tier: 1 · homes: SM
- why: the voice doctrine; the model knows the genre but defaults to vendor register.

### `mk-personalization-connects-or-cut` — If removing the personalized opening leaves the email intact, the personalization isn't working — the observation must lead into why you're reaching out
- src: cold-email — verbatim test
- tier: 1 · homes: SM
- why: a falsifiable test, not a vibe.

### `mk-subject-lines-boring-internal` — Subject lines: 2–4 words, lowercase, internal-looking — like it came from a colleague; no product pitch, no urgency, no prospect first name (first name in subject = fewer replies: signals automation)
- src: cold-email + references/subject-lines.md ("-12% replies" — repo's claim, unverified)
- tier: 2 · ⚙ (behavioural data drifts) · homes: SM + RD-outbound
- why: counters the "compelling subject line" prior with anti-marketing discipline.

### `mk-followups-add-or-stop` — Each follow-up adds something new (angle, proof, resource) — "just checking in" gives no reason to respond; cap the sequence (~5 total): most replies come from follow-ups but past the 4th, replies drop and spam complaints spike; honor the breakup email
- src: cold-email + references/follow-up-sequences.md, benchmarks.md ("55% of replies come from follow-ups" — repo's claim, unverified)
- tier: 2 · ⚙ thresholds · homes: SM + RD-outbound
- why: cadence discipline with a stop condition.

### `mk-outbound-shrinking-window` — Cold-email reply rates are structurally declining (~7–8% → ~4–5.8%, 2020→2025); the gap between average and excellent is widening, so craft matters MORE, not less; tight targeting beats volume (≤50 contacts/campaign, 1–2 people/company, 25–75 words)
- src: cold-email references/benchmarks.md (all figures repo's claims, unverified)
- tier: 3 ⚙ · homes: SM + RD-outbound · re-verify: deliverability/benchmark shifts, Google/Yahoo sender-policy changes
- why: postdates training; reframes outbound investment logic.

---

## 7. Customer research

### `mk-confidence-labeled-insights` — Every research insight carries a confidence label (high = 3+ independent sources, unprompted, cross-segment; low = single source) before it's presented; the highest-confidence insights recur across multiple UNRELATED sources
- src: customer-research + references/source-guides.md
- tier: 2 · homes: SM + RD-research · kin: PD4's graded evidence — this is its research-pipeline instantiation
- why: makes research outputs falsifiable instead of narrative.

### `mk-sample-bias-and-recency` — Weight sources ≤12 months heavily (markets shift); name the bias of every source class (reviewers skew power-users, tickets skew problems, Reddit skews technical-skeptical); never build personas or messaging conclusions from fewer than ~5 independent data points per segment
- src: customer-research
- tier: 2 · homes: SM + RD-research
- why: the guardrails that keep VOC work from laundering noise into doctrine.

### `mk-persona-proxy-ladder` — No first-party reviews yet? Don't invent personas — walk outward through proxy sources in order (own differentiator as hypothesis → competitor reviews → adjacent-product reviews → adjacent brands sharing the audience), tag each persona with its proxy source, replace with first-party evidence as it arrives; leave unknown fields blank rather than filling them in; revisit quarterly — personas decay
- src: customer-research
- tier: 2 · homes: SM + RD-research · kin: **PD3/PD4** — promode already owns personas-evidence-grounded (SPD/CPO); ratification call: this is the marketing-lane mechanics UNDER the existing opinion, not a rival
- why: the anti-fabrication path for the empty-evidence case PD3 doesn't spell out.

### `mk-watering-hole-research` — Research where the ICP spends time, not where the product is discussed; read 3-star reviews first (most honest) and mine competitors' 4-star reviews for openings; weight every source by an explicit signal hierarchy (unprompted interviews high → multiple-choice surveys low — "artifacts of the options you provided")
- src: customer-research references/source-guides.md
- tier: 2 · homes: SM + RD-research
- why: idiosyncratic read-order + weighting doctrine a model wouldn't default to.

---

## 8. AI search (GEO/AEO) — the corpus's most currency-sensitive lane

### `mk-cited-not-ranked` — Traditional SEO gets you ranked; AI SEO gets you CITED — a well-structured page gets cited from page 2–3 because AI systems select on structure/extractability, not rank position; AI systems extract passages, not pages: atomic self-contained answer blocks
- src: ai-seo
- tier: 3 ⚙ · homes: SM + RD-ai-search; CMO carries the channel-strategy line · re-verify: AI-search platform behaviour changes
- why: the frame that separates this discipline from SEO priors.

### `mk-citation-is-not-recommendation` — AI visibility is a four-rung ladder (retrieved → cited → mentioned → recommended) governed by different systems: citations come from your content's structure, recommendations from web-wide consensus (reviews/forums/analysts); report the whole ladder plus mention FRAMING (incl. recommended-against), never one "AI visibility" number — and self-promotional "best of" listicles BACKFIRE for emerging brands (most citations they earn recommend competitors)
- src: ai-seo references/citations-vs-recommendations.md ("69% of the citations… pointed buyers to competitors" — repo's claim, unverified)
- tier: 3 ⚙ (the backfire finding + ladder mechanics) · homes: SM + RD-ai-search · re-verify: AI-answer engine behaviour
- why: postdates training and inverts the "publish a listicle ranking yourself #1" playbook.

### `mk-google-vs-other-engines-split` — Two regimes, not one: for Google AI features, write for people and core Search (no special markup — chunking for AI risks the scaled-content-abuse policy); for ChatGPT/Claude/Perplexity, layer extractable structure (answer blocks, FAQ schema, comparison tables, llms.txt) which materially helps there and doesn't hurt Google; per-engine indexes differ (Brave for Claude, Bing for Copilot/ChatGPT) so citation levers differ by platform
- src: ai-seo + references/platform-ranking-factors.md
- tier: 3 ⚙ · homes: SM + RD-ai-search · re-verify: engine index/backend changes, Google policy changes
- why: the split is the load-bearing strategic fact; models tend to collapse it into one "AI SEO" playbook.

### `mk-third-party-beats-own-site` — AI engines cite where you APPEAR more than what you publish — Wikipedia, Reddit, review sites, industry roundups; brands are far more likely to be cited via third-party sources than their own domains; participate authentically (fabricated/bulk mentions are both dishonest and policy-fatal)
- src: ai-seo ("6.5x more likely" — repo's claim, unverified)
- tier: 3 ⚙ · homes: SM + RD-ai-search; CMO decision copy (it reallocates content budget)
- why: inverts the own-blog-first content instinct.

### `mk-machine-readable-for-buyer-agents` — AI agents are becoming buyers: opaque pricing (JS-rendered, "contact sales") gets filtered out of AI-mediated buying journeys — ship /pricing.md, llms.txt, semantic HTML, and visible specs so an agent can parse and recommend you; stale pricing files are worse than none
- src: ai-seo
- tier: 3 ⚙ · homes: SM + RD-ai-search · re-verify: agent-commerce protocols (UCP etc.)
- why: postdates training; a concrete structural bet on agentic buying.

### `mk-allow-citation-bots` — Blocking AI crawlers means those platforms literally cannot cite you: allow the search-and-cite bots (GPTBot, PerplexityBot, ClaudeBot, Google-Extended), block training-only crawlers (CCBot) if you must
- src: ai-seo
- tier: 3 ⚙ (bot names/roles drift) · homes: SM + RD-ai-search
- why: a business decision usually made by default (blanket block) without seeing the citation cost.

### `mk-geo-evidence-stack` — What earns citations, ranked (Princeton GEO study): cite sources > add statistics > expert quotes > authoritative tone; keyword stuffing actively HURTS AI visibility; fluency + statistics is the best combination — and low-ranking sites gain the most
- src: ai-seo (all boosts "+40%/+37%/+30%" — repo's claims, unverified)
- tier: 3 ⚙ · homes: SM + RD-ai-search · re-verify: replication/engine drift
- why: an evidence-backed ranking of levers, one of which inverts an old-SEO habit.

### `mk-fan-out-topical-clusters` — Google's AI generates concurrent related queries under the hood: single-page-per-keyword targeting is fading — cover the full topical cluster (brainstorm the 5–10 fan-out queries) so you're retrievable for the variants
- src: ai-seo
- tier: 3 ⚙ · homes: SM + RD-ai-search
- why: changes content-planning shape, not just tactics.

### `mk-content-decays` — Content is a decaying asset: schedule per-type refresh cadences (pricing quarterly, comparisons 3–6mo, evergreen annually), refresh-vs-rewrite by signal, and show freshness — undated content loses to dated content in AI-weighted retrieval
- src: ai-seo + copy-editing references/content-refresh.md
- tier: 2 · homes: SM + RD-ai-search
- why: turns "content library" into a maintained system with cadences.

### `mk-honest-machine-checked-claims` — AI engines cross-reference: biased comparisons get penalized, misrepresenting competitor features gets de-ranked, duplicate descriptions across surfaces get down-weighted — honesty and variation are now mechanically enforced, not just ethical
- src: ai-seo references/content-types.md, directory-submissions + references/positioning-variations.md
- tier: 3 ⚙ · homes: SM; CMO decision copy · re-verify: engine cross-checking behaviour
- why: the enforcement claim (machines check now) postdates training and strengthens the honesty doctrine with self-interest.

### `mk-okf-protocol-bet` — Treat OKF (and peers) as protocol-layer registration — the same shape of bet as early schema.org: nothing crawls it yet, ship it only where it compounds with other machine-readable files, skip sub-10-page sites, and frame speculative tactics honestly ("does nothing immediate")
- src: ai-seo references/okf.md
- tier: 3 ⚙ (v0.1 spec, June 2026, postdates training) · homes: RD-ai-search only · re-verify: OKF adoption/any engine reading it
- why: a dated bet that must carry its own expiry logic.

---

## 9. Distribution — directories, launch, reviews

### `mk-directories-are-foundation` — Directory submissions are the foundation layer of distribution, never the strategy: they pass link equity and AI-citation surface into the pages that DO generate leads — build destination pages first (alternative pages, use-case pages, template galleries), then submit so the equity has somewhere to land; don't pay for submission services
- src: directory-submissions — "Build the destination pages first" (alt pages convert "5–15%", AI-referred traffic "6–27× higher" — repo's claims, unverified)
- tier: 2 · ⚙ quant · homes: SM + RD-distribution; CMO decision copy
- why: sequencing doctrine; the 6–27× claim flagged in the task brief stays quarantined as unverified.

### `mk-positioning-varies-by-surface` — Never copy-paste one description across directories: each surface type leads differently (startup=outcome, SaaS=alternative-framing, AI=AI-first, dev=technical depth, B2B=ROI) — and AI engines down-weight duplicates
- src: directory-submissions + references/positioning-variations.md
- tier: 2 · homes: SM + RD-distribution
- why: a variant system, not a vibe; the duplicate penalty makes it mechanical.

### `mk-ph-feedback-not-upvotes` — Product Hunt: comment quality outweighs upvote count; never ask for upvotes — ask for feedback (converts better AND avoids anti-manipulation filters); launch 12:01 AM PT Tue–Thu; the first 2 hours decide algorithmic distribution; most failed launches launched without a warm audience
- src: directory-submissions ("80% of failed launches" — repo's claim, unverified)
- tier: 3 ⚙ (PH algorithm) · homes: SM + RD-distribution · re-verify: PH algorithm changes
- why: algorithm-specific and prior-contradicting (upvote-chasing).

### `mk-reviews-or-dont-list` — Zero-review listings are dead: run the 10-in-30 protocol (20 personal asks, direct review links, modest thank-you, one follow-up) or don't submit to G2/Capterra at all; don't buy paid review-site plans in year one
- src: directory-submissions
- tier: 2 · ⚙ (thresholds/report cutoffs) · homes: SM + RD-distribution
- why: a go/no-go gate replacing the "list everywhere" default.

### `mk-orb-channels` — Structure launch/channel marketing as Owned / Rented / Borrowed — rented gives speed not stability, borrowed gives credibility, and everything must funnel back into owned; launches are phased momentum-builders (internal→alpha→beta→early-access→full), and the best companies launch again and again — announce by magnitude matrix, not everything with full fanfare
- src: launch (ORB framework + five-phase approach)
- tier: 2 (ORB named in the task brief as a half-known example) · homes: SM + RD-distribution; CMO carries channel-mix decision
- why: the repo's channel-strategy spine; needs the doc because the model half-knows the name.

---

## 10. Marketing planning (fCMO lane)

### `mk-aarrr-plan-spine` — Every plan recommendation is funnel-stage-tagged (AARRR) because tagging forces executable priority order; brand and content are cross-cutting, not stages; present stages in canonical order regardless of priority (signal priority by exec summary + section length); assign a move to where its primary MEASURABLE impact lands
- src: marketing-plan + references/aarrr-framework.md
- tier: 1 (AARRR is name-only) + tier-2 conventions · homes: SM + RD-plan
- why: the conventions (canonical order, measurable-impact tiebreak, signup-intent=Acquisition/completion=Activation) are repo-idiosyncratic and keep multi-agent plans consistent.

### `mk-diagnose-before-distributing` — Diagnose the binding funnel constraint before allocating: the Activation/Retention question usually outranks the Acquisition question ("fix the leak before pouring water in"); a plan evenly distributed across all five stages means the diagnostic was weak
- src: marketing-plan references/aarrr-framework.md
- tier: 1 · homes: CMO + SM · kin: Theory-of-Constraints (model-known); the opinion is the even-spread-is-a-red-flag test
- why: the sharpest plan-quality heuristic in the corpus.

### `mk-organic-before-paid` — Build the organic compound before layering paid: premature paid amplifies what's broken; only layer paid on a working organic baseline
- src: marketing-plan references/aarrr-framework.md
- tier: 1 · homes: CMO (channel strategy)
- why: disputable (many argue paid-first for signal) — exactly why it needs explicit ratification as an owner preference.

### `mk-operationally-honest-plans` — Plans never guess: unknown numbers are [TBD] → open decisions (CAC unknown is the highest-impact one); uncomfortable metrics get named, not sugar-coated; skipped ideas listed WITH rationale; past work acknowledged; recommendations bounded by what the actual team can execute; dense, not bloated
- src: marketing-plan + references/methodology.md
- tier: 1 · homes: SM; CMO decision copy · kin: P1 + O24 (fog discipline) — the marketing-plan instantiation
- why: the honesty envelope that makes an fCMO artifact trustworthy.

### `mk-budget-from-goal-math` — Set marketing budget defensibly by one of two methods — revenue-based (%-of-ARR bands) or goal-based (reverse-engineer from the revenue target: forces the "is the goal funded?" conversation — preferred seed→A); always add 10–20% experimental on top (funds the next channel before the current one plateaus); blended CAC must include salaries/tools/retainers, never just ad spend; no CAC history → baseline = one year of revenue from the smallest paid plan
- src: marketing-plan references/budget-planning.md (all bands/formulas repo's claims, unverified)
- tier: 2 (formulas) + 3 ⚙ (the % bands) · homes: SM + RD-plan; CMO owns the budget call
- why: replaces budget-by-vibes with two named methods and an honesty question.

### `mk-funding-stage-unlocks` — Every plan names what changes when funding closes (stage-tiered spend/capability ladders, category-adjusted) — investor-friendly and operationally honest; and if the client is over-funded for stage, don't pad the budget to match — recommend the right work and return excess capacity
- src: marketing-plan references/funding-stage-unlocks.md (tier $ figures repo's claims, unverified, ⚙)
- tier: 3 ⚙ (the ladders) + tier-1 (don't-pad) · homes: SM + RD-plan
- why: the don't-pad stance is a counter-incentive opinion worth owning explicitly.

### `mk-s-curves-not-hockey-sticks` — Real growth is S-curves with plateaus: name the current phase ($0–10K grueling / $10K–100K treacherous middle / $100K–1M acceleration), describe linear-punctuated-by-step-functions honestly (never promise exponential), start the next S-curve (channel × product × market) while the current one still grows, and don't conflate growth with growth RATE — declining % on a growing base is arithmetic, not failure
- src: marketing-plan references/growth-patterns.md (phase thresholds repo's claims, unverified)
- tier: 2 · homes: CMO + RD-plan
- why: expectation-setting doctrine at decision altitude.

### `mk-first-marketing-hire` — First marketing hire is a π-shaped strategist (two deep skill sets), never a tactician; title conservatively (Manager/Lead, not VP/CMO — inflated titles paint the org into a corner); strategy stays in-house, execution goes to contractors/niche agencies pre-Series-A; NEVER outsource positioning — conviction must come from the team; measure output, not headcount
- src: marketing-plan references/team-and-agency-model.md
- tier: 2 · homes: CMO + RD-plan
- why: org-design one-way doors; the never-outsource-positioning carve-out is the sharpest line.

### `mk-current-state-rubric` — Score the client's current state against a fixed 17-section rubric (0–5), but read the SHAPE, not the total — an early-stage Ads=0 reflects funding stage, not failure
- src: marketing-plan references/current-state-rubric.md
- tier: 2 · homes: RD-plan
- why: an instrument; shape-not-total is the interpretive opinion.

### `mk-kill-criteria-everywhere` — Every channel and initiative ships with kill criteria, and KPI targets must be decision-triggering ("if missed, what does that mean?") — "improve retention" is not a target
- src: marketing-plan references/measurement-framework.md; north-star: don't default to ARR/MRR — those are outcomes, not norths
- tier: 1 · homes: CMO + SM · kin: O23 (slice-by-verifiability) applied to marketing initiatives
- why: the discipline most plans omit, by the repo's own admission.

### `mk-agentic-stack-thesis` — A small team + skill library + wired integrations outputs the work of a 15–20-person marketing org — but a plan can't claim the thesis if the stack isn't wired: prove it with a concrete event, not an abstract claim
- src: marketing-plan references/ops-stack-mapping.md (equivalence repo's claim, unverified)
- tier: 2 · homes: CMO · kin: M0 — this is the marketing-lane version of promode's own thesis; the "can't claim it unwired" honesty tooth is the part worth ratifying
- why: aligns the lane with promode's identity and guards against overselling it.

### `mk-forecasts-are-guesses` — Under ~$100M ARR all forecasts are educated guesses: budget and annual goal honestly, treat month-by-month projections as illustrative
- src: marketing-plan references/budget-planning.md (threshold repo's claim, unverified)
- tier: 3 (contrarian anti-forecasting stance) · homes: CMO
- why: protects plans from false precision — pairs with mk-operationally-honest-plans.

---

## 11. Marketing loops (recurring automation)

### `mk-loop-anatomy-or-liability` — A scheduled marketing workflow is only a loop if all nine anatomy parts are filled (cadence, acts-when, purpose, body, self-check, state/idempotency, stop/bail-out, output, skills) — a loop missing a stop condition, self-check, or state handling is a liability, not an asset; the check-cadence/acts-when split is load-bearing: most runs of a good loop are "checked, nothing to do"
- src: marketing-loops
- tier: 2 · homes: SM + RD-loops
- why: the named anatomy is repo-idiosyncratic; the liability framing is the opinion.

### `mk-cadence-matches-signal` — Match loop cadence to how fast the signal actually changes (rankings weekly, ad fatigue 2–3 days, churn daily/on-trigger, content decay monthly), never to how often you'd like an update — over-frequent loops are the most common failure: busywork, burned budget, trained-to-ignore output
- src: marketing-loops
- tier: 2 · homes: SM + RD-loops
- why: the anti-noise discipline that keeps automation honest.

### `mk-when-not-to-loop` — Don't loop when strategy/creative direction is the real work (loops maintain and optimize; they don't set positioning), when the signal is too sparse to be significant, or when nobody acts on the output — a vanity loop is worse than nothing: delete it
- src: marketing-loops
- tier: 1 · homes: SM; CMO decision copy
- why: scope guard on the whole lane.

### `mk-two-tier-loop-actions` — Classify every loop action: Tier-1 (read/analyze/draft/stage) runs unattended; Tier-2 (spend/send/publish/delete/settings) is gated behind a human checkpoint unless explicitly authorized with caps + allowlists; an always-escalate list (crisis mentions, newsjacking near tragedy/politics, high-value accounts, revenue anomalies) overrides ALL authorization; every loop has a kill switch; never log raw PII in loop state
- src: marketing-loops + references/loop-guardrails.md
- tier: 2 · homes: SM + RD-loops · kin: **O11 (rule-of-two)** — this is its marketing-automation instantiation; ratify the mapping, don't fork the principle
- why: the safety envelope for autonomous marketing; the strongest promode-fit in the corpus.

### `mk-loop-state-or-double-act` — Durable state is non-negotiable for anything scheduled: watermark/dedupe/cooldown/in-flight patterns, or the loop double-acts and re-nags; log every run INCLUDING no-action runs (the run-log is the vanity-loop detector); on first run set the watermark to now — never backfill-blast history
- src: marketing-loops references/loop-state.md
- tier: 2 · homes: SM + RD-loops
- why: idempotency doctrine; the no-backfill rule prevents the classic first-run disaster.

### `mk-loop-rollout-order` — Adopt loops in a fixed order: foundation (tracking-QA + weekly review) → retention → conversion → acquisition → monetization — acquisition loops on a leaky funnel are waste, and broken tracking makes every downstream loop act on lies; start with one loop, prove it earns its keep; one loop OWNS each signal/action, others only flag (single A/B sink; never upsell a churning account)
- src: marketing-loops references/loop-orchestration.md
- tier: 2 · homes: SM + RD-loops
- why: sequencing + ownership doctrine that composes loops into a system.

### `mk-optimize-revenue-not-proxy` — Judge paid/experiment loops on revenue quality (revenue/ROAS, refunds, churn), never a proxy — never promote a variant that lifts conversion but lowers revenue-per-visitor
- src: marketing-loops references/loop-guardrails.md, loop-catalog.md
- tier: 1 · homes: SM · kin: mk-net-cash-over-roas (same stance, loop-scoped)
- why: proxy-metric drift is the default failure of automated optimization.

---

## 12. Copy editing

### `mk-seven-sweeps` — Edit in seven sequential single-dimension passes (Clarity → Voice → So What → Prove It → Specificity → Emotion → Zero Risk), looping back after each — multiple focused passes beat one unfocused review; enhance, don't rewrite: preserve the author's voice and core message
- src: copy-editing
- tier: 2 (named in the task brief as the tier-2 exemplar — the model half-knows it; sweep mechanics need the doc) · homes: SM + RD-copy
- why: the repo's flagship editing system.

### `mk-so-what-and-prove-it` — Every claim answers "so what?" with a benefit bridge, and every claim carries proof or gets softened — "trusted by thousands" (which thousands?); content that can't be made specific is probably filler: cut it
- src: copy-editing (sweeps 3–5 distilled)
- tier: 1 · homes: SM
- why: the two sweeps that do most of the work, portable as a standalone discipline.

### `mk-expert-panel-scoring` — High-stakes copy gets a multi-persona expert panel (3–5 relevant personas score 1–10 with specific critiques; revise lowest-first; iterate to 7+ each / 8+ average) — always for launch/pricing/high-traffic pages, skip for low-stakes
- src: copy-editing
- tier: 2 · homes: SM + RD-copy · kin: **R4 (judging-discipline)** — rubric-per-dimension applied to copy; ratify as its instantiation
- why: converts "review the copy" into a scored, iterating gate.

### `mk-plain-english-default` — Plain English is the default register: cut weak intensifiers and filler outright, replace pompous words (utilize→use), active voice, front-load; corporate speak is a bug — "how would a human say this?"
- src: copy-editing + references/plain-english-alternatives.md (the A–Z table itself stays behind, rejected as a word-table)
- tier: 1 · homes: SM
- why: commits the house to a register; the model knows how, the opinion is that it's the default.

---

## 13. Marketing council (simulated experts)

### `mk-value-is-the-disagreement` — A simulated advisor bench exists for the DISAGREEMENT: seat lenses that collide, always seat a designated dissenter, pre-wire named antagonists at construction, and require every dossier to carry documented blind spots and ≥1 unpopular position — an agreeing council is a mirror, not a board; the deliverable is the disagreement map (each conflict named as its underlying trade-off + what evidence would settle it)
- src: marketing-council + references/advisor-template.md, dossiers
- tier: 2 · homes: SM + RD-council · kin: O14 (parallel-peer-answers — never show either the other's answer) and R4's consensus-audit; same family, different mechanism
- why: the anti-sycophancy design of the whole pattern.

### `mk-simulation-grounding` — Persona simulation is labeled as simulation, grounded in documented positions only: no fabricated quotes; never state/imply a real person endorses the user's product; living advisors' stored positions are a snapshot — research-pass for anything recent; never launder an advisor's self-reported marketing claims into facts; attribute borrowed frameworks to their true originators; private-person advisors get positions only from the user, never invented
- src: marketing-council + references/advisors/*.md
- tier: 2 · ⚙ partial (living advisors' positions drift by design) · homes: SM + RD-council
- why: the integrity envelope that makes the pattern usable at all.

### `mk-council-decides-not-executes` — The council sets direction; it never writes the landing page — hand off to execution once direction is set; match bench size to stakes (twelve advisors on a headline is the anti-pattern); name-flavored generic advice (a take that survives a name swap) isn't a take
- src: marketing-council
- tier: 1 · homes: SM
- why: scope + quality gates on the pattern.

---

## 14. RevOps / pricing (spot-check survivors — both skills otherwise confirmed TUTORIAL)

### `mk-define-before-automate` — Get stage definitions, scoring criteria, and routing rules right on paper before building workflows — automating a broken process creates broken results faster; if marketing calls it an MQL but sales won't work it, the definition is wrong; an MQL requires fit AND engagement — neither alone; measure every team handoff (each is a leak with an SLA and an owner)
- src: revops
- tier: 1 (borderline — arguably model-derivable; kept because it's the one normative spine in an otherwise tutorial skill) · homes: SM
- why: if the marketing lane ever touches CRM/lifecycle work, this is the only opinion it needs; the rest is recipes.

*(Pricing: no candidate survived. The SKILL's normative core — value-based pricing, value-metric choice, Good-Better-Best — is model-known tier-1 with no repo-specific stance beyond it; both references are pure method walkthroughs. The one opinionated boundary — when offers do the work vs when pricing does — is captured as `mk-offers-vs-pricing-boundary` above.)*

---

## Rejected material (deliberately not mined — one line why each)

**Whole skills / files rejected:**
- **marketing-psychology (entire SKILL.md, no references)** — a ~60-model mental-model catalog (anchoring, loss aversion, JTBD…) with generic applications; model-derivable name-only material; no repo-specific stance worth a slug. The when-to-reach-for-which table is likewise derivable.
- **marketing-ideas (SKILL.md + ideas-by-category.md)** — 139-item tactic catalog; pure model-derivable inventory; confirmed no exceptions one level down (even #139 "customer language" restates Schwartz/Halbert doctrine carried elsewhere).
- **pricing references (research-methods.md, tier-structure.md)** — Van Westendorp/MaxDiff/conjoint walkthroughs, tier tables, feature-gating recipes: tutorial; TUTORIAL classification holds one level down. (Borderline noted: reverse-trial pattern + cc-upfront conversion benchmarks — presented as options, not stances; benchmarks perishable.)
- **revops references (all four)** — scoring-point tables, SLA-hour tables, routing trees, platform workflow recipes: model-derivable mechanics; TUTORIAL holds. The 5-min/21× speed-to-lead figure is retained only as (unverified) backing for mk-define-before-automate's handoff clause.
- **ads: ad-copy-templates.md, audience-targeting.md, conversion-tracking.md, platform-setup-checklists.md, rsa-output-spec.md** — copywriting formula catalogs (PAS/BAB), targeting how-to, pixel install recipes, setup checklists, RSA character-limit spec: model-derivable and/or perishable spec tables; the RSA file's CFM medical-compliance list is compliance detail better re-derived live.
- **ad-creative: platform-specs.md, generative-tools.md (tables), static-ad-templates.md (the 15 templates), creative-review-page.md (data model/HTML mechanics), imessage/motion production detail (ffmpeg flags, prompt formulas, SFX sourcing)** — spec sheets, perishable tool/pricing tables, template libraries, implementation mechanics; doctrine extracted, mechanics left behind.
- **cold-email: frameworks.md (named framework catalog), benchmarks.md (remaining benchmark/industry tables), personalization.md (4-level mechanics)** — name-only frameworks and perishable data tables; the connect-to-problem stance already carries the payload.
- **customer-research: source-guides.md (per-platform search operators, subreddit catalogs, SparkToro mechanics)** — perishable platform playbooks; the weighting/read-order doctrine was extracted, the operator lists were not.
- **ai-seo: content-patterns.md (block-template library), content-types.md (per-type checklists), platform-ranking-factors.md (robots.txt blocks, per-platform tactical checklists), monitoring-tool tables** — how-to templates and perishable bot/tool lists behind the extracted doctrine.
- **directory-submissions: directory-list.md (the catalog: DR values, tier lists), submission-tracker-template.csv, KPI target tables** — perishable directory catalog and tracker mechanics; the 6–27×/2.8×/2.7× stats stay quarantined as unverified repo claims inside the extracted candidates.
- **launch: Product Hunt case studies, launch checklists, post-launch tactic lists** — illustrations and checklists of the extracted ORB/phased doctrine.
- **marketing-plan: methodology.md (state machine, intake questionnaire, folder layout), plan-template.md (13-section template), client-types.md (archetype matrices), idea-cross-reference.md (139-idea mapping), ops-stack-mapping.md (skill/MCP tables), example-quietude.md (69KB worked example — skimmed; all doctrine present is client-specific application of the reference docs)** — process scaffolding and catalogs; the honesty/diagnosis/budget doctrine was extracted.
- **marketing-loops: loop-catalog.md (43 loop specs), loop-template.md (blank template)** — mechanical catalog + template; cross-cutting doctrine extracted into §11.
- **marketing-council: the 12 advisors' own frameworks** (Hormozi value equation, Dunford positioning, Sharp availability/double jeopardy, Godin purple cow/permission, Schwartz awareness/sophistication stages, Ogilvy/Hopkins/Halbert canon, Brunson funnels, Sutherland psycho-logic, Vaynerchuk attention arbitrage, Handley craft) — famous, model-known: tier-1 name-only at best, and the bench-construction doctrine (extracted) is where the repo's own opinion lives. Noted for tasks 31–35: several dossiers carry post-cutoff sourced positions (Dunford *Obviously Awesome* 2nd ed. 2026; Sutherland May-2026 talk; Hormozi *$100M Money Models* 2025) — tier-2/3 content if a council-like pattern is ever built, managed by the research-pass rule in `mk-simulation-grounding`.
- **copy-editing: checklist.md, the word-level cut/replace tables** — QA checklist + word tables behind the extracted sweeps/plain-English doctrine.
- **All tools/ material (65 CLI wrappers, ~100 integration guides, REGISTRY.md)** — out of scope: perishable tool catalog, no opinions.

---

## Not verified / assumptions

- **No quantitative claim was verified.** Every number above (6–27×, 69%, 3–6× TLA CTR, reply-rate declines, %-of-ARR bands, phase thresholds…) is the repo's practitioner claim, marked unverified; tier-3 items must keep that status if ratified.
- **Tier assignments are judgment, not probes.** Tier 1-vs-2 boundaries (e.g. Seven Sweeps, ORB, value-equation wrap) follow the brief's examples plus my read of frontier-model familiarity; the brief's own rule — probe the pinned model cold when unsure — has NOT been run for any item; the borderline ones to probe first: `mk-seven-sweeps`, `mk-orb-channels`, `mk-hook-is-three-components`, `mk-guarantee-by-business-model`, `mk-define-before-automate`.
- **Proposed homes assume the ratified lane shape** (CMO inherit + senior-marketer opus/high, no sonnet rung; CPO keeps goal hierarchy/personas/kill-build; positioning/growth/channel strategy at CMO) and are proposals only; RD-\<x\> doc names are placeholders for tasks 31–35 to consolidate (10 proposed docs will likely merge to fewer).
- **kin: flags are merge candidates, not decisions** — especially `mk-persona-proxy-ladder` (PD3/PD4), `mk-two-tier-loop-actions` (O11), `mk-expert-panel-scoring` (R4), `mk-marketing-context-file` (K7/K8), `mk-agentic-stack-thesis` (M0).
- Reference mining was fanned out to six parallel extraction agents; their dedupe against SKILL.md-level opinions was description-based, so a few near-overlaps were merged editorially here (e.g. edit-resets-learning folded into `mk-meta-decision-system`; offline-loop kept separate from net-cash>ROAS as the B2B mechanism vs the scaling frame).
- The inventory's TUTORIAL classification was spot-checked one level down for all four named skills: **pricing, revops, marketing-psychology, marketing-ideas all hold** (revops yields one borderline survivor, `mk-define-before-automate`).
