#!/usr/bin/env bash
# Fixture tests for plugins/promode/hooks/context-monitor.sh (the production
# main-agent context-pressure advisory Stop hook).
#
# Testable here (and only here): the PURE logic — occupancy %, band boundaries,
# floor suppression, per-band-per-session debounce, and the stop_hook_active
# LOOP GUARD (the load-bearing loop-safety invariant). The parts that CANNOT be
# unit-tested (real Stop stdin, real additionalContext continuation behaviour)
# were confirmed by live firing.
#
# Design: SOURCES the hook (main() self-guards on BASH_SOURCE) to call pure
# functions, and also runs it end-to-end as a subprocess with fixture stdin.
# Self-contained temp fixtures. Run directly; non-zero exit if any check fails.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$DIR/../plugins/promode/hooks/context-monitor.sh"

fail=0
pass=0
tmproot="$(mktemp -d)"
trap 'rm -rf "$tmproot"' EXIT

eq() { # <label> <expected> <actual>
  if [ "$2" = "$3" ]; then printf 'ok    %s\n' "$1"; pass=$((pass+1))
  else printf 'FAIL  %s — expected [%s] got [%s]\n' "$1" "$2" "$3"; fail=1; fi
}

# shellcheck disable=SC1090
source "$SCRIPT"

# --- fixture transcript: latest assistant usage = 460000 + 5000 = 465000 -----
# (an earlier assistant has huge usage to guard against the sum-vs-latest bug)
TR="$tmproot/t.jsonl"
{
  echo '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":9,"cache_read_input_tokens":950000}}}'
  echo 'BROKEN {{{'
  echo '{"type":"user","message":{"role":"user","content":"x"}}'
  echo '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":5000,"cache_read_input_tokens":460000}}}'
} > "$TR"

eq "latest_usage_tokens = 465000 (latest, not sum)" "465000" "$(latest_usage_tokens "$TR")"
eq "465000 tokens -> 46.5%" "46.5" "$(tokens_to_pct 465000)"

# --- band boundaries (floor 40 / soon 55 / now 70) — stated to the contract ---
eq "39.9% -> floor (below floor)" "floor"  "$(pct_to_band 39.9)"
eq "40.0% -> notice (floor boundary)" "notice" "$(pct_to_band 40.0)"
eq "54.9% -> notice" "notice" "$(pct_to_band 54.9)"
eq "55.0% -> soon (boundary)" "soon" "$(pct_to_band 55.0)"
eq "69.9% -> soon" "soon" "$(pct_to_band 69.9)"
eq "70.0% -> now (boundary)" "now" "$(pct_to_band 70.0)"
eq "95.0% -> now" "now" "$(pct_to_band 95.0)"

# --- band_message: minimal, soft, escalating; empty for floor ----------------
eq "floor -> empty message" "" "$(band_message floor 30.0)"
case "$(band_message notice 46.5)" in *46.5%*) eq "notice message carries %" "yes" "yes";; *) eq "notice message carries %" "yes" "no";; esac
case "$(band_message soon 58.0)" in *soon*) eq "soon message says 'soon'" "yes" "yes";; *) eq "soon message says 'soon'" "yes" "no";; esac
case "$(band_message now 72.0)" in *now*) eq "now message says 'now'" "yes" "yes";; *) eq "now message says 'now'" "yes" "no";; esac

# --- debounce: once per band per session -------------------------------------
SF="$tmproot/session.bands"
if should_emit_band "$SF" notice; then eq "first 'notice' -> emit" "emit" "emit"; else eq "first 'notice' -> emit" "emit" "suppress"; fi
record_band "$SF" notice
if should_emit_band "$SF" notice; then eq "second 'notice' -> suppress" "suppress" "emit"; else eq "second 'notice' -> suppress" "suppress" "suppress"; fi
if should_emit_band "$SF" soon; then eq "different band 'soon' -> still emit" "emit" "emit"; else eq "different band 'soon' -> still emit" "emit" "suppress"; fi
if should_emit_band "$SF" floor; then eq "floor never emits" "suppress" "emit"; else eq "floor never emits" "suppress" "suppress"; fi

# ---------------------------------------------------------------------------
# End-to-end main() as a subprocess. Helper: run with given stdin + fresh state.
# ---------------------------------------------------------------------------
run_hook() { # <stdin-json> [state-dir]  -> stdout
  local stdin="$1" sdir="${2:-$tmproot/state-$RANDOM}"
  printf '%s' "$stdin" | PROMODE_CTX_STATE_DIR="$sdir" bash "$SCRIPT"
}

# clean Stop, 46.5% -> notice injected
S1='{"hook_event_name":"Stop","stop_hook_active":false,"session_id":"E2E","transcript_path":"'"$TR"'"}'
SD="$tmproot/e2e-state"
OUT="$(run_hook "$S1" "$SD")"
ctx="$(printf '%s' "$OUT" | jq -r '.hookSpecificOutput.additionalContext // ""' 2>/dev/null)"
case "$ctx" in *46.5%*) eq "clean Stop at 46.5% injects notice" "yes" "yes";; *) eq "clean Stop at 46.5% injects notice" "yes" "no [$OUT]";; esac
eq "emitted hookEventName is Stop" "Stop" "$(printf '%s' "$OUT" | jq -r '.hookSpecificOutput.hookEventName // ""' 2>/dev/null)"

# LOOP GUARD: same firing but stop_hook_active=true -> MUST emit nothing
S2='{"hook_event_name":"Stop","stop_hook_active":true,"session_id":"E2E","transcript_path":"'"$TR"'"}'
OUT2="$(run_hook "$S2" "$tmproot/e2e-state2")"
eq "stop_hook_active=true -> NO injection (loop guard)" "" "$OUT2"

# DEBOUNCE across turns in one session: second clean Stop in same band -> silent
OUT3="$(run_hook "$S1" "$SD")"   # reuse SD -> 'notice' already recorded
eq "second clean Stop same band+session -> silent (debounce)" "" "$OUT3"

# FLOOR suppression: a low-occupancy transcript -> nothing injected
LOWTR="$tmproot/low.jsonl"
echo '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":1000,"cache_read_input_tokens":100000}}}' > "$LOWTR"
SLOW='{"hook_event_name":"Stop","stop_hook_active":false,"session_id":"LOW","transcript_path":"'"$LOWTR"'"}'
OUTLOW="$(run_hook "$SLOW" "$tmproot/low-state")"
eq "10.1% (below 40% floor) -> nothing injected" "" "$OUTLOW"

# ESCALATION: same session, occupancy climbs into 'soon' -> new band emits once
HITR="$tmproot/hi.jsonl"
echo '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":8000,"cache_read_input_tokens":580000}}}' > "$HITR"  # 58.8% -> soon
SHI='{"hook_event_name":"Stop","stop_hook_active":false,"session_id":"E2E","transcript_path":"'"$HITR"'"}'
OUTHI="$(run_hook "$SHI" "$SD")"   # same SD as E2E (notice already recorded), soon is new
chi="$(printf '%s' "$OUTHI" | jq -r '.hookSpecificOutput.additionalContext // ""' 2>/dev/null)"
case "$chi" in *soon*) eq "climb to 58.8% in same session -> 'soon' emits once" "yes" "yes";; *) eq "climb to 58.8% in same session -> 'soon' emits once" "yes" "no [$OUTHI]";; esac

# WRONG EVENT: non-Stop event -> nothing (defense in depth)
SWRONG='{"hook_event_name":"SessionStart","source":"startup"}'
eq "non-Stop event -> nothing" "" "$(run_hook "$SWRONG" "$tmproot/wrong-state")"

# NO transcript_path -> nothing (never crash)
eq "missing transcript_path -> nothing" "" "$(run_hook '{"hook_event_name":"Stop","stop_hook_active":false,"session_id":"NT"}' "$tmproot/nt-state")"

# ---------------------------------------------------------------------------
echo
if [ "$fail" -ne 0 ]; then echo "✗ context-monitor tests FAILED"; exit 1; fi
echo "✓ all $pass context-monitor tests pass"
