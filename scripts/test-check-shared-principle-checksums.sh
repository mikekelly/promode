#!/usr/bin/env bash
# Test harness for check-shared-principle-checksums.sh. Self-contained: copies the real
# agents dir into a temp fixture, points the check at it (via AGENTS_DIR override), and
# asserts, for every invariant the check enforces, that it PASSES on the pristine tree and
# FAILS on a deliberately-broken sibling. One fixture per family so a red states which one.
#
# Families under guard (membership re-derived from the committed defs, tasks 20–23):
#   - engineer-body:  senior-engineer.md == mid-level-engineer.md  (whole body, below frontmatter)
#   - worker-body:    elite/high-level/fast/cheap-worker.md        (whole body)
#   - reporting:      the generic <reporting> block shared by the engineer + worker + gui-driver
#                     defs (the specialised defs carry a role-calibrated payload and are NOT members)
#   - behavioural-authority: senior-engineer, mid-level-engineer, chief-technology-officer,
#                     code-reviewer, debugger  (five verbatim homes, why-line included)
#   - test-driven-development: senior-engineer, mid-level-engineer, chief-technology-officer
#                     (CTO is not a body-family member, so this ties its TDD copy in explicitly)
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
expect_pass "pristine agents dir (all families consistent)" "$d"

# --- (b) mutate a sibling behavioural-authority block -> five-home family drifts ---
d=$(fresh_copy)
# Append a stray line inside debugger's <behavioural-authority> block (before the close tag).
perl -0pi -e 's{(</behavioural-authority>)}{DRIFT-INJECTED-LINE\n$1}' "$d/debugger.md"
expect_fail "mutated sibling behavioural-authority (5-home family)" "$d"

# --- (c) break the SE/mid/CTO test-driven-development family ---
d=$(fresh_copy)
perl -0pi -e 's{(</test-driven-development>)}{DRIFT-INJECTED-LINE\n$1}' "$d/chief-technology-officer.md"
expect_fail "mutated CTO test-driven-development (SE/mid/CTO family)" "$d"

# --- (d) mutate a sibling engineer BODY -> engineer-body family drifts ---
d=$(fresh_copy)
# Append a stray line at end of mid-level-engineer.md: touches the body checksum only
# (after every close tag), so it isolates the engineer-body family from the tag families.
printf '\nBODY-DRIFT-INJECTED-LINE\n' >> "$d/mid-level-engineer.md"
expect_fail "mutated mid-level-engineer body (engineer-body family)" "$d"

# --- (e) mutate a sibling worker BODY -> worker-body family drifts ---
d=$(fresh_copy)
printf '\nBODY-DRIFT-INJECTED-LINE\n' >> "$d/cheap-worker.md"
expect_fail "mutated cheap-worker body (worker-body family)" "$d"

# --- (f) mutate a sibling <reporting> block -> reporting family drifts ---
d=$(fresh_copy)
perl -0pi -e 's{(</reporting>)}{REPORTING-DRIFT-INJECTED-LINE\n$1}' "$d/gui-driver.md"
expect_fail "mutated gui-driver reporting block (reporting family)" "$d"

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ check-shared-principle-checksums.sh did not behave as specified"
  exit 1
fi
echo "✓ check-shared-principle-checksums.sh behaves correctly on all fixtures"
