---
name: recovering-subagents
description: "Inspect a failed or stalled subagent's transcript compactly to recover. Use when a background subagent failed, stalled, or its <result> summary isn't enough to decide what to do next, and you need to look inside its run without loading the whole transcript into your context."
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
