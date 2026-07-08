#!/usr/bin/env bash
# Fixture tests for plugins/promode/hooks/context-monitor.sh (the production
# main-agent context-pressure advisory Stop hook).
#
# Testable here (and only here): the PURE logic — occupancy %, band boundaries,
# band_message wording, the stop_hook_active LOOP GUARD, and the transcript-
# derived LEVEL-TRIGGERED debounce (no external state file):
#   inject the current band iff it exceeds the highest band reached at any prior
#   TURN-ENDING since the last compact_boundary, where a turn-ending occupancy =
#   the last assistant `usage` immediately before each GENUINE user-prompt entry.
#   The current turn's own mid-turn readings are excluded (there is no user
#   prompt after the current turn yet) — this is what makes a mid-turn band
#   crossing inject exactly once instead of being wrongly suppressed.
#
# Genuine user prompt (turn boundary), verified against the real transcript:
#   type=="user" AND not isMeta AND not isCompactSummary AND not isSidechain AND
#   message.content is a string (or an array with NO tool_result block).
#   Tool-result user entries (content=[{type:"tool_result"}]) are NOT boundaries.
#
# Expected values are an INDEPENDENT oracle (hand-derived from the spec), never
# calibrated to the code. Self-contained temp fixtures. Run directly.
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

# --- fixture builders --------------------------------------------------------
rd()   { printf '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":0,"cache_read_input_tokens":%s}}}\n' "$1"; }  # assistant usage reading
up()   { printf '{"type":"user","message":{"role":"user","content":"go on please"}}\n'; }                                                 # GENUINE user prompt (turn boundary)
trr()  { printf '{"type":"user","message":{"role":"user","content":[{"type":"tool_result","tool_use_id":"t","content":"ok"}]}}\n'; }      # tool-result user entry (NOT a boundary)
meta() { printf '{"type":"user","isMeta":true,"message":{"role":"user","content":"<local-command-caveat>"}}\n'; }                          # meta user entry (NOT a boundary)
csum() { printf '{"type":"user","isCompactSummary":true,"message":{"role":"user","content":"This session is being continued..."}}\n'; }    # post-compaction summary (NOT a boundary)
side() { printf '{"type":"user","isSidechain":true,"message":{"role":"user","content":"subagent prompt"}}\n'; }                            # sidechain user entry (NOT a boundary)
bnd()  { printf '{"type":"system","subtype":"compact_boundary","content":"Conversation compacted"}\n'; }                                   # re-arm marker
bndws(){ printf '{"type":"system","subtype": "compact_boundary","content":"x"}\n'; }                                                       # re-arm marker w/ whitespace after colon
tok()  { echo $(( $1 * 10000 )); }   # tokens for a given occupancy % (window = 1_000_000)

# ===========================================================================
# 1. Pure logic — config-driven rank ladder
# ===========================================================================
TR="$tmproot/t.jsonl"
{ rd 950000; up; rd 465000; } > "$TR"   # latest = 465000; earlier huge one guards sum-vs-latest
eq "latest_usage_tokens = latest not sum" "465000" "$(latest_usage_tokens "$TR")"
eq "465000 -> 46.5%" "46.5" "$(tokens_to_pct 465000)"

# The ladder is one ordered array; ranks are derived from it (count of
# thresholds <= pct). This pins the single-source-of-truth config intent.
eq "ladder is the single CTX_BANDS array" "40 55 70 80 90" "${CTX_BANDS[*]}"

# rank at each threshold boundary and just below it — hand-derived from the array
eq "39.9% -> rank 0 (floor)"                 "0" "$(pct_to_rank 39.9)"
eq "40.0% -> rank 1 (exact boundary)"        "1" "$(pct_to_rank 40.0)"
eq "54.9% -> rank 1"                         "1" "$(pct_to_rank 54.9)"
eq "55.0% -> rank 2 (exact boundary)"        "2" "$(pct_to_rank 55.0)"
eq "69.9% -> rank 2"                         "2" "$(pct_to_rank 69.9)"
eq "70.0% -> rank 3 (exact boundary)"        "3" "$(pct_to_rank 70.0)"
eq "79.9% -> rank 3"                         "3" "$(pct_to_rank 79.9)"
eq "80.0% -> rank 4 (new, exact boundary)"   "4" "$(pct_to_rank 80.0)"
eq "89.9% -> rank 4"                         "4" "$(pct_to_rank 89.9)"
eq "90.0% -> rank 5 (new, covers 90-100)"    "5" "$(pct_to_rank 90.0)"
eq "99.9% -> rank 5 (no literal-100 band)"   "5" "$(pct_to_rank 99.9)"

# config-driven: overriding the array changes the ranks (pins that the ladder,
# not hardcoded constants, drives ranking). Restore after.
_saved_bands=("${CTX_BANDS[@]}")
CTX_BANDS=(50)
eq "override CTX_BANDS=(50): 40 -> rank 0" "0" "$(pct_to_rank 40)"
eq "override CTX_BANDS=(50): 60 -> rank 1" "1" "$(pct_to_rank 60)"
CTX_BANDS=("${_saved_bands[@]}")

# User-ratified wording: ONE neutral factual line for every non-floor band —
# only the fact (the %), no urgency clauses. Escalation is carried by the number.
UNIFORM="promode context-monitor: context ~%s%% of the window."
eq "message uniform at 46.5" "$(printf "$UNIFORM" 46.5)" "$(band_message 46.5)"
eq "message uniform at 58.0" "$(printf "$UNIFORM" 58.0)" "$(band_message 58.0)"
eq "message uniform at 82.0" "$(printf "$UNIFORM" 82.0)" "$(band_message 82.0)"
case "$(band_message 58.0)" in *soon*|*raising*|*recommend*|*worth*) eq "no urgency words in message" clean dirty;; *) eq "no urgency words in message" clean clean;; esac

# ===========================================================================
# 2. Debounce internals: prior_max_rank over TURN-ENDINGS (integers now)
# ===========================================================================
# turn-endings are the last reading before each genuine prompt; current excluded
P1="$tmproot/p1.jsonl"; { up; rd "$(tok 38)"; up; rd "$(tok 45)"; } > "$P1"
eq "prior_max_rank [t:38 | cur:45] -> 0" "0" "$(prior_max_rank "$P1")"
P2="$tmproot/p2.jsonl"; { up; rd "$(tok 38)"; up; rd "$(tok 45)"; up; rd "$(tok 50)"; } > "$P2"
eq "prior_max_rank [t:38,45 | cur:50] -> 1" "1" "$(prior_max_rank "$P2")"
P3="$tmproot/p3.jsonl"; { up; rd "$(tok 45)"; up; rd "$(tok 56)"; up; rd "$(tok 42)"; } > "$P3"
eq "prior_max_rank [t:45,56 | cur:42] -> 2" "2" "$(prior_max_rank "$P3")"
P4="$tmproot/p4.jsonl"; { up; rd "$(tok 45)"; up; rd "$(tok 56)"; bnd; up; rd "$(tok 42)"; } > "$P4"
eq "prior_max_rank after compact_boundary re-arms -> 0" "0" "$(prior_max_rank "$P4")"

# Non-prompt user entries are NOT turn boundaries. Each fixture puts the excluded
# entry between two same-turn readings (41 then 48); if it were wrongly treated as
# a boundary it would close pending=41 -> prior_max_rank 1. Correct -> 0 (only the
# earlier real turn-end of 35 counts). Each pins one is_prompt exclusion branch;
# the rework verified each goes RED when its guard is removed from the script.
TRB="$tmproot/trb.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; trr;  rd "$(tok 48)"; } > "$TRB"
eq "tool_result not a boundary -> prior_max_rank 0" "0" "$(prior_max_rank "$TRB")"
MET="$tmproot/met.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; meta; rd "$(tok 48)"; } > "$MET"
eq "isMeta not a boundary -> prior_max_rank 0" "0" "$(prior_max_rank "$MET")"
CSM="$tmproot/csm.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; csum; rd "$(tok 48)"; } > "$CSM"
eq "isCompactSummary not a boundary -> prior_max_rank 0" "0" "$(prior_max_rank "$CSM")"
SID="$tmproot/sid.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; side; rd "$(tok 48)"; } > "$SID"
eq "isSidechain not a boundary -> prior_max_rank 0" "0" "$(prior_max_rank "$SID")"

# compact_boundary match is whitespace-tolerant (serialization robustness)
P4WS="$tmproot/p4ws.jsonl"; { up; rd "$(tok 45)"; up; rd "$(tok 56)"; bndws; up; rd "$(tok 42)"; } > "$P4WS"
eq "compact_boundary w/ space after colon still re-arms -> 0" "0" "$(prior_max_rank "$P4WS")"

# continuation-turn grouping: reading after an injection (no prompt before it)
# belongs to the segment ending at the next real prompt -> ending occupancy = 46
CNT="$tmproot/cnt.jsonl"; { up; rd "$(tok 45)"; rd "$(tok 46)"; up; rd "$(tok 48)"; } > "$CNT"
eq "continuation grouped: prior_max_rank = 1 (segment ends at 46)" "1" "$(prior_max_rank "$CNT")"

# ===========================================================================
# 3. End-to-end main() — the ratified level-triggered climb
# ===========================================================================
run_hook() { # <transcript> [stop_hook_active]
  local tr="$1" active="${2:-false}"
  printf '{"hook_event_name":"Stop","stop_hook_active":%s,"session_id":"E2E","transcript_path":"%s"}' "$active" "$tr" | bash "$SCRIPT"
}
ctx_of() { printf '%s' "$1" | jq -r '.hookSpecificOutput.additionalContext // ""' 2>/dev/null; }

C1="$tmproot/c1.jsonl"; { up; rd "$(tok 38)"; up; rd "$(tok 45)"; } > "$C1"
O="$(run_hook "$C1")"; case "$(ctx_of "$O")" in *45.0%*) eq "climb 38->45 injects notice once" y y;; *) eq "climb 38->45 injects notice once" y "n[$O]";; esac

C2="$tmproot/c2.jsonl"; { up; rd "$(tok 38)"; up; rd "$(tok 45)"; up; rd "$(tok 50)"; } > "$C2"
eq "45->50 (still notice) silent" "" "$(run_hook "$C2")"

C3="$tmproot/c3.jsonl"; { up; rd "$(tok 38)"; up; rd "$(tok 45)"; up; rd "$(tok 50)"; up; rd "$(tok 56)"; } > "$C3"
O="$(run_hook "$C3")"; case "$(ctx_of "$O")" in *56.0%*) eq "cross soon threshold (56%) re-pings once" y y;; *) eq "cross soon threshold (56%) re-pings once" y "n[$O]";; esac

C4="$tmproot/c4.jsonl"; { up; rd "$(tok 38)"; up; rd "$(tok 45)"; up; rd "$(tok 50)"; up; rd "$(tok 56)"; up; rd "$(tok 72)"; } > "$C4"
O="$(run_hook "$C4")"; case "$(ctx_of "$O")" in *72.0%*) eq "cross now threshold (72%) re-pings once" y y;; *) eq "cross now threshold (72%) re-pings once" y "n[$O]";; esac
eq "emitted hookEventName is Stop" "Stop" "$(printf '%s' "$O" | jq -r '.hookSpecificOutput.hookEventName // ""')"

# --- new thresholds: 80% (rank 4) and 90% (rank 5) --------------------------
LADDER="up; rd $(tok 38); up; rd $(tok 45); up; rd $(tok 50); up; rd $(tok 56); up; rd $(tok 72)"
C6="$tmproot/c6.jsonl";  eval "{ $LADDER; up; rd $(tok 82); }" > "$C6"
O="$(run_hook "$C6")"; case "$(ctx_of "$O")" in *82.0%*) eq "cross 80 threshold (82%) re-pings once (rank 4)" y y;; *) eq "cross 80 threshold (82%) re-pings once (rank 4)" y "n[$O]";; esac
C6b="$tmproot/c6b.jsonl"; eval "{ $LADDER; up; rd $(tok 82); up; rd $(tok 85); }" > "$C6b"
eq "82->85 (still rank 4) silent" "" "$(run_hook "$C6b")"
C7="$tmproot/c7.jsonl";  eval "{ $LADDER; up; rd $(tok 82); up; rd $(tok 92); }" > "$C7"
O="$(run_hook "$C7")"; case "$(ctx_of "$O")" in *92.0%*) eq "cross 90 threshold (92%) re-pings once (rank 5)" y y;; *) eq "cross 90 threshold (92%) re-pings once (rank 5)" y "n[$O]";; esac
C7b="$tmproot/c7b.jsonl"; eval "{ $LADDER; up; rd $(tok 82); up; rd $(tok 92); up; rd $(tok 96); }" > "$C7b"
eq "92->96 (still rank 5) silent" "" "$(run_hook "$C7b")"

# --- mid-turn crossing (the CORRECTED behaviour) ----------------------------
# One turn climbs 41(notice)->48(notice) with a tool call in between. The old
# all-readings spec would see the mid-turn 41 as "prior" and SUPPRESS. Correct
# spec: those are current-turn readings, excluded -> inject notice once.
MT1="$tmproot/mt1.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; trr; rd "$(tok 48)"; } > "$MT1"
O="$(run_hook "$MT1")"; case "$(ctx_of "$O")" in *48.0%*) eq "mid-turn 41->48 injects notice once (not suppressed)" y y;; *) eq "mid-turn 41->48 injects notice once (not suppressed)" y "n[$O]";; esac

# One turn crosses TWO bands at once (38->58) -> inject once at the higher band.
MT2="$tmproot/mt2.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 38)"; trr; rd "$(tok 58)"; } > "$MT2"
O="$(run_hook "$MT2")"; case "$(ctx_of "$O")" in *58.0%*) eq "two-band mid-turn 38->58 injects once (at 58%)" y y;; *) eq "two-band mid-turn 38->58 injects once (at 58%)" y "n[$O]";; esac

# --- compact_boundary re-arm + contrast -------------------------------------
C5="$tmproot/c5.jsonl"; { up; rd "$(tok 45)"; up; rd "$(tok 56)"; bnd; up; rd "$(tok 42)"; } > "$C5"
O="$(run_hook "$C5")"; case "$(ctx_of "$O")" in *42.0%*) eq "compact_boundary re-arms notice post-compact" y y;; *) eq "compact_boundary re-arms notice post-compact" y "n[$O]";; esac
C5b="$tmproot/c5b.jsonl"; { up; rd "$(tok 45)"; up; rd "$(tok 56)"; up; rd "$(tok 42)"; } > "$C5b"
eq "without boundary, dropping to notice stays silent" "" "$(run_hook "$C5b")"

# --- guards -----------------------------------------------------------------
eq "stop_hook_active=true -> silent (loop guard)" "" "$(run_hook "$C1" true)"
CLOW="$tmproot/low.jsonl"; { up; rd "$(tok 10)"; } > "$CLOW"
eq "10% below floor -> silent" "" "$(run_hook "$CLOW")"
eq "non-Stop event -> silent" "" "$(printf '{"hook_event_name":"SessionStart","source":"startup"}' | bash "$SCRIPT")"
eq "missing transcript_path -> silent" "" "$(printf '{"hook_event_name":"Stop","stop_hook_active":false,"session_id":"NT"}' | bash "$SCRIPT")"

# ===========================================================================
echo
if [ "$fail" -ne 0 ]; then echo "✗ context-monitor tests FAILED"; exit 1; fi
echo "✓ all $pass context-monitor tests pass"
