#!/usr/bin/env bash
# Test harness for check-skill-frontmatter.sh. Self-contained: builds deliberately-broken
# SKILL.md fixtures in a temp dir, points the check at that dir (via SKILLS_DIR override),
# and asserts the check FAILS on each kind of breakage — then asserts it passes on a valid
# fixture and on the real plugins/promode/skills tree. No broken skill is ever left in the
# real tree. Run directly; exits non-zero if any expectation is unmet.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$DIR/.." && pwd)"
CHECK="$DIR/check-skill-frontmatter.sh"

fail=0
tmproot="$(mktemp -d)"
trap 'rm -rf "$tmproot"' EXIT

# expect_fail <label> <skills-dir>  — the check should exit non-zero
expect_fail() {
  local label="$1" dir="$2"
  if SKILLS_DIR="$dir" "$CHECK" >/dev/null 2>&1; then
    printf 'FAIL  expected breakage to be flagged: %s\n' "$label"; fail=1
  else
    printf 'ok    flagged: %s\n' "$label"
  fi
}

# expect_pass <label> <skills-dir>  — the check should exit zero
expect_pass() {
  local label="$1" dir="$2"
  if SKILLS_DIR="$dir" "$CHECK" >/dev/null 2>&1; then
    printf 'ok    passed: %s\n' "$label"
  else
    printf 'FAIL  expected to pass: %s\n' "$label"; fail=1
  fi
}

# Build one skill dir under $tmproot/<case>/<skillname>/SKILL.md and echo the skills-dir.
make_case() {
  local case="$1" skillname="$2" body="$3"
  local sdir="$tmproot/$case"
  mkdir -p "$sdir/$skillname"
  printf '%s' "$body" > "$sdir/$skillname/SKILL.md"
  echo "$sdir"
}

# --- valid baseline (control) ---
d=$(make_case valid good-skill $'---\nname: good-skill\ndescription: A perfectly valid description.\n---\n\nBody.\n')
expect_pass "valid skill" "$d"

# --- 1. no frontmatter block at all ---
d=$(make_case nofm bad-skill $'# Just a heading\n\nNo frontmatter here.\n')
expect_fail "no frontmatter block" "$d"

# --- 1b. opening --- not on line 1 ---
d=$(make_case notline1 bad-skill $'\n---\nname: bad-skill\ndescription: x\n---\n')
expect_fail "opening delimiter not on line 1" "$d"

# --- 1c. no closing delimiter ---
d=$(make_case noclose bad-skill $'---\nname: bad-skill\ndescription: x\n\nbody with no closing fence\n')
expect_fail "missing closing delimiter" "$d"

# --- 2. malformed YAML inside frontmatter ---
d=$(make_case badyaml bad-skill $'---\nname: bad-skill\n  description: : : not: valid\n\tbad tab indent\n---\n')
expect_fail "malformed YAML" "$d"

# --- 3a. empty description ---
d=$(make_case emptydesc bad-skill $'---\nname: bad-skill\ndescription: ""\n---\n')
expect_fail "empty description" "$d"

# --- 3b. missing description key ---
d=$(make_case nodesc bad-skill $'---\nname: bad-skill\n---\n')
expect_fail "missing description" "$d"

# --- 3c. empty name ---
d=$(make_case emptyname bad-skill $'---\nname: ""\ndescription: something\n---\n')
expect_fail "empty name" "$d"

# --- 3d. missing name key ---
d=$(make_case noname bad-skill $'---\ndescription: something\n---\n')
expect_fail "missing name" "$d"

# --- 4. name mismatches directory ---
d=$(make_case mismatch the-dir-name $'---\nname: a-different-name\ndescription: something\n---\n')
expect_fail "name != directory" "$d"

# --- real tree must be green ---
expect_pass "real plugins/promode/skills tree" "$REPO/plugins/promode/skills"

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ check-skill-frontmatter.sh did not behave as specified"
  exit 1
fi
echo "✓ check-skill-frontmatter.sh behaves correctly on all fixtures"
