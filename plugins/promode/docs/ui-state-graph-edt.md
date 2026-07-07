# UI state-graph tier: Explore → Distill → Traverse (EDT)

The Tier-2 mechanics for [discovery-to-determinism.md](discovery-to-determinism.md) (beside this doc) — how the flywheel is realised concretely against a running GUI. **Client-agnostic:** everything here sits above a tiny adapter (see *The client-adapter seam*), so the same model serves mobile, web, or any other surface.

This tier is **verification-only and surgical** — it exists for the narrow class of defect that only manifests through the real running GUI. Most coverage belongs in the headless Tier-1 client driving the operator seam; reach for this tier only when the gate in `discovery-to-determinism.md` is genuinely met.

## Model the app as a state graph

- **State (node)** — a meaningful client state (a screen or sub-state), identified by a **recognizer**: a *stable, surfacing, unique* selector over the *observed* UI (an element id/testID and/or distinctive text).
- **Edge (traversal)** — the action sequence that moves from one state to another. The edge's postcondition is simply the destination state's recognizer.
- **Playbook** — a target/path; running it = traversing to that target.

## Explore → Distill → Traverse

- **Explore (agent, once).** An agent drives a *discovery client* — observe the screen, act on it — and follows its nose, learning the states, recognizers, and edges. This is the expensive, non-deterministic step; you pay it once and crystallise the result.
- **Distill (agent → code).** Write the discovered graph as **selector-based code — never hardcoded coordinates.** Coordinates drift on any layout change; selectors are resolved to live coordinates *on every run*, which is what makes the artifact durable. Distill **one edge at a time**, validating each against the live tree before adding the next — the same vertical, one-test-at-a-time discipline the implementing agents use, applied to map-building. Never batch a whole imagined graph.
- **Traverse (deterministic, no agent).**
  - `whereAmI()` — observe once, return the state whose recognizer matches (strict: zero matches is `unknown state`, multiple is `ambiguous state`; both dump the observed tree and exit non-zero). This is the orientation primitive; it also enables recovery and "explore from the frontier."
  - `traverse(goal)` — detect the current state, compute the edge path (BFS over edges), execute each edge action, then **assert the next state's recognizer within a timeout.**

## The fail-fast contract (core)

On a missed recognizer or any step error, `traverse` must:
1. **Throw a precise error** — `failed reaching <STATE> at edge <FROM>→<TO>: <reason>` — *with a dump of what was actually on screen* (the observed element tree).
2. **Leave the system frozen at the failure point** — no reset, no cleanup.
3. **Exit non-zero.**

The frozen state + precise error are what make every failure a *localised, diagnosable, re-discoverable* moment — they hand the next agent the exact fragment to re-explore (the flywheel's Arrow 2, mechanism 3). A coarse "the app is broken" cannot point anywhere.

### Lifecycle caveat — freeze is discovery-only
The **freeze-no-reset** behaviour is for *manual or agent-driven discovery*, where a human/agent wants to inspect the wreck. It does **not** transfer to a CI acceptance run (which must reset and isolate between tests — see *hard-won rules*) nor to a recovering production agent (which needs idempotency, not a frozen world). What generalises is the **precise failure signal**; the freeze is a debugging affordance, not a universal rule.

### What a failure means — triage, don't just re-run

A failed `traverse` is one of three, and only judgement tells them apart — re-running blindly learns nothing:
- **Flake** — a non-surfacing or ambiguous recognizer, a race, or leftover shared state. Fix the recognizer or the isolation; a flaky graph trains you to ignore red.
- **Legitimate change** — the app's flow or labels moved on purpose. Re-explore only the changed fragment (launch from the frontier) and re-distill that edge/recognizer.
- **Regression** — the app broke. Raise it; the graph just earned its keep as a navigation/regression alarm.

The precise, frozen failure (the recognizer that missed + the on-screen dump) is exactly what makes this triage cheap — it usually tells you which of the three before you touch anything. This is the [closing-the-loop](discovery-to-determinism.md) discipline made concrete for the UI tier.

## The client-adapter seam (what makes it generalise)

Keep the graph + traverser + `whereAmI` **platform-agnostic** behind a tiny interface — conceptually:

```
observe() -> element-tree      // stable ids + text for the current screen
act(action)                    // tap / type / scroll / ...
```

Implementations:
- **mobile (native/RN)** → a device-control toolkit that returns the on-screen element tree with stable ids;
- **web** → a browser-automation tool returning the DOM / accessibility tree;
- **other surfaces** → their own adapter.

Only the adapter is platform-specific; everything above it is reusable. (But per the honest caveat in `discovery-to-determinism.md`, do **not** extract that "reusable above-the-adapter core" into a shared library until a *second* adapter has actually exercised it — one app is not evidence for the abstraction.)

## Hard-won implementation rules (these cost real time)

- **Recognizers must be *surfacing* and *unique*.** Not every identifier you set in source appears in the observed tree — container/wrapper elements often don't surface; interactive leaves and text reliably do. And a recognizer that *also* matches an earlier state will misfire. Pick a selector that (a) actually appears in the observed tree and (b) is unique to that state. **Validate against the live tree, not against source or synthetic fixtures.**
- **Determinism needs clean, isolated state — the expensive part of an acceptance suite, not the graph.** A dev-time "drive to a state" helper can be sloppy about leftover data; a CI acceptance suite cannot. Require a **real reset primitive** (per-test clean state) and **per-test data isolation**. Watch for *hidden* shared state: a backend that persists records keyed by some input means reusing that input silently changes behaviour on the second run — use fresh data per run, or seed/teardown. (This is the `promode:environment-manager`'s domain.)
- **Reproducible environment is a prerequisite, not a detail.** GUI tiers depend on a live app + its runtime services; document and automate bring-up, and expect this to **dominate the cost/flakiness budget.** Tier-1 headless exists precisely to keep most coverage out of this expensive regime.
- **Verify the fail-fast property by perturbation.** Part of building the artifact is deliberately breaking one recognizer and confirming the suite halts at *exactly* that node and reports precisely. In discovery mode it should also freeze; in CI it should fail precisely, reset/isolate, and exit non-zero. An untested fail-fast contract is an assumption.

## Worked example (illustration, not the subject)

The methodology was extracted from a React Native POS app, "TinyTill":
- **Tier 1 (headless):** a Cucumber/`system-tests` suite run by a deterministic Node client that drives the app's operation-executor + backend over real signing primitives — **no GUI**. Business journeys, fast, in CI.
- **Tier 2 (UI state-graph):** a `qa-playbooks/` harness built exactly on EDT — a `Client` over a device-control CLI; a parsed element tree → selectors; a `graph` with `State`/`Edge`/`whereAmI`/`findPath` (BFS)/`traverse` with the fail-fast contract; a first playbook `fresh-onboard` driving a clean install → POS through a 7-state chain, recognizers keyed to surfacing/unique ids, reset via a clean-wipe.
- **Why Tier 2 exists at all:** it was motivated by real defects that **passed every headless and unit test and still broke the running app** — navigation gating on never-written state; a provider mounted outside its context; dropped persistence on restart. That is the canonical "only the GUI can prove it" case, and the *only* justification for promoting behaviour to this slow tier.
