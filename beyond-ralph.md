# Beyond Ralph — Experiments in Claude Code Context Wrangling

## The Problem

Language models suffer from recency bias. As context grows, the model pays less attention to instructions at the top — your CLAUDE.md, your methodology, your project conventions. You've probably seen this: the agent follows your rules perfectly at first, then gradually "forgets" them as the conversation lengthens.

Smaller context means better attention to the instructions that matter. Promode is an experiment in keeping the main agent's context as small as possible.

## Claude Code's Default Patterns

Claude Code's system prompt encourages checking on subagent progress:

> Use `TaskOutput` to read the output later... Use `tail` to see recent output.

> To check on the agent's progress or retrieve its results, use the Read tool to read the output file.

The problem: when you read a subagent's output file, the entire conversation floods back into your context. A subagent that read 30 files and debugged three test failures generates thousands of tokens. All of that is now in the main agent's context, pushing your CLAUDE.md further into the forgotten past.

Most of that output is *process*, not *outcome*. You don't need to know what files the subagent read. You need to know whether it worked.

## The Approach

The main agent's job is orchestration, not execution. It should:

1. Understand what needs to happen
2. Delegate
3. Go passive
4. Wake up when results arrive

This has a second benefit: subagents start with clean context. They're not inheriting 50k tokens of accumulated conversation history. A subagent with focused context and a clear task tends to perform better than one that's carrying baggage.

## Pattern 1: Actually Async Subagents

Claude Code's Task tool supports `run_in_background: true`. The system prompt mentions it, then suggests using `TaskOutput` or `Read` to check progress. That's polling, not async.

Instead: set `run_in_background: true` and stop. Don't check progress. Don't tail the output. The subagent runs in its own context. The main agent waits.

## Pattern 2: Task Notifications

How do you know when the subagent finishes?

Claude Code injects `<task-notification>` elements into your conversation when background tasks complete. The main agent doesn't poll. It goes dormant until the notification arrives.

The instruction to the main agent:

> **NEVER poll subagent progress.** When a subagent completes, the system injects a `<task-notification>` into your conversation that wakes you automatically.

## Pattern 3: Summaries, Not Transcripts

Even with notifications, the subagent's result can be large. If you read the output file directly, you get the full conversation.

The fix: require subagents to end with a summary. Every phase agent in promode has this instruction:

> **Your final message MUST be a succinct summary.** The main agent extracts only your last message. End with a brief, information-dense summary: what you achieved, files changed, any issues. No preamble — just the facts the main agent needs to continue.

The subagent can be verbose during its work. The main agent only sees the conclusion.

## Pattern 4: Last-Line Extraction

When a background task completes, Claude Code writes the conversation to an output file. Don't read it with `Read` or `TaskOutput`. Instead:

```bash
tail -1 {output_file} | jq -r '.message.content[0].text'
```

`tail -1` takes only the last line. `jq` extracts the text. Everything else is discarded — maybe 200 tokens instead of 20,000.

## The Workflow

1. Main agent creates tasks
2. Main agent spawns subagents with `run_in_background: true`
3. Main agent goes passive — no progress checks
4. `<task-notification>` arrives when subagent completes
5. Main agent extracts summary with `tail -1 | jq`
6. Repeat

The main agent doesn't read source files directly, doesn't run tests directly, doesn't debug directly. It orchestrates and delegates.

## Beyond Ralph

Ralph-style summarization compresses context after it's been consumed. These patterns try to prevent consumption in the first place.

It's not a complete solution — there's friction, and subagents need careful prompting to follow the summary discipline. But for longer sessions where methodology drift is a problem, it seems to help.

---

*Promode is experimental. The default Claude Code patterns optimize for information preservation; these patterns try to optimize for attention preservation. Different tradeoffs for different situations.*
