#!/usr/bin/env python3
"""Get the version (git SHA) of an installed Claude Code skill."""

import argparse
import sys
from pathlib import Path

from utils import (
    USER_SKILLS_DIR,
    get_short_sha,
    get_remote_url,
)


def show_version(skill_name: str, skills_dir: Path):
    """Show the version of an installed skill."""
    skill_path = skills_dir / skill_name

    if not skill_path.exists():
        print(f"Skill '{skill_name}' not found in {skills_dir}.", file=sys.stderr)
        sys.exit(1)

    sha = get_short_sha(skill_path)
    url = get_remote_url(skill_path)

    if sha:
        print(f"{skill_name}: {sha}")
        if url:
            print(f"  Source: {url}")
        print(f"  Location: {skill_path}")
    else:
        print(f"{skill_name}: unknown version (not a git repository)", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Get the version (git SHA) of an installed Claude Code skill"
    )
    parser.add_argument(
        "skill",
        help="Name of the skill to check"
    )

    location = parser.add_mutually_exclusive_group(required=True)
    location.add_argument(
        "--user",
        action="store_true",
        help="Check skill in user directory (~/.claude/skills/)"
    )
    location.add_argument(
        "--project",
        metavar="PATH",
        type=str,
        help="Check skill in project directory (PATH/.claude/skills/)"
    )

    args = parser.parse_args()

    if args.user:
        show_version(args.skill, USER_SKILLS_DIR)
    else:
        project_path = Path(args.project).resolve()
        if not project_path.exists():
            print(f"Error: Project path does not exist: {project_path}", file=sys.stderr)
            sys.exit(1)
        skills_dir = project_path / ".claude" / "skills"
        show_version(args.skill, skills_dir)


if __name__ == "__main__":
    main()
