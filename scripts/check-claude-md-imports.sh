#!/usr/bin/env bash
# Guardrail: every `@`-import referenced from the root CLAUDE.md must resolve to an
# existing file INSIDE the project. Live-probed (Claude Code 2.1.201, 2026-07-07, recorded
# in tasks/10-opinion-register.md): a missing import target drops SILENTLY (exit 0, no
# warning), and a target outside the project dir — even an existing file, ~/ included —
# silently fails to resolve. Without this check the opinion register import
# (docs/opinion-register.md) could vanish from every agent's context with no signal;
# this check is what makes the @-imported register a real guarantee.
#
# Import syntax mirrored from the harness's observed behaviour:
#   - an import is `@<path>` where `@` starts a line or follows whitespace, path runs to
#     the next whitespace; mid-line imports count
#   - tokens inside fenced code blocks (```) or inline code spans (`...`) stay literal
#     (probe #6) and are ignored; `user@host` (no preceding whitespace) is not an import
#   - relative paths resolve against the CLAUDE.md's own directory
#
# CLAUDE_MD override exists for the test harness (test-check-claude-md-imports.sh);
# defaults to the repo root CLAUDE.md. Exit 1 on any unresolvable import.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_MD="${CLAUDE_MD:-$REPO/CLAUDE.md}"

if [ ! -f "$CLAUDE_MD" ]; then
  echo "✗ no CLAUDE.md at $CLAUDE_MD"
  exit 1
fi
ROOT="$(cd "$(dirname "$CLAUDE_MD")" && pwd -P)"

fail=0
checked=0

# 1. Drop fenced code blocks (``` toggles), 2. drop inline code spans, 3. extract
# whitespace-delimited @-tokens. Pure awk/sed → identical behaviour locally and in CI.
imports="$(
  awk '/^[[:space:]]*```/{fence=!fence; next} !fence{print}' "$CLAUDE_MD" \
    | sed 's/`[^`]*`//g' \
    | grep -oE '(^|[[:space:]])@[^[:space:]]+' \
    | sed 's/^[[:space:]]*@//' \
    || true
)"

if [ -z "$imports" ]; then
  echo "note: no @-imports found in $CLAUDE_MD"
  echo "✓ nothing to resolve"
  exit 0
fi

while IFS= read -r path; do
  [ -n "$path" ] || continue
  checked=$((checked + 1))

  # Resolve the target the way the harness would.
  case "$path" in
    "~"|"~/"*) target="$HOME${path#"~"}" ;;
    /*)        target="$path" ;;
    *)         target="$ROOT/$path" ;;
  esac

  if [ ! -f "$target" ]; then
    printf 'FAIL  @%s -> %s does not exist (import will drop SILENTLY at runtime)\n' "$path" "$target"
    fail=1
    continue
  fi

  # Existence is not enough: outside-project targets silently fail to resolve (probe #2).
  tdir="$(cd "$(dirname "$target")" && pwd -P)"
  case "$tdir/" in
    "$ROOT/"*|"$ROOT/") printf 'ok    @%s\n' "$path" ;;
    *) printf 'FAIL  @%s resolves outside the project dir (%s) — the harness silently ignores it\n' "$path" "$tdir"
       fail=1 ;;
  esac
done <<< "$imports"

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ unresolvable @-import(s) in $CLAUDE_MD — imported context would silently vanish"
  exit 1
fi
echo "✓ all ${checked} @-import(s) in root CLAUDE.md resolve to existing in-project files"
