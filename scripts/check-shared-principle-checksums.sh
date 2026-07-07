#!/usr/bin/env bash
# Guardrail: the principle blocks promode keeps BYTE-IDENTICAL across multiple agent defs
# must actually stay byte-identical, and the blocks it keeps DELIBERATELY DIVERGENT must
# actually differ. Until now only the manual recipe in runbooks/sync-a-shared-principle.md
# guarded these — a future edit that forgot a sibling passed CI undetected. This check turns
# that recipe into an enforced invariant.
#
# Two verbatim families (homes confirmed from the opinion register's "Documented calibrations"
# section + the runbook):
#   - <test-driven-development>: byte-identical between senior-engineer.md and
#     chief-technology-officer.md. fast-worker.md's copy is DELIBERATELY calibrated to its
#     weaker pin (fewer design-altitude bullets, no logic-spikes exception) and MUST differ —
#     asserting it equal would turn a valid calibration into a false failure.
#   - <behavioural-authority>: byte-identical across FIVE homes — senior-engineer,
#     fast-worker, chief-technology-officer, code-reviewer, debugger — why-line included.
#
# Extraction reuses the awk/shasum recipe verbatim from sync-a-shared-principle.md.
#
# AGENTS_DIR override exists for the test harness (test-check-shared-principle-checksums.sh);
# defaults to the plugin's agents dir. Exit 1 on any drift.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="${AGENTS_DIR:-$REPO/plugins/promode/agents}"

fail=0

# sum <file> <tag>  — extract the <tag>...</tag> block and shasum it (recipe from the runbook)
sum() {
  local file="$1" tag="$2"
  if [ ! -f "$file" ]; then
    printf 'FAIL  missing file: %s\n' "$file" >&2
    fail=1
    return 1
  fi
  awk -v t="$tag" '$0=="<"t">"{p=1} p{print} $0=="</"t">"{p=0}' "$file" | shasum -a 256 | cut -d' ' -f1
}

# assert_all_equal <tag> <file...>  — every listed file's block must share one checksum
assert_all_equal() {
  local tag="$1"; shift
  local first="" first_file="" f s
  for f in "$@"; do
    s="$(sum "$AGENTS_DIR/$f" "$tag")" || { fail=1; continue; }
    if [ -z "$first" ]; then
      first="$s"; first_file="$f"
    elif [ "$s" != "$first" ]; then
      printf 'FAIL  <%s> in %s (%s) != %s (%s) — verbatim family drifted\n' \
        "$tag" "$f" "$s" "$first_file" "$first"
      fail=1
    fi
  done
  if [ "$fail" -eq 0 ]; then
    printf 'ok    <%s> byte-identical across %d home(s): %s\n' "$tag" "$#" "$*"
  fi
}

# assert_differs <tag> <file-a> <file-b>  — the two blocks must NOT be identical
assert_differs() {
  local tag="$1" a="$2" b="$3" sa sb
  sa="$(sum "$AGENTS_DIR/$a" "$tag")" || return
  sb="$(sum "$AGENTS_DIR/$b" "$tag")" || return
  if [ "$sa" = "$sb" ]; then
    printf 'FAIL  <%s> in %s must be DELIBERATELY divergent from %s but is byte-identical\n' \
      "$tag" "$b" "$a"
    fail=1
  else
    printf 'ok    <%s> in %s deliberately differs from %s\n' "$tag" "$b" "$a"
  fi
}

# --- <test-driven-development>: SE == CTO (verbatim), FW deliberately differs ---
assert_all_equal test-driven-development senior-engineer.md chief-technology-officer.md
assert_differs   test-driven-development senior-engineer.md fast-worker.md

# --- <behavioural-authority>: five verbatim homes ---
assert_all_equal behavioural-authority \
  senior-engineer.md fast-worker.md chief-technology-officer.md code-reviewer.md debugger.md

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ shared-principle checksum drift — sync the homes (runbooks/sync-a-shared-principle.md)"
  exit 1
fi
echo "✓ shared-principle verbatim families are byte-identical; deliberate divergences differ"
