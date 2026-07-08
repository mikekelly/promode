#!/usr/bin/env bash
# =============================================================================
# replay-context-monitor.sh — ⚙ backtest / re-verify tool for the context monitor.
# =============================================================================
# Replays the PRODUCTION plugins/promode/hooks/context-monitor.sh against real
# historical transcript JSONL(s). At every genuine turn-ending (the last
# assistant `usage` before each genuine user-prompt entry — the same
# discriminator the hook uses) it runs the actual hook with a synthetic Stop
# stdin over the transcript TRUNCATED to that point, and prints the injection
# timeline + peak occupancy. It also independently re-derives the expected
# inject/silence decision (an oracle) and flags any divergence from the hook —
# a divergence is a hook bug to report, not to fix silently.
#
# SCOPE / WHAT THIS DOES NOT EXERCISE: these transcripts are CLEAN pre-hook
# history — they contain no prior `hook_additional_context` injections, so the
# continuation / `stop_hook_active` loop-guard dynamics are NOT exercised here
# (those are unit-tested in scripts/test-context-monitor.sh). This validates, on
# real varied data: occupancy reading, the rank ladder, level-triggered
# debounce (each band once, ascending), `compact_boundary` re-arm, floor
# silence, and crash/empty/malformed-line robustness.
#
# Commits NO transcript content: takes transcript path(s) as ARGS; writes only
# temp truncations under a scratch dir cleaned on exit; prints only occupancy
# %s, ranks, and inject decisions (no transcript text).
#
# Usage: scripts/replay-context-monitor.sh <transcript.jsonl> [<transcript.jsonl> ...]
# Linked from docs/decisions/2026-07-context-monitor.md as the ⚙ re-verify tool.
# =============================================================================
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK="$HERE/../plugins/promode/hooks/context-monitor.sh"
[ -r "$HOOK" ] || { echo "hook not found: $HOOK" >&2; exit 2; }
# shellcheck disable=SC1090
source "$HOOK"   # brings in latest_usage_tokens/tokens_to_pct/pct_to_rank (main() is guarded)

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
overall_fail=0

# genuine user-prompt line numbers (1-based), same discriminator as the hook
prompt_lines() {
  jq -Rn '
    def is_prompt:
      (.type=="user")
      and ((.isMeta // false)|not)
      and ((.isCompactSummary // false)|not)
      and ((.isSidechain // false)|not)
      and ( ((.message.content|type)=="string")
            or ((.message.content|type)=="array"
                and ([.message.content[]?|select((.type?)=="tool_result")]|length)==0) );
    foreach inputs as $l (0; .+1;
      if (($l|fromjson? // {}) | is_prompt) then . else empty end)' "$1"
}

# assistant-with-usage line numbers (1-based)
assistant_lines() {
  jq -Rn 'foreach inputs as $l (0; .+1;
    if (($l|fromjson? // {}) | (.type=="assistant" and (.message.usage!=null))) then . else empty end)' "$1"
}

replay_one() {
  local f="$1" base; base="$(basename "$f")"
  [ -r "$f" ] || { echo "!! unreadable: $f" >&2; overall_fail=1; return; }

  local total; total="$(wc -l < "$f" | tr -d ' ')"
  local -a plines blines alines
  mapfile -t plines < <(prompt_lines "$f")
  mapfile -t alines < <(assistant_lines "$f")
  mapfile -t blines < <(grep -nE '"subtype":[[:space:]]*"compact_boundary"' "$f" | cut -d: -f1)
  local k="${#plines[@]}" nb="${#blines[@]}"

  # Real Stop points are ASSISTANT COMPLETIONS, not prompt boundaries: a Stop
  # fires after the agent finishes responding. A turn-ending is therefore the
  # LAST assistant-with-usage line before the next genuine prompt (or EOF).
  # Anchoring to prompt-1 instead would create spurious Stop points at
  # consecutive prompts / the compaction-summary gap, where no assistant
  # responded and the occupancy reading is a stale lag of the prior turn.
  local -a bounds=( "${plines[@]}" $(( total + 1 )) )   # each prompt + a virtual EOF bound
  local -a tps=()
  local bnd a cand prev_end=0
  for bnd in "${bounds[@]}"; do
    cand=0
    for a in "${alines[@]}"; do
      if [ "$a" -lt "$bnd" ]; then cand="$a"; else break; fi   # alines ascending
    done
    if [ "$cand" -gt "$prev_end" ]; then tps+=( "$cand" ); prev_end="$cand"; fi
  done

  printf '\n=== %s  (lines=%s, prompts=%s, compact_boundaries=%s, turn-ends=%s) ===\n' \
    "$base" "$total" "$k" "$nb" "${#tps[@]}"
  printf '%-5s %-8s %-8s %-5s %-9s %s\n' turn endLine occ% rank injected note

  local trunc="$tmp/trunc.jsonl"
  local turn=0 cur_seg=-1 seg_max=0 peak_pct="0.0" peak_tok=0 peak_turn=0
  local violations=0 floor_silent=0
  local -A real_bands=()   # ranks actually injected on REAL data

  local T tokens pct rank out injected seg expect note
  for T in "${tps[@]}"; do
    turn=$((turn+1))
    head -n "$T" "$f" > "$trunc"

    tokens="$(latest_usage_tokens "$trunc")"
    pct="$(tokens_to_pct "$tokens")"
    rank="$(pct_to_rank "$pct")"

    # segment (re-arm) tracking: count boundaries at/below this truncation
    seg=0; local b; for b in "${blines[@]}"; do [ "$b" -le "$T" ] && seg=$((seg+1)); done
    if [ "$seg" != "$cur_seg" ]; then cur_seg="$seg"; seg_max=0; fi

    # ORACLE expected decision (mirrors the hook: inject iff rank>=1 and rank > prior seg max)
    if [ "$rank" -ge 1 ] && [ "$rank" -gt "$seg_max" ]; then expect=1; else expect=0; fi

    # ACTUAL: run the production hook over the truncated transcript
    out="$(printf '{"hook_event_name":"Stop","stop_hook_active":false,"session_id":"replay","transcript_path":"%s"}' "$trunc" | bash "$HOOK")"
    if [ -n "$out" ]; then injected=1; else injected=0; fi

    # update peak
    if awk -v a="$pct" -v b="$peak_pct" 'BEGIN{exit !(a>b)}'; then peak_pct="$pct"; peak_tok="$tokens"; peak_turn="$turn"; fi

    note=""
    if [ "$injected" != "$expect" ]; then
      note="*** DIVERGENCE: expected inject=$expect actual=$injected ***"
      violations=$((violations+1)); overall_fail=1
    fi
    [ "$injected" = 1 ] && real_bands["$rank"]=1

    # update the segment max over ALL turn-endings (after the decision), like prior_max
    [ "$rank" -gt "$seg_max" ] && seg_max="$rank"

    if [ "$injected" = 1 ] || [ "$rank" -ge 1 ] || [ -n "$note" ]; then
      printf '%-5s %-8s %-8s %-5s %-9s %s\n' "$turn" "$T" "$pct" "$rank" \
        "$([ "$injected" = 1 ] && echo "INJECT" || echo "-")" "$note"
    else
      floor_silent=$((floor_silent+1))
    fi
  done

  printf 'floor-silent turns (rank 0, not shown): %s\n' "$floor_silent"
  printf 'peak occupancy: %s%% (%s tokens) at turn %s\n' "$peak_pct" "$peak_tok" "$peak_turn"

  # bands exercised on REAL data
  local rb="" r
  for r in 1 2 3 4 5; do [ -n "${real_bands[$r]:-}" ] && rb+="$r "; done
  printf 'ranks injected on REAL data: %s\n' "${rb:-none}"

  if [ "$violations" -eq 0 ]; then
    printf 'VERDICT: clean — hook matched the oracle at every turn-end (%s turns).\n' "$turn"
  else
    printf 'VERDICT: %s DIVERGENCE(S) — REWORK (see *** lines above).\n' "$violations"
  fi
}

[ "$#" -ge 1 ] || { echo "usage: $0 <transcript.jsonl> [...]" >&2; exit 2; }
for f in "$@"; do replay_one "$f"; done

echo
if [ "$overall_fail" -ne 0 ]; then
  echo "✗ replay found a divergence or an unreadable input — see above."
  exit 1
fi
echo "✓ replay clean across all supplied transcripts (hook matched oracle; no crashes)."
