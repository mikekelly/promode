#!/usr/bin/env bash
# Guardrail: every skill's SKILL.md frontmatter must be valid, because a coding agent
# discovers and triggers a skill purely from that frontmatter's `name` + `description`.
# Malformed frontmatter = a silently-broken skill (it just never fires). Nothing else
# parses SKILL.md, so this is the only automated guard on it.
#
# HIGH-VALUE invariants only (deliberately NOT brittle — see the task brief):
#   1. A frontmatter block exists, properly delimited: opening `---` on line 1, a closing `---`.
#   2. It parses as valid (flat) YAML.
#   3. Non-empty `name` and non-empty `description`.
#   4. `name` equals the skill's directory name.
# We assert nothing stylistic (length, wording, field whitelist, key order) — that would
# false-positive on legitimate variation.
#
# YAML-parse approach & CI reasoning: CI is ubuntu-latest and reliably provides only bash +
# jq (jq is explicitly installed). A real YAML parser is NOT reliable there — PyYAML is not
# in the python3 stdlib and is not guaranteed on the runner, so depending on it would pass
# locally and error in CI (the exact brittleness we must avoid). SKILL.md frontmatter is
# simple flat `key: value` YAML, so instead of a full parser we do a careful, minimal
# extraction: isolate the delimited block, reject anything that isn't flat well-formed
# key:value lines (this is the "valid YAML" check at the level this format needs), then pull
# `name`/`description`. Pure bash → identical behaviour locally and in CI. Exit 1 on violation.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# SKILLS_DIR override exists for the test harness; defaults to the real tree.
SKILLS_DIR="${SKILLS_DIR:-$REPO/plugins/promode/skills}"

fail=0
checked=0

# Strip surrounding single/double quotes and trailing whitespace from a YAML scalar value.
unquote() {
  local v="$1"
  # trim trailing whitespace
  v="${v%"${v##*[![:space:]]}"}"
  # trim leading whitespace
  v="${v#"${v%%[![:space:]]*}"}"
  if [ ${#v} -ge 2 ]; then
    case "$v" in
      \"*\") v="${v#\"}"; v="${v%\"}" ;;
      \'*\') v="${v#\'}"; v="${v%\'}" ;;
    esac
  fi
  printf '%s' "$v"
}

shopt -s nullglob
for skill_md in "$SKILLS_DIR"/*/SKILL.md; do
  checked=$((checked + 1))
  sdir="$(dirname "$skill_md")"
  skillname="$(basename "$sdir")"
  problem=""

  # --- 1. Delimited block: opening `---` on line 1, and a closing `---`. ---
  first_line="$(sed -n '1p' "$skill_md")"
  if [ "$first_line" != "---" ]; then
    printf 'FAIL  %-28s no opening `---` on line 1\n' "$skillname"; fail=1; continue
  fi

  # Extract the block strictly between line 1's `---` and the next standalone `---`.
  # awk: turn on after line 1; stop at the next `---`; if we never see it, emit nothing.
  fm="$(awk 'NR==1{next} /^---[[:space:]]*$/{found=1; exit} {print} END{if(!found) exit 3}' "$skill_md")"
  if [ $? -eq 3 ]; then
    printf 'FAIL  %-28s no closing `---` delimiter\n' "$skillname"; fail=1; continue
  fi

  # --- 2. Valid flat YAML: every non-blank, non-comment line must be `key: value`. ---
  # (Block scalars / nested maps aren't used in skill frontmatter; rejecting them here is
  # the minimal, reliable stand-in for a YAML parser for this format.)
  name_val=""
  desc_val=""
  has_name=0
  has_desc=0
  while IFS= read -r line; do
    # skip blank and comment lines
    case "$line" in
      ''|'#'*) continue ;;
    esac
    # a tab anywhere or leading whitespace means it's not a flat top-level key:value line
    case "$line" in
      *$'\t'*) problem="malformed YAML (tab in frontmatter)"; break ;;
      [[:space:]]*) problem="malformed YAML (unexpected indentation)"; break ;;
    esac
    # must contain a `key:` at the start
    if [[ "$line" != *:* ]]; then
      problem="malformed YAML (line is not key: value): $line"; break
    fi
    key="${line%%:*}"
    val="${line#*:}"
    # key must be a bare identifier (letters, digits, _ -)
    if [[ ! "$key" =~ ^[A-Za-z0-9_-]+$ ]]; then
      problem="malformed YAML (bad key): $line"; break
    fi
    case "$key" in
      name) name_val="$(unquote "$val")"; has_name=1 ;;
      description) desc_val="$(unquote "$val")"; has_desc=1 ;;
    esac
  done <<< "$fm"

  if [ -n "$problem" ]; then
    printf 'FAIL  %-28s %s\n' "$skillname" "$problem"; fail=1; continue
  fi

  # --- 3. Non-empty name and description. ---
  if [ "$has_name" -ne 1 ] || [ -z "$name_val" ]; then
    printf 'FAIL  %-28s missing or empty `name`\n' "$skillname"; fail=1; continue
  fi
  if [ "$has_desc" -ne 1 ] || [ -z "$desc_val" ]; then
    printf 'FAIL  %-28s missing or empty `description`\n' "$skillname"; fail=1; continue
  fi

  # --- 4. name == directory name. ---
  if [ "$name_val" != "$skillname" ]; then
    printf 'FAIL  %-28s name `%s` != directory `%s`\n' "$skillname" "$name_val" "$skillname"; fail=1; continue
  fi

  printf 'ok    %-28s valid frontmatter\n' "$skillname"
done

if [ "$checked" -eq 0 ]; then
  echo "FAIL  no SKILL.md files found under $SKILLS_DIR"
  exit 1
fi

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ one or more skills have invalid SKILL.md frontmatter — they will silently fail to trigger."
  exit 1
fi
echo "✓ all ${checked} skill(s) have valid SKILL.md frontmatter"
