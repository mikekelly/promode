**Beyond Ralph — Experiments in Claude Code Context Wrangling**

*TL;DR: Promode is a Claude Code plugin that encourages the main agent to jealously guard its context from pollution — carefully delegating work and collecting subagent feedback, working with the foibles of the Claude Code harness rather than against them.*

[github.com/mikekelly/promode](https://github.com/mikekelly/promode)

**The Problem**

Language models suffer from recency bias. As context grows, the model pays less attention to instructions at the top — your CLAUDE.md, your methodology, your project conventions. You've probably seen this: the agent follows your rules perfectly at first, then gradually "forgets" them as the conversation lengthens.

But it's not just recency bias. Today's frontier models seem to reason better with smaller context windows overall. This suggests a division of labour: reserve the main agent for high-level brainstorming, planning, and orchestration, while subagents with clean, focused context handle specific tasks with maximum reasoning power.

Promode is the result of my experiments prompting around the intricacies of Claude Code's capabilities and constraints — finding ways to keep context small where it matters most.

**Claude Code's Default Patterns**

Claude Code's system prompt tells the main agent to check on subagent progress using TaskOutput, or to tail the output file for updates.

The problem: when the main agent reads a subagent's output, the entire conversation floods back into its context. A subagent that read 30 files and debugged three test failures generates thousands of tokens. All of that ends up in the main agent's context, pushing your CLAUDE.md further into the forgotten past.

Most of that output is *process*, not *outcome*. The main agent doesn't need to know what files the subagent read. It needs to know whether it worked.

**The Promode Approach**

The main agent's job is orchestration, not execution. It should understand what needs to happen, delegate, go passive, and wake up when results arrive.

This has a second benefit: subagents start with clean context. They're not inheriting 50k tokens of accumulated conversation history. A subagent with focused context and a clear task tends to perform better than one that's carrying baggage.

**Pattern 1: Actually Async Subagents**

Claude Code's Task tool supports running in the background. The system prompt mentions it, then tells the main agent to use TaskOutput or tail to check progress. That's polling, not async.

Promode instructs the main agent differently: run in background and stop. Don't check progress. Don't tail the output. The subagent runs in its own context. The main agent waits.

A side benefit: fully async delegation returns the conversation to you while work is in flight. You can talk to the main agent, adjust its approach, or kick off additional subagents — all while existing work continues in parallel.

**Pattern 2: Task Notifications**

How does the main agent know when the subagent finishes?

This is an often overlooked — and powerful — aspect of the Claude Code harness: when background tasks complete, Claude Code injects task-notification elements into the conversation containing the subagent's final message. This automatically re-prompts the main agent and pulls it out of an idle state, even when it would otherwise be waiting for user input.

Instead of polling, the main agent goes dormant. Promode's instruction: *Go passive — task-notification will wake you with the result.*

**Pattern 3: Summaries, Not Transcripts**

Even with notifications, the subagent's result can be large. If the main agent reads the output file directly, it gets the full conversation.

The fix: promode instructs subagents to end with a summary. Every phase agent has this directive: *Your final message must be a succinct summary. The main agent extracts only your last message. End with a brief, information-dense summary: what you achieved, files changed, any issues. No preamble — just the facts the main agent needs to continue.*

The subagent can be verbose during its work. The main agent only sees the conclusion.

**The Workflow**

The main agent creates tasks, spawns subagents in the background, then goes passive with no progress checks. When a task-notification arrives with the subagent's summary, the main agent continues. No file reading, no extraction — just the summary delivered directly.

The main agent doesn't read source files directly, doesn't run tests directly, doesn't debug directly. It orchestrates and delegates.

**Complementary to Ralph**

Ralph-style autonomous loops keep the agent running by feeding prompts back in when it tries to exit. Promode is complementary: while Ralph handles persistence across sessions, promode focuses on keeping the main agent's context clean within sessions by delegating aggressively and extracting only summaries.

It's not a complete solution — there's friction, and subagents need careful prompting to follow the summary discipline. But for longer sessions where methodology drift is a problem, it seems to help.

*Promode is experimental. The default Claude Code patterns optimize for information preservation; these patterns try to optimize for attention preservation. Different tradeoffs for different situations.*
