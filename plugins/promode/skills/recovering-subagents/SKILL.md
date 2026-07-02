---
name: recovering-subagents
description: "Inspect a subagent's transcript compactly — without loading it whole. Use when a background subagent failed or stalled and you need to look inside its run to recover, AND as the evidence tooling for after-action reviews: verifying a self-debrief against the record, autopsying a dead or oversized run, or extracting bulk stats across transcripts for a cross-session retrospective."
---

When a subagent fails or stalls and its `<result>` summary isn't enough to act on, you need to look inside its run — but the transcript (the `.output` file whose path arrives in the `<task-notification>`) is large JSONL, and reading it whole overflows your context. This skill exists to honour the promode principle that **context is precious**: it lets you inspect the run one step at a time instead of paying the full transcript's context cost.

Use the bundled inspector instead. It takes the **absolute** output-file path (copy it from the notification) and prints one step at a time, compactly, so you walk back from the latest step and expand only what you need. Run it from this skill's directory (the base directory is shown when this skill loads):

```
scripts/inspect-agent.sh <output-file>             # the latest step (the "tip")
scripts/inspect-agent.sh <output-file> <step>      # that step, compact
scripts/inspect-agent.sh <output-file> <step> full # that step, full JSON
```

Steps are 1-indexed transcript lines, chronological; the tip is the latest. Every call prints the current tip, so if a *running* agent has advanced past where you're walking, you'll see it.

## Backtrack from the tip

1. Start at the **tip** to see where the agent ended up — the failure, or its current position.
2. Walk **backwards** one step at a time (`<step>` = tip−1, tip−2, …) until you find the first step that went wrong: the decision or tool call that made the failure inevitable.
3. `full`-expand only the one or two steps you actually need the detail of.
4. Decide the recovery — re-dispatch with a tighter scope, hand it to `promode:debugger`, fix the prompt, etc.

Never read the raw `.output` file directly — it's the full transcript and will overflow your context. This inspector is the context-safe way in. (Requires `jq`.)

## Retrospective evidence (AARs)

The same inspector serves the *evidence* side of after-action reviews — verifying a re-woken agent's self-debrief against what the transcript actually shows, or autopsying a run that can't testify (dead, stalled, or so oversized that re-waking it would replay an enormous, degraded context). Backtrack from the tip exactly as for recovery; the question changes ("where did it struggle / does its story hold?"), the mechanics don't.

For **bulk stats** across one or many transcripts (cross-session retrospectives), step-at-a-time is too slow — use these extractions instead. Format gotchas they already encode: there is **no** top-level `tool_use`/`tool_result` line type (top-level `.type` is only `assistant`/`user`/`attachment`); tool calls and results are **content blocks** inside `.message.content[]`; `tool_result` blocks arrive on **user**-type lines; and `tail -1` is NOT a reliable summary (the last line may be a tool_result or interrupt).

```bash
# Final assistant message (last assistant turn's text blocks)
jq -rs 'map(select(.type=="assistant")) | last | .message.content[] | select(.type=="text") | .text' FILE

# Tools used, with counts
jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="tool_use") | .name' FILE | sort | uniq -c

# Files changed
jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="tool_use" and (.name|test("Edit|Write|NotebookEdit"))) | .input.file_path' FILE

# Tool errors
jq -r 'select(.type=="user") | .message.content[]? | select(.type=="tool_result" and (.is_error==true)) | .content' FILE
```

Often you don't need the file at all: the task-notification already carried the agent's final message (`<result>`) and usage (`<usage>`: tokens, tool_uses, duration).
