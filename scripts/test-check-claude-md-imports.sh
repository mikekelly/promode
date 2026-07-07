#!/usr/bin/env bash
# Test harness for check-claude-md-imports.sh. Self-contained: builds fixture CLAUDE.md
# files in temp dirs, points the check at them (via CLAUDE_MD override), and asserts the
# check FAILS on every silent-breakage mode the 2026-07-07 live probe confirmed:
#   - a missing import target resolves to nothing, exit 0, no warning (probe #4)
#   - an import target OUTSIDE the project dir silently fails to resolve even when the
#     file exists (probe #2) — so mere existence is not enough; the target must be in-repo
# and PASSES where an @-token is not an import (fenced code block / inline code span stay
# literal per probe #6; user@host is not an import). Ends by asserting the real repo root
# CLAUDE.md is green. Run directly; exits non-zero if any expectation is unmet.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$DIR/.." && pwd)"
CHECK="$DIR/check-claude-md-imports.sh"

fail=0
tmproot="$(mktemp -d)"
trap 'rm -rf "$tmproot"' EXIT

# expect_fail <label> <claude-md-path>  — the check should exit non-zero
expect_fail() {
  local label="$1" md="$2"
  if CLAUDE_MD="$md" "$CHECK" >/dev/null 2>&1; then
    printf 'FAIL  expected breakage to be flagged: %s\n' "$label"; fail=1
  else
    printf 'ok    flagged: %s\n' "$label"
  fi
}

# expect_pass <label> <claude-md-path>  — the check should exit zero
expect_pass() {
  local label="$1" md="$2"
  if CLAUDE_MD="$md" "$CHECK" >/dev/null 2>&1; then
    printf 'ok    passed: %s\n' "$label"
  else
    printf 'FAIL  expected to pass: %s\n' "$label"; fail=1
  fi
}

# make_case <case-name> <claude-md-body>  — builds $tmproot/<case>/CLAUDE.md, echoes its path
make_case() {
  local case="$1" body="$2"
  mkdir -p "$tmproot/$case"
  printf '%s' "$body" > "$tmproot/$case/CLAUDE.md"
  echo "$tmproot/$case/CLAUDE.md"
}

# --- valid baseline: one import, target exists in-repo ---
md=$(make_case valid $'# Root\n\nSome orientation.\n\n@docs/register.md\n')
mkdir -p "$tmproot/valid/docs"; echo "register" > "$tmproot/valid/docs/register.md"
expect_pass "existing in-repo target" "$md"

# --- mid-line import, target exists ---
md=$(make_case midline $'See @docs/register.md for the register.\n')
mkdir -p "$tmproot/midline/docs"; echo "register" > "$tmproot/midline/docs/register.md"
expect_pass "mid-line import with existing target" "$md"

# --- THE core case: missing target (drops silently at runtime — probe #4) ---
md=$(make_case missing $'# Root\n\n@docs/does-not-exist.md\n')
expect_fail "missing import target" "$md"

# --- one good + one missing ---
md=$(make_case onebad $'@docs/register.md\n\n@docs/gone.md\n')
mkdir -p "$tmproot/onebad/docs"; echo "x" > "$tmproot/onebad/docs/register.md"
expect_fail "one of two targets missing" "$md"

# --- target exists but lives OUTSIDE the project dir (silently unresolvable — probe #2) ---
mkdir -p "$tmproot/elsewhere"; echo "x" > "$tmproot/elsewhere/outside.md"
md=$(make_case outside $'@../elsewhere/outside.md\n')
expect_fail "existing target outside the project dir" "$md"

# --- ~/ target (outside-project by definition per probe #2) ---
md=$(make_case homedir $'@~/some-register.md\n')
expect_fail "~/ target (outside project)" "$md"

# --- fenced code block: @-token stays literal (probe #6), missing target is fine ---
md=$(make_case fenced $'# Root\n\n```\n@docs/gone.md\n```\n')
expect_pass "@ inside fenced code block ignored" "$md"

# --- inline code span: stays literal (probe #6) ---
md=$(make_case span $'Use `@docs/gone.md` as the syntax example.\n')
expect_pass "@ inside inline code span ignored" "$md"

# --- email-like token: @ not preceded by whitespace is not an import ---
md=$(make_case email $'Contact mikekelly321@gmail.com about this.\n')
expect_pass "user@host is not an import" "$md"

# --- no imports at all: valid (nothing to resolve) ---
md=$(make_case none $'# Root\n\nNo imports here.\n')
expect_pass "no imports present" "$md"

# --- real repo root CLAUDE.md must be green ---
expect_pass "real root CLAUDE.md" "$REPO/CLAUDE.md"

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ check-claude-md-imports.sh did not behave as specified"
  exit 1
fi
echo "✓ check-claude-md-imports.sh behaves correctly on all fixtures"
