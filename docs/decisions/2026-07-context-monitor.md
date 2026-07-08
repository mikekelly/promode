# Decided: main-agent context-pressure advisory via a Stop hook (2026-07 context-monitor)

A decision node (conventions: [agent-knowledge-wiki.md](../../plugins/promode/docs/agent-knowledge-wiki.md) → decision/rejected-work capture). Maintainer-ratified 2026-07-08. Register opinion: **O43 `context-pressure-advisory`**. Implementation: [`plugins/promode/hooks/context-monitor.sh`](../../plugins/promode/hooks/context-monitor.sh) (+ `scripts/test-context-monitor.sh`), wired on the `Stop` event in [`plugins/promode/hooks/hooks.json`](../../plugins/promode/hooks/hooks.json); brief doctrine in `PROMODE_MAIN_AGENT.md` `<context-pressure-advisory>`.

## What was decided

A project-shipped `Stop` hook surfaces the **main agent's live context occupancy** at its yield boundary, so the main agent can *prepare durable state, then advise the user* before a context wipe — rather than blowing past the window mid-task.

- **Occupancy source.** The latest assistant message's `usage` in the transcript — `input_tokens + cache_read_input_tokens` (NOT a sum across messages; each message's input already *is* the full context fed to it) — over a 1M-token window (config constant). The bulk lives in `cache_read_input_tokens`; `input_tokens` is tiny.
- **Band ladder.** One ordered config array `CTX_BANDS=(40 55 70 80 90)`. Band **rank** = count of thresholds ≤ current pct (rank 0 = below 40 = floor = silent). Bands narrow to 10% near the ceiling; no degenerate literal-100 threshold (rank 5 covers 90–100).
- **Debounce = level-triggered, transcript-derived (no external state).** Inject iff `current_rank > prior_max_rank`, where `prior_max_rank` = the highest rank across prior **turn-endings** (the last assistant `usage` before each genuine user prompt) since the last `compact_boundary`. Level-triggered (highest reached), NOT edge-triggered (adjacent-pair): a band crossing that lands mid-turn still fires exactly once. A `compact_boundary` re-arms all bands (only turn-endings after it are considered). The current turn's own mid-turn readings are excluded.
- **Message.** ONE neutral factual line for every non-floor band: `promode context-monitor: context ~<pct>% of the window.` No urgency wording — the hook states only the fact; escalation is carried by the rising number.
- **Prepare-then-advise doctrine (in the brief).** On fire, the main agent makes durable state survive a wipe (run `/promode:handoff`, confirm task docs + WIP committed), *then* tells the user the occupancy and that `/compact` / `/clear` are available, with a recommendation. Advisory, not a gate; all whether/when-to-raise judgement stays the agent's. Fires at the yield boundary so prep happens in a dedicated turn, never mid-request.
- **Main-agent isolation is structural.** The hook is registered on `Stop` only; `Stop` fires for the main agent, subagents fire `SubagentStop`. No `agent_id` gating (real `Stop` stdin carries none). A `stop_hook_active` loop guard caps injection at one per stop-sequence.

## Harness facts it rests on (⚙ — live-verified on Claude Code 2.1.202, 2026-07-08)

Undocumented unless noted; re-verify on any Claude Code / model change.

- **(a) `Stop` is main-agent-only.** Across repeated turn-ends a project `Stop` hook fired only for the main session's transcript, never for a deliberately-spawned subagent; subagents fire `SubagentStop`. Real `Stop` stdin has **no `agent_id`** field (the earlier doc-research assumption was wrong); fields observed: `session_id, transcript_path, cwd, prompt_id, permission_mode, effort{level}, hook_event_name, stop_hook_active, last_assistant_message, background_tasks, session_crons`.
- **(b) `additionalContext` on `Stop` FORCES a continuation** (an extra agent turn) and sets `stop_hook_active: true` on the re-fire — it is NOT a silent next-turn footer. Proven by a spike that looped (13.4%→13.7%→14.9%) until the flag was honoured. The silent-injection path is `UserPromptSubmit`/`SessionStart`, not `Stop`. Hence the loop guard, and the "costs one agent turn / speaks up" UX.
- **(c) `Stop` injections persist in the transcript** as `type:"attachment"` with `attachment.type:"hook_additional_context"` (`hookEvent:"Stop"`, `content:[...]`). Undocumented, and **shared with the SessionStart brief hook** — which is why the debounce reads only `usage` + `compact_boundary` and does NOT parse our own injections.
- **(d) `compact_boundary`** — a `system` entry `subtype:"compact_boundary"` (`content:"Conversation compacted"`, `compactMetadata.trigger`) — is the re-arm backstop; live-confirmed for **both** `auto` and `manual` compaction, in the **same file** (followed by a `user` entry `isCompactSummary:true`). This is the one documented fact.
- **(e) Genuine-prompt discriminator** (turn boundary): `type=="user"` AND not `isMeta`/`isCompactSummary`/`isSidechain` AND `message.content` is a string (or an array with no `tool_result` block). Tool-result user entries and the compaction summary are NOT boundaries.
- **(f) Per-model windows + effort levels** (docs-confirmed): Fable 5 / Opus 4.8 / Sonnet 5 each 1M-token window, effort low/med/high(default)/xhigh/max.

## Decision log — rejected alternatives (durable reasons; don't re-suggest)

- **State-file debounce** (per-session `<session_id>.bands` file recording emitted bands). Rejected: out-of-band state to manage/clean up, keyed by session id, doesn't re-arm on compact/clear for free. The transcript already carries the history — derive from it.
- **Parse our own injected `hook_additional_context` attachments** to recover fired bands. Rejected: fragile coupling to an *undocumented* attachment shape **shared with the brief hook** (needs a 3-part discriminator), plus a wording-sync hazard (the debounce would break silently if the message text changed). Reading only `usage` + `compact_boundary` avoids both.
- **`UserPromptSubmit` silent footer** (inject the advisory with no continuation). Rejected: it fires *as the user's turn begins*, so it collides with the user's request and cannot do prepare-then-advise in a dedicated turn. The whole value is preparing at the yield boundary; `Stop` is the only event there.
- **Edge-triggered adjacent-pair debounce** (compare the last two readings). Rejected: misses a band if the crossing lands on a suppressed continuation turn or mid-turn. "Highest level reached since last compact" is robust to that.
