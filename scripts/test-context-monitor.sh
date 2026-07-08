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
# 1. Transferable pure logic (unchanged by the debounce rewrite)
# ===========================================================================
TR="$tmproot/t.jsonl"
{ rd 950000; up; rd 465000; } > "$TR"   # latest = 465000; earlier huge one guards sum-vs-latest
eq "latest_usage_tokens = latest not sum" "465000" "$(latest_usage_tokens "$TR")"
eq "465000 -> 46.5%" "46.5" "$(tokens_to_pct 465000)"
eq "39.9% -> floor"  "floor"  "$(pct_to_band 39.9)"
eq "40.0% -> notice" "notice" "$(pct_to_band 40.0)"
eq "54.9% -> notice" "notice" "$(pct_to_band 54.9)"
eq "55.0% -> soon"   "soon"   "$(pct_to_band 55.0)"
eq "69.9% -> soon"   "soon"   "$(pct_to_band 69.9)"
eq "70.0% -> now"    "now"    "$(pct_to_band 70.0)"
# User-ratified wording: ONE neutral factual line for every non-floor band —
# only the fact (the %), no urgency clauses; escalation is carried by the number
# (each band still fires once, per the debounce). floor -> empty.
UNIFORM="promode context-monitor: context ~%s%% of the window."
eq "floor -> empty message" "" "$(band_message floor 30.0)"
eq "notice message uniform"           "$(printf "$UNIFORM" 46.5)" "$(band_message notice 46.5)"
eq "soon message uniform (no urgency)" "$(printf "$UNIFORM" 58.0)" "$(band_message soon 58.0)"
eq "now message uniform (no urgency)"  "$(printf "$UNIFORM" 72.0)" "$(band_message now 72.0)"
case "$(band_message soon 58.0)" in *soon*|*raising*|*recommend*) eq "no urgency words in message" clean dirty;; *) eq "no urgency words in message" clean clean;; esac

# ===========================================================================
# 2. Debounce internals: band_rank + prior_max_band over TURN-ENDINGS
# ===========================================================================
eq "band_rank floor=0"  "0" "$(band_rank floor)"
eq "band_rank notice=1" "1" "$(band_rank notice)"
eq "band_rank soon=2"   "2" "$(band_rank soon)"
eq "band_rank now=3"    "3" "$(band_rank now)"

# turn-endings are the last reading before each genuine prompt; current excluded
P1="$tmproot/p1.jsonl"; { up; rd "$(tok 38)"; up; rd "$(tok 45)"; } > "$P1"
eq "prior_max [t:38 | cur:45] -> floor" "floor" "$(prior_max_band "$P1")"
P2="$tmproot/p2.jsonl"; { up; rd "$(tok 38)"; up; rd "$(tok 45)"; up; rd "$(tok 50)"; } > "$P2"
eq "prior_max [t:38,45 | cur:50] -> notice" "notice" "$(prior_max_band "$P2")"
P3="$tmproot/p3.jsonl"; { up; rd "$(tok 45)"; up; rd "$(tok 56)"; up; rd "$(tok 42)"; } > "$P3"
eq "prior_max [t:45,56 | cur:42] -> soon" "soon" "$(prior_max_band "$P3")"
P4="$tmproot/p4.jsonl"; { up; rd "$(tok 45)"; up; rd "$(tok 56)"; bnd; up; rd "$(tok 42)"; } > "$P4"
eq "prior_max after compact_boundary re-arms -> floor" "floor" "$(prior_max_band "$P4")"

# Non-prompt user entries are NOT turn boundaries. Each fixture puts the excluded
# entry between two same-turn readings (41 then 48); if it were wrongly treated as
# a boundary it would close pending=41 -> prior_max notice. Correct -> floor (only
# the earlier real turn-end of 35). Each pins one is_prompt exclusion branch; the
# rework verified each goes RED when its guard is removed from the script.
TRB="$tmproot/trb.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; trr;  rd "$(tok 48)"; } > "$TRB"
eq "tool_result not a boundary -> prior_max floor" "floor" "$(prior_max_band "$TRB")"
MET="$tmproot/met.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; meta; rd "$(tok 48)"; } > "$MET"
eq "isMeta not a boundary -> prior_max floor" "floor" "$(prior_max_band "$MET")"
CSM="$tmproot/csm.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; csum; rd "$(tok 48)"; } > "$CSM"
eq "isCompactSummary not a boundary -> prior_max floor" "floor" "$(prior_max_band "$CSM")"
SID="$tmproot/sid.jsonl"; { up; rd "$(tok 35)"; up; rd "$(tok 41)"; side; rd "$(tok 48)"; } > "$SID"
eq "isSidechain not a boundary -> prior_max floor" "floor" "$(prior_max_band "$SID")"

# compact_boundary match is whitespace-tolerant (serialization robustness)
P4WS="$tmproot/p4ws.jsonl"; { up; rd "$(tok 45)"; up; rd "$(tok 56)"; bndws; up; rd "$(tok 42)"; } > "$P4WS"
eq "compact_boundary w/ space after colon still re-arms -> floor" "floor" "$(prior_max_band "$P4WS")"

# continuation-turn grouping: reading after an injection (no prompt before it)
# belongs to the segment ending at the next real prompt -> ending occupancy = 46
CNT="$tmproot/cnt.jsonl"; { up; rd "$(tok 45)"; rd "$(tok 46)"; up; rd "$(tok 48)"; } > "$CNT"
eq "continuation grouped: prior_max = notice (segment ends at 46)" "notice" "$(prior_max_band "$CNT")"

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
