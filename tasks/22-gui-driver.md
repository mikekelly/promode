# gui-driver: dedicated GUI/browser-driving specialist def

## Brief
- **Orient** — `plugins/promode/agents/fast-worker.md` `<gui-driving>` (the content being transplanted — this def becomes T17's inline home) and its `<reporting>` block (byte-shared family). Routed doc it must cite: `${CLAUDE_PLUGIN_ROOT}/docs/discovery-to-determinism.md` (read the real file at `plugins/promode/docs/discovery-to-determinism.md` to get the conditional-read framing right).
- **Specify** — create `plugins/promode/agents/gui-driver.md`: frontmatter `name: gui-driver`, `model: sonnet`, `effort: medium`, description (drives browsers/GUIs with selector discipline; leaves deterministic artifacts; does not change production code). Body sections:
  1. `<reporting>` — verbatim byte-identical with the engineer/worker defs.
  2. Role — the GUI/browser-driving specialist: traversals, form-driving, visual checks, exploratory driving that feeds map/graph/recognizer artifacts. Task-doc Outcome discipline.
  3. `<gui-driving>` — transplant fast-worker's section as the core, expanded to standalone (it IS the T17 inline mirror now): **selector-based actions, never hardcoded coordinates** (+ why: coordinates drift, stable selectors/identifiers don't); validate each step against the live tree before the next; leave behind the reusable artifact the brief asks for (script, map edge, recognizer) rather than a one-off traversal; for map/graph/recognizer mechanics, first read `${CLAUDE_PLUGIN_ROOT}/docs/discovery-to-determinism.md`.
  4. Code-lane rule — same stance as the workers: production-code changes get stopped and reported for engineer re-dispatch (driving a GUI and writing the app are different dispatches).
  5. Principles-lite (evidence, stay-on-task) + escalation (~3 attempts family) + commit artifacts before reporting.
- **Why** — T17/d2d mechanics are specialist noise in every other def; a dedicated def keeps the discipline structurally delivered (M5) exactly where GUI work is dispatched, and frees the worker family to stay thin.
- **Verified vs assumed** — `${CLAUDE_PLUGIN_ROOT}` expands in plugin agent defs (probe P5, register). T17's canonical why lives in d2d (`w:d2d`) — the inline mirror carries the rule + short why, cites the doc for the full mechanics; don't duplicate the doc's content (K5).
- **Not / exit** — do NOT edit fast-worker.md (task 21 owns it), any other def, brief, register, README, scripts. Exit: file committed; report notes any wording you changed from the transplanted section and why.

## State
- **Established facts** — frontmatter ratified and exact.
- **Open constraints** — worktree-isolated: Outcome goes in YOUR worktree's copy of this doc.

## Outcome
Created `plugins/promode/agents/gui-driver.md` (new def only — no other file touched, verified via `git status --porcelain`).

Frontmatter exactly as specified: `name: gui-driver`, `model: sonnet`, `effort: medium`, plus a description (drives browsers/GUIs with selector discipline; leaves deterministic artifacts; does not change production code — flags for engineer re-dispatch).

Body sections, in the order the brief specified:
1. `<reporting>` — copied verbatim from `fast-worker.md`; verified byte-identical with `diff` (`awk` slice of both files between `<reporting>` markers, zero diff output).
2. `<your-role>` — GUI/browser-driving specialist framing: traversals/form-driving/visual checks/exploratory driving whose deliverable is a deterministic artifact (script/map edge/recognizer), not the traversal itself; task-doc Outcome discipline carried in "Done means".
3. `<gui-driving>` — transplanted fast-worker's one-paragraph version, expanded to three bullets (selector-not-coordinates + why, validate-against-live-tree, leave-behind-the-artifact) so it stands alone as the T17 inline home; closes with the `${CLAUDE_PLUGIN_ROOT}/docs/discovery-to-determinism.md` conditional read (plus its `ui-state-graph-edt.md` companion), read first to get the framing right per the brief.
4. `<code-lane>` — new section name (brief called it "code-lane rule" without giving a tag); states the driving-vs-writing-the-app distinction and routes production-code needs back to `fast-worker`/`senior-engineer`.
5. `<principles>` (evidence-over-assumptions, stay-on-task) + `<escalation>` (code-lane trigger, ambiguity, ~3 approaches, credentials/access) + a commit-before-reporting bullet folded into `<principles>` rather than a separate section, since the brief listed it as part of item 5's cluster rather than its own numbered section.

**Wording changed from the transplanted section, and why:** fast-worker's `<gui-driving>` was one paragraph (fits alongside its other worker sections); here it's split into three bullets and loses the "When driving a browser or GUI" lead-in (redundant once this whole def is GUI-driving) — done because this def *is* the T17 inline home per the brief (item 3), so the mechanics needed to read as complete and skimmable on their own rather than as one clause among many worker disciplines. The "why coordinates drift" parenthetical was expanded into a full clause per the brief's explicit ask ("+ why: coordinates drift, stable selectors/identifiers don't").

**Not verified / assumptions:** the `effort: medium` frontmatter field has no precedent elsewhere in `plugins/promode/agents/*.md` (checked via `grep -rl "effort:"` — no hits) — included exactly as the brief's "frontmatter ratified and exact" instructed, on the assumption the harness accepts an `effort` key in subagent frontmatter (not independently verified against harness docs, per the register's O13 model-tier language which mentions "effort levels" as a documented concept). Did not verify the file renders/loads correctly as a live plugin subagent (no harness restart/dispatch test performed) — static content review only.
