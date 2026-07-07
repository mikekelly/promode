#!/usr/bin/env bash
# =============================================================================
# spike-context-probe.sh — DISPOSABLE LIVE-PROBE SPIKE. NOT production infra.
# =============================================================================
# Increment 1 of the promode "context-monitor" feature, framed as a spike: its
# job is to VERIFY three harness facts against the actually-running Claude Code
# before we build the real thing. The *answer* is the deliverable; delete this
# script (and its Stop-hook wiring in .claude/settings.json) once the facts are
# confirmed. Do NOT grow thresholds/debounce/brief-wiring here — that is the
# next increment, and absorbed code re-enters through TDD.
#
# Facts under test (doc-research, NOT yet live-verified):
#   1. A project Stop hook fires when the MAIN agent ends a turn, and its stdin
#      carries `transcript_path` + an `agent_id` field (absent/null = main,
#      present = subagent).
#   2. `hookSpecificOutput.additionalContext` emitted from a Stop hook reaches
#      the model on the next turn — proven by the distinctive marker below
#      appearing in the main agent's next-turn context.
#   3. The transcript JSONL's latest assistant entry carries usage.input_tokens
#      + usage.cache_read_input_tokens, whose sum is the current context
#      occupancy. (Confirmed by inspection: input_tokens is tiny, the bulk lives
#      in cache_read_input_tokens.)
#
# On each firing this: (a) appends raw stdin to a scratch log, (b) reads the
# tail of transcript_path and extracts the LATEST assistant message's usage
# (NOT a sum — each message's input already represents its full fed context),
# (c) logs agent gating + computed %, (d) for the MAIN agent only, emits a
# distinctively-marked additionalContext nudge.
#
# Pure logic lives in functions below and is unit-tested with fixtures in
# scripts/test-spike-context-probe.sh (main() is guarded so sourcing is safe).
# =============================================================================
set -uo pipefail

SPIKE_MARKER="SPIKE-PROBE-7F3A"
# Stable, session-independent, clearly-scratch path so firings from the real
# interactive session all land in one place regardless of session id.
SPIKE_PROBE_LOG="${SPIKE_PROBE_LOG:-/private/tmp/claude-501/-Users-mike-code-promode--claude-worktrees-happy-poitras-04fe12/spike-probe-7F3A.log}"
# Context window size in tokens (occupancy denominator). Overridable for tests.
CONTEXT_WINDOW_TOKENS="${CONTEXT_WINDOW_TOKENS:-1000000}"

# --- pure logic (sourced by the test; no side effects) ----------------------

# latest_usage_tokens <transcript_file>
#   Prints (input_tokens + cache_read_input_tokens) of the LATEST assistant
#   message in the transcript. NOT a sum across messages. 0 if the file is
#   unreadable, empty, or has no assistant message carrying usage.
#   Reads only the tail (never the whole file) and skips unparseable lines.
latest_usage_tokens() {
  local f="$1"
  [ -r "$f" ] || { echo 0; return; }
  tail -n 400 "$f" | jq -Rn '
    [ inputs
      | fromjson? // empty
      | select(.type == "assistant" and (.message.usage != null)) ]
    | if length == 0 then 0
      else ( .[-1].message.usage
             | (.input_tokens // 0) + (.cache_read_input_tokens // 0) )
      end' 2>/dev/null || echo 0
}

# tokens_to_pct <tokens>  -> occupancy as a percentage of the window, 1 decimal.
tokens_to_pct() {
  awk -v t="${1:-0}" -v w="$CONTEXT_WINDOW_TOKENS" \
    'BEGIN { if (w <= 0) w = 1; printf "%.1f", (t / w) * 100 }'
}

# pct_to_band <pct>  -> nominal | warn | critical.
#   SPIKE-arbitrary thresholds (nominal <70, warn 70..85, critical >=85) — the
#   real thresholds/debounce are the NEXT increment, deliberately not tuned here.
pct_to_band() {
  awk -v p="${1:-0}" \
    'BEGIN { if (p >= 85) print "critical"; else if (p >= 70) print "warn"; else print "nominal" }'
}

# agent_presence <stdin-json>  -> present | absent.
#   absent  == missing/null/empty agent_id == MAIN agent.
#   present == a real (non-empty) agent_id == subagent.
#   Never crashes: non-JSON stdin -> absent.
agent_presence() {
  printf '%s' "$1" | jq -r 'if (.agent_id // "") != "" then "present" else "absent" end' 2>/dev/null || echo absent
}

# --- hook entrypoint --------------------------------------------------------
main() {
  local input; input="$(cat)"

  mkdir -p "$(dirname "$SPIKE_PROBE_LOG")" 2>/dev/null || true
  {
    printf '===== %s STOP FIRED =====\n' "$(date -u +%FT%TZ 2>/dev/null || date)"
    printf 'RAW_STDIN: %s\n' "$input"
  } >> "$SPIKE_PROBE_LOG"

  local presence tpath tokens pct band
  presence="$(agent_presence "$input")"
  tpath="$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)"
  tokens=0
  [ -n "$tpath" ] && tokens="$(latest_usage_tokens "$tpath")"
  pct="$(tokens_to_pct "$tokens")"
  band="$(pct_to_band "$pct")"

  printf 'agent_id: %s | tokens: %s | pct: %s%% | band: %s | transcript: %s\n\n' \
    "$presence" "$tokens" "$pct" "$band" "${tpath:-<none>}" >> "$SPIKE_PROBE_LOG"

  # Nudge is for the MAIN agent only (this is a main-agent context monitor);
  # mirrors the plugin's own main-only gating. Subagent -> silent exit.
  if [ "$presence" = "present" ]; then
    exit 0
  fi

  local ctx
  ctx="$(printf '%s: context ~%s%% (%s/1M) band=%s' "$SPIKE_MARKER" "$pct" "$tokens" "$band")"
  jq -n --arg c "$ctx" '{hookSpecificOutput:{hookEventName:"Stop",additionalContext:$c}}'
  exit 0
}

# Only run as a hook when executed directly; sourcing (tests) just loads funcs.
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  main
fi
