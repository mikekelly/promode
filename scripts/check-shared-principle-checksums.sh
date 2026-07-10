#!/usr/bin/env bash
# Guardrail: the prompt blocks promode keeps BYTE-IDENTICAL across multiple agent defs must
# actually stay byte-identical. The maintainer promise is "same prompt, different frontmatter":
# several defs share a prompt body verbatim and differ only in their YAML frontmatter (model,
# effort, description). Nothing but this check enforces it — a future edit that touched one
# sibling and forgot the others would pass CI undetected. This turns the sync recipe in
# runbooks/sync-a-shared-principle.md into an enforced invariant.
#
# Families under guard (membership derived from the committed defs — tasks 20–23 reorganised
# the agent roster into engineer/worker rungs, so this is NOT the old SE/FW/CTO membership):
#
#   - engineer-body: senior-engineer.md and mid-level-engineer.md share their WHOLE body
#     (everything below the frontmatter's closing ---) verbatim — same engineer prompt, the
#     Opus rung and the Sonnet rung differ only in frontmatter.
#   - worker-body: elite/high-level/fast/cheap-worker.md share their whole body verbatim — one
#     generic-executor prompt across the four cost tiers (inherit/Opus/Sonnet/Haiku).
#   - <reporting>: the generic reporting block is byte-identical across the engineer + worker
#     rungs and gui-driver. The specialised defs (reviewer, verifier, debugger, CTO, CPO, SPD,
#     auditor, agent-analyzer, environment-manager, constraint-reinforcer) carry a
#     role-CALIBRATED reporting payload (P13: pattern verbatim, payload calibrated) and are
#     deliberately NOT members — asserting them equal would turn valid calibration into a
#     false failure. Membership is pinned explicitly below.
#   - <behavioural-authority>: five verbatim homes — senior-engineer, mid-level-engineer,
#     chief-technology-officer, code-reviewer, debugger — closing why-line included.
#   - <test-driven-development>: senior-engineer, mid-level-engineer, chief-technology-officer.
#     SE and mid are already covered transitively by the engineer-body family; CTO is not a
#     body-family member, so this check is what binds CTO's TDD copy to the engineers'.
#
# Extraction reuses the awk/shasum recipe from sync-a-shared-principle.md; body extraction
# takes everything after the frontmatter's second `---`.
#
# AGENTS_DIR override exists for the test harness (test-check-shared-principle-checksums.sh);
# defaults to the plugin's agents dir. Exit 1 on any drift.
set -uo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="${AGENTS_DIR:-$REPO/plugins/promode/agents}"

fail=0

# extract <file> <what> — <what> is a tag name (extract <tag>...</tag> inclusive) or the
# literal __BODY__ (everything after the frontmatter's closing --- line).
extract() {
  local file="$1" what="$2"
  if [ "$what" = "__BODY__" ]; then
    awk 'f{print} /^---$/{c++; if(c==2)f=1}' "$file"
  else
    awk -v t="$what" '$0=="<"t">"{p=1} p{print} $0=="</"t">"{p=0}' "$file"
  fi
}

# sum <file> <what> — checksum the extracted block/body
sum() {
  local file="$1" what="$2"
  if [ ! -f "$file" ]; then
    printf 'FAIL  missing file: %s\n' "$file" >&2
    fail=1
    return 1
  fi
  extract "$file" "$what" | shasum -a 256 | cut -d' ' -f1
}

# assert_all_equal <label> <what> <file...> — every listed file's block/body shares one checksum
assert_all_equal() {
  local label="$1" what="$2"; shift 2
  local first="" first_file="" f s any_fail=0
  for f in "$@"; do
    s="$(sum "$AGENTS_DIR/$f" "$what")" || { any_fail=1; continue; }
    if [ -z "$first" ]; then
      first="$s"; first_file="$f"
    elif [ "$s" != "$first" ]; then
      printf 'FAIL  %s: %s (%s) != %s (%s) — verbatim family drifted\n' \
        "$label" "$f" "$s" "$first_file" "$first"
      fail=1; any_fail=1
    fi
  done
  if [ "$any_fail" -eq 0 ]; then
    printf 'ok    %s byte-identical across %d home(s): %s\n' "$label" "$#" "$*"
  fi
}

# --- engineer-body family: the Opus rung and the Sonnet rung share one prompt body ---
assert_all_equal "engineer body" __BODY__ senior-engineer.md mid-level-engineer.md

# --- worker-body family: one generic-executor prompt across four cost tiers ---
assert_all_equal "worker body" __BODY__ \
  elite-worker.md high-level-worker.md fast-worker.md cheap-worker.md

# --- <reporting>: generic block shared by engineer + worker rungs and gui-driver ---
assert_all_equal "<reporting>" reporting \
  senior-engineer.md mid-level-engineer.md \
  elite-worker.md high-level-worker.md fast-worker.md cheap-worker.md \
  gui-driver.md

# --- <behavioural-authority>: five verbatim homes ---
assert_all_equal "<behavioural-authority>" behavioural-authority \
  senior-engineer.md mid-level-engineer.md chief-technology-officer.md \
  code-reviewer.md debugger.md

# --- <test-driven-development>: SE, mid, CTO ---
assert_all_equal "<test-driven-development>" test-driven-development \
  senior-engineer.md mid-level-engineer.md chief-technology-officer.md

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ shared-principle checksum drift — sync the homes (runbooks/sync-a-shared-principle.md)"
  exit 1
fi
echo "✓ shared-principle verbatim families are byte-identical"
