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
# `Stop` stdin carries NO `agent_id`; the earlier doc-research assumption was
# wrong. Fields observed: session_id, transcript_path, cwd, prompt_id,
# permission_mode, effort{level}, hook_event_name, stop_hook_active,
# last_assistant_message, background_tasks, session_crons.
#
# Occupancy = the LATEST assistant message's usage (input_tokens +
# cache_read_input_tokens), NOT a sum across messages — each message's input
# already represents the full context fed to it. Denominator is a named config
# constant (the 1M-token window).
#
# LOOP SAFETY (load-bearing, live-verified): emitting `additionalContext` on a
# `Stop` hook FORCES A CONTINUATION — the main agent is re-invoked for an extra
# turn, it is NOT a silent next-turn footer. On that continuation-triggered
# `Stop`, stdin carries `stop_hook_active: true`. The retired spike ignored this
# and looped (13.4% -> 13.7% -> 14.9%). This hook exits silently when
# stop_hook_active is true -> at most one injection per stop-sequence, no loop.
# UX consequence: the advisory costs one agent turn ("agent speaks up"), not
# silent awareness.
#
# DEBOUNCE — transcript-derived, LEVEL-TRIGGERED (no external state file):
# inject the current band iff it is HIGHER than the highest band reached at any
# prior TURN-ENDING since the last compact_boundary. A turn-ending occupancy is
# the last assistant `usage` immediately before a GENUINE user-prompt entry; the
# current turn's own mid-turn readings are excluded (there is no user prompt
# after it yet). This is level-triggered, not edge-triggered: a band crossing
# that lands mid-turn (e.g. a big tool result jumps 41%->48% inside one turn)
# still injects exactly once at the next Stop, instead of being suppressed by a
# same-turn earlier reading. A `compact_boundary` re-arms all bands (only
# turn-endings AFTER the last boundary are considered) — live-confirmed to cover
# both auto and manual compaction, same file.
#
# GENUINE user prompt (turn boundary), verified against the real transcript:
#   type=="user" AND not isMeta AND not isCompactSummary AND not isSidechain AND
#   message.content is a string (or an array with NO tool_result block).
# Tool-result user entries (content=[{type:"tool_result"}]) are NOT boundaries;
# the compaction summary is a string user entry flagged isCompactSummary.
#
# All harness facts above are live-observed on 2.1.202 (undocumented — re-verify
# on any Claude Code change). Pure logic lives in the functions below and is
# fixture-tested in scripts/test-context-monitor.sh (main() is guarded so
# sourcing is safe).
# =============================================================================
set -uo pipefail

# --- config constants (not magic numbers) -----------------------------------
CONTEXT_WINDOW_TOKENS="${CONTEXT_WINDOW_TOKENS:-1000000}"   # 1M window (Fable/Opus/Sonnet)
CTX_FLOOR_PCT=40   # first advisory  (below this: inject nothing)
CTX_SOON_PCT=55    # "worth raising soon"
CTX_NOW_PCT=70     # "recommend raising now"

# --- pure logic (sourced by the test; no side effects) ----------------------

# latest_usage_tokens <transcript_file>
#   (input_tokens + cache_read_input_tokens) of the LATEST assistant message.
#   NOT a sum. 0 if unreadable/empty/no usage. Tail-only; skips broken lines.
latest_usage_tokens() {
  local f="$1"
  [ -r "$f" ] || { echo 0; return; }
  tail -n 400 "$f" | jq -Rn '
    [ inputs | fromjson? // empty
      | select(.type == "assistant" and (.message.usage != null)) ]
    | if length == 0 then 0
      else ( .[-1].message.usage
             | (.input_tokens // 0) + (.cache_read_input_tokens // 0) )
      end' 2>/dev/null || echo 0
}

# tokens_to_pct <tokens>  -> occupancy as % of the window, 1 decimal.
#   LC_ALL=C pins '.' as the decimal separator so a comma-decimal locale can't
#   corrupt the number we format here and re-parse in awk downstream.
tokens_to_pct() {
  LC_ALL=C awk -v t="${1:-0}" -v w="$CONTEXT_WINDOW_TOKENS" \
    'BEGIN { if (w <= 0) w = 1; printf "%.1f", (t / w) * 100 }'
}

# pct_to_band <pct>  -> floor | notice | soon | now.
pct_to_band() {
  LC_ALL=C awk -v p="${1:-0}" -v fl="$CTX_FLOOR_PCT" -v so="$CTX_SOON_PCT" -v no="$CTX_NOW_PCT" \
    'BEGIN {
       if (p >= no)      print "now";
       else if (p >= so) print "soon";
       else if (p >= fl) print "notice";
       else              print "floor";
     }'
}

# band_rank <band> / band_from_rank <n>  -> total order floor<notice<soon<now.
band_rank() { case "$1" in now) echo 3;; soon) echo 2;; notice) echo 1;; *) echo 0;; esac; }
band_from_rank() { case "$1" in 3) echo now;; 2) echo soon;; 1) echo notice;; *) echo floor;; esac; }

# band_message <band> <pct>  -> the injected advisory: ONE neutral factual line
#   for every non-floor band (user-ratified). The hook states only the fact (the
#   %); ALL whether/when-to-raise judgement is the agent's and lives in the brief
#   doctrine, not here. Escalation across the 40/55/70 bands is carried by the
#   rising number (each band re-fires once via the debounce), not by wording.
#   Empty for floor.
band_message() {
  local band="$1" pct="$2"
  [ "$band" = "floor" ] && { printf ''; return; }
  printf 'promode context-monitor: context ~%s%% of the window.' "$pct"
}

# prior_max_band <transcript_file>  -> highest band among PRIOR TURN-ENDINGS
#   since the last compact_boundary (current turn excluded). floor if none.
#   Cheap streaming pass over the post-boundary region (not a full-file parse):
#   grep locates the last boundary line; one jq reduce emits each turn-ending
#   occupancy; awk folds them to a max band rank.
prior_max_band() {
  local f="$1" bl maxrank
  [ -r "$f" ] || { echo floor; return; }
  # ⚙ HARNESS-SERIALIZATION ASSUMPTION (re-verify on any Claude Code change): the
  #   compact_boundary marker is matched by a tolerant line-grep. We allow
  #   optional whitespace after the colon; if the harness ever reorders keys or
  #   pretty-prints entries across lines, this single-line match must be revisited
  #   (route via jq at that point). Live-observed compact form on 2.1.x.
  bl="$(grep -nE '"subtype":[[:space:]]*"compact_boundary"' "$f" | tail -1 | cut -d: -f1)"; bl="${bl:-0}"
  maxrank="$(tail -n +"$((bl + 1))" "$f" | jq -Rn '
    # Emit one token count per turn-ending: the last assistant usage seen just
    # before each GENUINE user prompt. The trailing pending value (current turn)
    # is never emitted.
    def is_prompt:
      (.type == "user")
      and ((.isMeta // false) | not)
      and ((.isCompactSummary // false) | not)
      and ((.isSidechain // false) | not)
      and ( ((.message.content | type) == "string")
            or ( (.message.content | type) == "array"
                 and ([ .message.content[]? | select((.type?) == "tool_result") ] | length) == 0 ) );
    reduce (inputs | fromjson? // empty) as $o
      ( { pending: null, endings: [] };
        if ($o.type == "assistant" and ($o.message.usage != null)) then
          .pending = (($o.message.usage.input_tokens // 0) + ($o.message.usage.cache_read_input_tokens // 0))
        elif ($o | is_prompt) then
          if .pending != null then (.endings += [.pending] | .pending = null) else . end
        else . end )
    | .endings[]' 2>/dev/null \
    | LC_ALL=C awk -v w="$CONTEXT_WINDOW_TOKENS" -v fl="$CTX_FLOOR_PCT" -v so="$CTX_SOON_PCT" -v no="$CTX_NOW_PCT" '
        BEGIN { max = 0 }
        { if (w <= 0) w = 1; p = ($1 / w) * 100;
          r = (p >= no) ? 3 : ((p >= so) ? 2 : ((p >= fl) ? 1 : 0));
          if (r > max) max = r }
        END { print max }')"
  band_from_rank "${maxrank:-0}"
}

# --- hook entrypoint --------------------------------------------------------
main() {
  local input; input="$(cat)"

  # Defense in depth: only act on Stop (main-agent turn-end).
  local evt; evt="$(printf '%s' "$input" | jq -r '.hook_event_name // empty' 2>/dev/null)"
  [ -n "$evt" ] && [ "$evt" != "Stop" ] && exit 0

  # LOOP GUARD: never inject on a stop-hook-triggered continuation.
  local active; active="$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null)"
  [ "$active" = "true" ] && exit 0

  local tpath tokens pct band
  tpath="$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)"
  [ -n "$tpath" ] || exit 0

  tokens="$(latest_usage_tokens "$tpath")"
  pct="$(tokens_to_pct "$tokens")"
  band="$(pct_to_band "$pct")"
  [ "$band" = "floor" ] && exit 0

  # Level-triggered debounce: inject iff we have reached a HIGHER band than at
  # any prior turn-ending since the last compaction.
  local prior; prior="$(prior_max_band "$tpath")"
  [ "$(band_rank "$band")" -gt "$(band_rank "$prior")" ] || exit 0

  local msg; msg="$(band_message "$band" "$pct")"
  [ -n "$msg" ] || exit 0
  jq -n --arg c "$msg" '{hookSpecificOutput:{hookEventName:"Stop",additionalContext:$c}}'
  exit 0
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  main
fi
