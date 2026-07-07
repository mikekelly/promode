#!/usr/bin/env bash
# =============================================================================
# context-monitor.sh — promode main-agent context-pressure advisory (Stop hook).
# =============================================================================
# Fires on the MAIN agent's turn-end (Claude Code `Stop` event) and injects a
# short, soft, advisory `additionalContext` line stating current context
# occupancy once it crosses a floor — a nudge that references the context-
# pressure doctrine, never a restatement of it.
#
# Main-agent isolation is STRUCTURAL, not agent_id-based: `Stop` fires only for
# the main agent; subagents fire `SubagentStop` (which this hook is NOT
# registered on). Verified live on Claude Code 2.1.202 (2026-07-07): a project
# `Stop` hook fired only for the main session's transcript across repeated
# turn-ends and never for a deliberately-spawned subagent's completion. Real
# `Stop` stdin carries NO `agent_id` field; the earlier doc-research assumption
# was wrong. Fields observed: session_id, transcript_path, cwd, prompt_id,
# permission_mode, effort{level}, hook_event_name, stop_hook_active,
# last_assistant_message, background_tasks, session_crons.
#
# Occupancy = the LATEST assistant message's usage (input_tokens +
# cache_read_input_tokens), NOT a sum across messages — each message's input
# already represents the full context fed to it. Denominator is the context
# window as a named config constant.
#
# LOOP SAFETY (load-bearing, live-verified 2026-07-07): emitting
# `additionalContext` on a `Stop` hook FORCES A CONTINUATION — the main agent is
# re-invoked for an extra turn, it is NOT a silent next-turn footer. On that
# continuation-triggered `Stop`, stdin carries `stop_hook_active: true`. The
# earlier spike ignored this flag and looped (inject -> continue -> inject ...,
# 13.4% -> 13.7% -> 14.9%). This hook MUST exit silently when stop_hook_active
# is true, so it injects at most once per stop-sequence and can never loop.
# UX consequence: the advisory costs one agent turn (the agent surfaces it, then
# yields) — "agent speaks up", not silent awareness.
#
# Pure logic lives in the functions below and is fixture-tested in
# scripts/test-context-monitor.sh (main() is guarded so sourcing is safe).
# =============================================================================
set -uo pipefail

# --- config constants (not magic numbers) -----------------------------------
# Confirmed 1M-token window for Fable/Opus/Sonnet. Override for tests only.
CONTEXT_WINDOW_TOKENS="${CONTEXT_WINDOW_TOKENS:-1000000}"
# Band thresholds (percent of window). Below FLOOR: inject nothing.
CTX_FLOOR_PCT=40   # first advisory
CTX_SOON_PCT=55    # "worth raising soon"
CTX_NOW_PCT=70     # "recommend raising now"
# Per-session, per-band debounce state (once per band per session).
PROMODE_CTX_STATE_DIR="${PROMODE_CTX_STATE_DIR:-${TMPDIR:-/tmp}/promode-context-monitor}"

# --- pure logic (sourced by the test; no side effects) ----------------------

# latest_usage_tokens <transcript_file>
#   (input_tokens + cache_read_input_tokens) of the LATEST assistant message.
#   NOT a sum. 0 if unreadable/empty/no usage. Tail-only; skips broken lines.
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

# tokens_to_pct <tokens>  -> occupancy as % of the window, 1 decimal.
tokens_to_pct() {
  awk -v t="${1:-0}" -v w="$CONTEXT_WINDOW_TOKENS" \
    'BEGIN { if (w <= 0) w = 1; printf "%.1f", (t / w) * 100 }'
}

# pct_to_band <pct>  -> floor | notice | soon | now.
#   floor = below CTX_FLOOR_PCT (suppress entirely).
pct_to_band() {
  awk -v p="${1:-0}" -v fl="$CTX_FLOOR_PCT" -v so="$CTX_SOON_PCT" -v no="$CTX_NOW_PCT" \
    'BEGIN {
       if (p >= no)      print "now";
       else if (p >= so) print "soon";
       else if (p >= fl) print "notice";
       else              print "floor";
     }'
}

# band_message <band> <pct>  -> the injected advisory line (minimal: % + soft
#   cue). Soft/advisory, escalating emphasis by band; references the doctrine,
#   does not restate it. Empty for floor.
band_message() {
  local band="$1" pct="$2"
  case "$band" in
    notice) printf 'promode context-monitor: context ~%s%% of the window.' "$pct" ;;
    soon)   printf 'promode context-monitor: context ~%s%% of the window — worth raising with the user soon.' "$pct" ;;
    now)    printf 'promode context-monitor: context ~%s%% of the window — recommend raising with the user now.' "$pct" ;;
    *)      printf '' ;;
  esac
}

# should_emit_band <state_file> <band>  -> exit 0 if this band has NOT yet been
#   emitted for the session (debounce: once per band per session); exit 1 if it
#   already has, or if band is floor.
should_emit_band() {
  local state_file="$1" band="$2"
  [ "$band" = "floor" ] && return 1
  [ -f "$state_file" ] && grep -qxF "$band" "$state_file" && return 1
  return 0
}

# record_band <state_file> <band>  -> mark this band emitted for the session.
record_band() {
  local state_file="$1" band="$2"
  mkdir -p "$(dirname "$state_file")" 2>/dev/null || true
  printf '%s\n' "$band" >> "$state_file"
}

# --- hook entrypoint --------------------------------------------------------
main() {
  local input; input="$(cat)"

  # Defense in depth: only act on Stop (main-agent turn-end). Never on any
  # other event that might route here.
  local evt; evt="$(printf '%s' "$input" | jq -r '.hook_event_name // empty' 2>/dev/null)"
  [ -n "$evt" ] && [ "$evt" != "Stop" ] && exit 0

  # LOOP GUARD: never inject on a continuation already triggered by a stop hook.
  # additionalContext on Stop forces a continuation; stop_hook_active goes true
  # on that re-fire. Suppressing here caps us at one injection per stop-sequence.
  local active; active="$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null)"
  [ "$active" = "true" ] && exit 0

  local sid tpath tokens pct band
  sid="$(printf '%s' "$input" | jq -r '.session_id // "unknown"' 2>/dev/null)"
  tpath="$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)"
  [ -n "$tpath" ] || exit 0

  tokens="$(latest_usage_tokens "$tpath")"
  pct="$(tokens_to_pct "$tokens")"
  band="$(pct_to_band "$pct")"

  # Below the floor, or already advised for this band this session -> stay silent.
  local state_file="$PROMODE_CTX_STATE_DIR/${sid}.bands"
  should_emit_band "$state_file" "$band" || exit 0

  local msg; msg="$(band_message "$band" "$pct")"
  [ -n "$msg" ] || exit 0

  record_band "$state_file" "$band"
  jq -n --arg c "$msg" '{hookSpecificOutput:{hookEventName:"Stop",additionalContext:$c}}'
  exit 0
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  main
fi
