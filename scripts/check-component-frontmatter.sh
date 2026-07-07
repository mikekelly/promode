#!/usr/bin/env bash
# Guardrail: every plugin component's frontmatter must be valid, because the harness
# discovers agents and commands purely from that frontmatter (`name`/`description` feed the
# delegation listing and the command listing; `model` pins an agent's tier). Malformed
# frontmatter = a silently-broken component (it just never routes). Nothing else parses
# these files, so this is the only automated guard on them.
#
# Covers (each dir validated when present):
#   - plugins/promode/agents/*.md    — REQUIRED to exist and be non-empty (the plugin ships agents)
#   - plugins/promode/commands/*.md  — optional dir (added by the skills-elimination migration)
#   - plugins/promode/skills/*/SKILL.md — legacy dir, validated while it still exists;
#     its ABSENCE is fine (the migration deletes it), so the check works on both pre- and
#     post-migration trees (CI runs it on the merged result).
#
# HIGH-VALUE invariants only (deliberately NOT brittle):
#   1. A frontmatter block exists, properly delimited: opening `---` on line 1, a closing `---`.
#   2. It parses as valid (flat) YAML.
#   3. Non-empty `description`; non-empty `name` for agents/skills (commands take their name
#      from the filename, so `name` is only checked there when present).
#   4. `name` equals the filename (agents/commands) or directory name (skills) — a mismatch
#      makes routing references point at nothing.
#   5. Agents only: `model` is validated only where pinned — if the key is present its value
#      must be non-empty (an empty pin silently falls back to the default tier). Value is NOT
#      checked against an enum: the harness accepts full model IDs too, and an allowlist would
#      false-positive on every new model.
# We assert nothing stylistic (length, wording, field whitelist, key order) — that would
# false-positive on legitimate variation.
#
# YAML-parse approach & CI reasoning: CI is ubuntu-latest and reliably provides only bash +
# jq (jq is explicitly installed). A real YAML parser is NOT reliable there — PyYAML is not
# in the python3 stdlib and is not guaranteed on the runner, so depending on it would pass
# locally and error in CI (the exact brittleness we must avoid). This frontmatter is simple
# flat `key: value` YAML, so instead of a full parser we do a careful, minimal extraction:
# isolate the delimited block, reject anything that isn't flat well-formed key:value lines
# (this is the "valid YAML" check at the level this format needs), then pull the keys we
# assert on. Pure bash → identical behaviour locally and in CI. Exit 1 on violation.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Dir overrides exist for the test harness; defaults are the real tree.
AGENTS_DIR="${AGENTS_DIR:-$REPO/plugins/promode/agents}"
COMMANDS_DIR="${COMMANDS_DIR:-$REPO/plugins/promode/commands}"
SKILLS_DIR="${SKILLS_DIR:-$REPO/plugins/promode/skills}"

fail=0

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

# check_file <file> <display-name> <expected-name> <name-required: yes|ifpresent> <check-model: yes|no>
# Validates one component file's frontmatter. Sets fail=1 and prints FAIL on violation.
check_file() {
  local file="$1" display="$2" expected="$3" name_required="$4" check_model="$5"
  local problem=""

  # --- 1. Delimited block: opening `---` on line 1, and a closing `---`. ---
  local first_line
  first_line="$(sed -n '1p' "$file")"
  if [ "$first_line" != "---" ]; then
    printf 'FAIL  %-32s no opening `---` on line 1\n' "$display"; fail=1; return
  fi

  # Extract the block strictly between line 1's `---` and the next standalone `---`.
  # awk: turn on after line 1; stop at the next `---`; if we never see it, emit nothing.
  local fm
  fm="$(awk 'NR==1{next} /^---[[:space:]]*$/{found=1; exit} {print} END{if(!found) exit 3}' "$file")"
  if [ $? -eq 3 ]; then
    printf 'FAIL  %-32s no closing `---` delimiter\n' "$display"; fail=1; return
  fi

  # --- 2. Valid flat YAML: every non-blank, non-comment line must be `key: value`. ---
  # (Block scalars / nested maps aren't used in this frontmatter; rejecting them here is
  # the minimal, reliable stand-in for a YAML parser for this format.)
  local name_val="" desc_val="" model_val="" has_name=0 has_desc=0 has_model=0
  local line key val
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
      model) model_val="$(unquote "$val")"; has_model=1 ;;
    esac
  done <<< "$fm"

  if [ -n "$problem" ]; then
    printf 'FAIL  %-32s %s\n' "$display" "$problem"; fail=1; return
  fi

  # --- 3. Non-empty description; non-empty name where required. ---
  if [ "$name_required" = "yes" ] && { [ "$has_name" -ne 1 ] || [ -z "$name_val" ]; }; then
    printf 'FAIL  %-32s missing or empty `name`\n' "$display"; fail=1; return
  fi
  if [ "$has_desc" -ne 1 ] || [ -z "$desc_val" ]; then
    printf 'FAIL  %-32s missing or empty `description`\n' "$display"; fail=1; return
  fi

  # --- 4. name == expected (filename / directory name), whenever name is present. ---
  if [ "$has_name" -eq 1 ] && [ "$name_val" != "$expected" ]; then
    printf 'FAIL  %-32s name `%s` != `%s`\n' "$display" "$name_val" "$expected"; fail=1; return
  fi

  # --- 5. model where pinned: present key must carry a non-empty value. ---
  if [ "$check_model" = "yes" ] && [ "$has_model" -eq 1 ] && [ -z "$model_val" ]; then
    printf 'FAIL  %-32s `model` key present but empty\n' "$display"; fail=1; return
  fi

  printf 'ok    %-32s valid frontmatter\n' "$display"
}

shopt -s nullglob

# ---------- agents: required, non-empty ----------
agents_checked=0
for agent_md in "$AGENTS_DIR"/*.md; do
  agents_checked=$((agents_checked + 1))
  fname="$(basename "$agent_md" .md)"
  check_file "$agent_md" "agent/$fname" "$fname" yes yes
done
if [ "$agents_checked" -eq 0 ]; then
  echo "FAIL  no agent defs found under $AGENTS_DIR"
  fail=1
fi

# ---------- commands: optional dir; if present it must hold valid command files ----------
commands_checked=0
if [ -d "$COMMANDS_DIR" ]; then
  for cmd_md in "$COMMANDS_DIR"/*.md; do
    commands_checked=$((commands_checked + 1))
    fname="$(basename "$cmd_md" .md)"
    check_file "$cmd_md" "command/$fname" "$fname" ifpresent no
  done
  if [ "$commands_checked" -eq 0 ]; then
    echo "FAIL  commands dir exists but holds no *.md files: $COMMANDS_DIR"
    fail=1
  fi
fi

# ---------- skills: legacy dir; validated while present, absence is fine ----------
skills_checked=0
if [ -d "$SKILLS_DIR" ]; then
  for skill_md in "$SKILLS_DIR"/*/SKILL.md; do
    skills_checked=$((skills_checked + 1))
    skillname="$(basename "$(dirname "$skill_md")")"
    check_file "$skill_md" "skill/$skillname" "$skillname" yes no
  done
  if [ "$skills_checked" -eq 0 ]; then
    echo "FAIL  skills dir exists but holds no SKILL.md files: $SKILLS_DIR"
    fail=1
  fi
fi

echo
if [ "$fail" -ne 0 ]; then
  echo "✗ one or more components have invalid frontmatter — they will silently fail to route."
  exit 1
fi
total=$((agents_checked + commands_checked + skills_checked))
echo "✓ all ${total} component(s) have valid frontmatter (${agents_checked} agent, ${commands_checked} command, ${skills_checked} skill)"
