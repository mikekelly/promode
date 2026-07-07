#!/usr/bin/env bash
# Fixture tests for the DISPOSABLE spike scripts/spike-context-probe.sh.
#
# What is testable here (and only here): the PURE parse logic — given a fixture transcript
# JSONL + a fixture Stop-hook stdin payload, does the script compute the right occupancy %,
# the right band, and the right main-vs-subagent gate? The parts that CANNOT be unit-tested
# (the real Stop-hook stdin shape and the real additionalContext round-trip) are confirmed by
# a live firing, not here.
#
# Design: this test SOURCES the spike script (which self-guards main() behind a BASH_SOURCE
# check) and calls its pure functions directly. Self-contained: builds fixtures in a temp dir.
# Run directly; exits non-zero if any expectation is unmet.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$DIR/spike-context-probe.sh"

fail=0
pass=0
tmproot="$(mktemp -d)"
trap 'rm -rf "$tmproot"' EXIT

eq() { # <label> <expected> <actual>
  if [ "$2" = "$3" ]; then
    printf 'ok    %s\n' "$1"; pass=$((pass+1))
  else
    printf 'FAIL  %s — expected [%s] got [%s]\n' "$1" "$2" "$3"; fail=1
  fi
}

# Source the pure logic. (main() must NOT run on source.)
# shellcheck disable=SC1090
source "$SCRIPT"

# ---------------------------------------------------------------------------
# Fixture 1: a transcript with several assistant entries. The LATEST assistant
# message has usage {input_tokens: 366, cache_read_input_tokens: 235000}.
# An EARLIER assistant has much larger usage (900000 cache_read) — so a test
# that summed across messages would wrongly report ~1.13M. The correct answer
# is the LATEST message's input+cache_read = 235366. This fixture is the guard
# against the sum-vs-latest mistake called out in the spike brief.
# ---------------------------------------------------------------------------
TR="$tmproot/transcript.jsonl"
{
  echo '{"type":"user","message":{"role":"user","content":"hi"}}'
  echo '{"type":"assistant","isSidechain":false,"message":{"role":"assistant","usage":{"input_tokens":5,"cache_read_input_tokens":900000,"output_tokens":10}}}'
  echo '{"type":"user","message":{"role":"user","content":"more"}}'
  # a non-assistant line and a broken line interleaved — must be skipped robustly
  echo '{"type":"system","subtype":"hook"}'
  echo 'THIS IS NOT JSON {{{'
  echo '{"type":"assistant","isSidechain":false,"message":{"role":"assistant","usage":{"input_tokens":366,"cache_read_input_tokens":235000,"output_tokens":42}}}'
} > "$TR"

eq "latest_usage_tokens picks LATEST (not sum) = 235366" "235366" "$(latest_usage_tokens "$TR")"

# Empty / missing transcript -> 0 (never crash)
: > "$tmproot/empty.jsonl"
eq "empty transcript -> 0 tokens" "0" "$(latest_usage_tokens "$tmproot/empty.jsonl")"
eq "missing transcript -> 0 tokens" "0" "$(latest_usage_tokens "$tmproot/does-not-exist.jsonl")"

# Transcript with assistant entries but none carrying usage -> 0
echo '{"type":"assistant","message":{"role":"assistant","content":"no usage here"}}' > "$tmproot/nousage.jsonl"
eq "assistant without usage -> 0 tokens" "0" "$(latest_usage_tokens "$tmproot/nousage.jsonl")"

# ---------------------------------------------------------------------------
# tokens_to_pct: occupancy = tokens / CONTEXT_WINDOW_TOKENS (default 1_000_000).
# Expected values derived by hand, independent of the code.
# ---------------------------------------------------------------------------
eq "235366 tokens -> 23.5%" "23.5" "$(tokens_to_pct 235366)"
eq "900000 tokens -> 90.0%" "90.0" "$(tokens_to_pct 900000)"
eq "0 tokens -> 0.0%" "0.0" "$(tokens_to_pct 0)"
eq "1000000 tokens -> 100.0%" "100.0" "$(tokens_to_pct 1000000)"

# ---------------------------------------------------------------------------
# pct_to_band: SPIKE-arbitrary thresholds (nominal <70, warn 70..85, critical >=85).
# Boundary expectations stated to the contract, not read off the code.
# ---------------------------------------------------------------------------
eq "23.5% -> nominal" "nominal" "$(pct_to_band 23.5)"
eq "69.9% -> nominal" "nominal" "$(pct_to_band 69.9)"
eq "70.0% -> warn (lower boundary)" "warn" "$(pct_to_band 70.0)"
eq "84.9% -> warn" "warn" "$(pct_to_band 84.9)"
eq "85.0% -> critical (lower boundary)" "critical" "$(pct_to_band 85.0)"
eq "99.0% -> critical" "critical" "$(pct_to_band 99.0)"

# ---------------------------------------------------------------------------
# agent_presence: absent/null agent_id == MAIN agent; a real (non-empty) agent_id
# == subagent. This is the load-bearing main-vs-subagent gate.
# ---------------------------------------------------------------------------
eq "no agent_id key -> absent (main)"       "absent"  "$(agent_presence '{"transcript_path":"/x","stop_hook_active":false}')"
eq "agent_id: null -> absent (main)"        "absent"  "$(agent_presence '{"agent_id":null,"transcript_path":"/x"}')"
eq "agent_id: empty string -> absent (main)" "absent" "$(agent_presence '{"agent_id":"","transcript_path":"/x"}')"
eq "agent_id: real id -> present (subagent)" "present" "$(agent_presence '{"agent_id":"sub_abc123","transcript_path":"/x"}')"
eq "garbage stdin -> absent (never crash)"   "absent"  "$(agent_presence 'not json at all')"

# ---------------------------------------------------------------------------
# End-to-end main() smoke: feed a real-shaped Stop stdin (main agent) and assert
# the emitted JSON carries the distinctive marker in additionalContext, and that
# the scratch log gets the raw stdin appended.
# ---------------------------------------------------------------------------
LOG="$tmproot/probe.log"
STDIN_MAIN=$(printf '{"transcript_path":"%s","stop_hook_active":false,"session_id":"s1"}' "$TR")
OUT="$(printf '%s' "$STDIN_MAIN" | SPIKE_PROBE_LOG="$LOG" bash "$SCRIPT")"

marker_in_ctx="$(printf '%s' "$OUT" | jq -r '.hookSpecificOutput.additionalContext' | grep -c 'SPIKE-PROBE-7F3A')"
eq "main-agent firing injects marker in additionalContext" "1" "$marker_in_ctx"

event_name="$(printf '%s' "$OUT" | jq -r '.hookSpecificOutput.hookEventName')"
eq "emitted hookEventName is Stop" "Stop" "$event_name"

# the % in the nudge is the LATEST-message occupancy (23.5), proving the pipe end-to-end
ctx_has_pct="$(printf '%s' "$OUT" | jq -r '.hookSpecificOutput.additionalContext' | grep -c '23.5%')"
eq "nudge reports latest-message occupancy 23.5%" "1" "$ctx_has_pct"

raw_logged="$(grep -c 'RAW_STDIN' "$LOG" 2>/dev/null || echo 0)"
eq "raw stdin appended to scratch log" "1" "$raw_logged"

# Subagent firing (agent_id present) must NOT inject a nudge (empty stdout / no marker).
STDIN_SUB=$(printf '{"agent_id":"sub_x","transcript_path":"%s"}' "$TR")
OUT_SUB="$(printf '%s' "$STDIN_SUB" | SPIKE_PROBE_LOG="$tmproot/sub.log" bash "$SCRIPT")"
sub_marker="$(printf '%s' "$OUT_SUB" | grep -c 'SPIKE-PROBE-7F3A' || true)"
eq "subagent firing emits NO nudge" "0" "$sub_marker"

# ---------------------------------------------------------------------------
echo
if [ "$fail" -ne 0 ]; then
  echo "✗ spike parse-logic tests FAILED"
  exit 1
fi
echo "✓ all $pass spike parse-logic tests pass"
