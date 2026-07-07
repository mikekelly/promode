#!/usr/bin/env bash
# Test harness for check-shared-principle-checksums.sh. Self-contained: copies the real
# agents dir into a temp fixture, points the check at it (via AGENTS_DIR override), and
# asserts:
#   (a) PASS on the pristine current tree (both verbatim families identical, FW divergent)
#   (b) FAIL when a sibling <behavioural-authority> block is mutated (drift undetected today)
#   (c) FAIL when the <test-driven-development> SE/CTO pair is broken
#   (d) PASS still holds when FW's <test-driven-development> is mutated — its deliberate
#       divergence must NOT trip the guard, and a wrong assertion would turn that valid
#       calibration into a false failure
#   (e) FAIL if FW's <test-driven-development> is made byte-identical to SE's (the
#       assert_differs half must catch a lost-calibration mistake, not just drift)
# Run directly; exits non-zero if any expectation is unmet.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$DIR/.." && pwd)"
CHECK="$DIR/check-shared-principle-checksums.sh"
SRC="$REPO/plugins/promode/agents"

fail=0
tmproot="$(mktemp -d)"
trap 'rm -rf "$tmproot"' EXIT

# fresh_copy — copies the real agents dir into a new temp fixture, echoes its path
fresh_copy() {
  local d; d="$(mktemp -d "$tmproot/agents.XXXXXX")"
  cp "$SRC"/*.md "$d/"
  echo "$d"
}

expect_pass() {
  local label="$1" dir="$2"
  if AGENTS_DIR="$dir" "$CHECK" >/dev/null 2>&1; then
    printf 'ok    passed: %s\n' "$label"
  else
    printf 'FAIL  expected to pass: %s\n' "$label"; fail=1
  fi
}

expect_fail() {
  local label="$1" dir="$2"
  if AGENTS_DIR="$dir" "$CHECK" >/dev/null 2>&1; then
    printf 'FAIL  expected drift to be flagged: %s\n' "$label"; fail=1
  else
    printf 'ok    flagged: %s\n' "$label"
  fi
}

# --- (a) pristine copy passes ---
d=$(fresh_copy)
expect_pass "pristine agents dir (both families consistent)" "$d"

# --- (b) mutate a sibling behavioural-authority block -> five-home family drifts ---
d=$(fresh_copy)
# Append a stray line inside debugger's <behavioural-authority> block (before the close tag).
perl -0pi -e 's{(</behavioural-authority>)}{DRIFT-INJECTED-LINE\n$1}' "$d/debugger.md"
expect_fail "mutated sibling behavioural-authority (5-home family)" "$d"

# --- (c) break the SE/CTO test-driven-development pair ---
d=$(fresh_copy)
perl -0pi -e 's{(</test-driven-development>)}{DRIFT-INJECTED-LINE\n$1}' "$d/chief-technology-officer.md"
expect_fail "mutated CTO test-driven-development (SE/CTO pair)" "$d"

# --- (d) mutate FW's test-driven-development: its deliberate divergence must stay green ---
d=$(fresh_copy)
perl -0pi -e 's{(</test-driven-development>)}{FW-LOCAL-CALIBRATION-TWEAK\n$1}' "$d/fast-worker.md"
expect_pass "FW test-driven-development mutation (deliberate divergence, not a family member)" "$d"

# --- (e) make FW's test-driven-development byte-identical to SE's -> lost calibration ---
d=$(fresh_copy)
# Replace FW's whole <test-driven-development> block with SE's, verbatim.
awk '$0=="<test-driven-development>"{p=1} p{print} $0=="</test-driven-development>"{p=0}' \
  "$SRC/senior-engineer.md" > "$tmproot/se-tdd.txt"
perl -0pi -e '
  BEGIN { local $/; open(F,"<","'"$tmproot"'/se-tdd.txt"); $blk=<F>; close(F); chomp $blk; }
  s{<test-driven-development>.*?</test-driven-development>}{$blk}s;
' "$d/fast-worker.md"
expect_fail "FW test-driven-development made identical to SE (calibration lost)" "$d"

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ check-shared-principle-checksums.sh did not behave as specified"
  exit 1
fi
echo "✓ check-shared-principle-checksums.sh behaves correctly on all fixtures"
