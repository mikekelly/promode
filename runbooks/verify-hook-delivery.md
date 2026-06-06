# Runbook: Verify hook delivery (10k cap + isolation + chunk registration)

What this is: how to confirm the main-agent brief still ships correctly after editing the brief
(`plugins/promode/PROMODE_MAIN_AGENT.md`) or the hooks (`plugins/promode/hooks/`). This runbook
defers to a script — the script *is* the check.

## The one command

```
./scripts/check-hooks.sh
```

Green means all three hook-delivery invariants hold. CI runs exactly this on every push and PR
(`.github/workflows/hook-output-limits.yml`), so a red local run is a red CI run.

## The three invariants it enforces

`check-hooks.sh` runs three sibling checks (each owns one invariant, each exits non-zero on
violation):

1. **10k cap** — [`scripts/check-hook-output-limits.sh`](../scripts/check-hook-output-limits.sh):
   every hook output string (each brief chunk) stays under Claude Code's 10,000-char limit, or it is
   silently truncated to a preview and the tail is dropped. Fix a red here by adding/moving a
   `<!-- CHUNK -->` marker at a section boundary in the brief.
2. **Brief isolation** — [`scripts/check-hook-agent-gating.sh`](../scripts/check-hook-agent-gating.sh):
   the brief reaches the **main agent only** — the hook withholds it whenever stdin carries an
   `agent_id` (a subagent).
3. **Chunk registration** — [`scripts/check-hook-chunk-registration.sh`](../scripts/check-hook-chunk-registration.sh):
   every `<!-- CHUNK -->`-delimited part is registered in `hooks.json` (chunks `1..N`, where
   N = number of markers + 1, in each matcher). Miss one and the tail is silently dropped while the
   size check still passes — so this check exists to catch that gap.

## When to run it

- After any edit to the brief or to anything under `plugins/promode/hooks/`.
- As the verify step in [cut-a-release.md](cut-a-release.md), [add-a-subagent.md](add-a-subagent.md),
  and [sync-a-shared-principle.md](sync-a-shared-principle.md) when those touch the brief.

## See also

- Runner: [`scripts/check-hooks.sh`](../scripts/check-hooks.sh)
- CI: [`.github/workflows/hook-output-limits.yml`](../.github/workflows/hook-output-limits.yml)
- Hub: [`RUNBOOKS.md`](../RUNBOOKS.md)
