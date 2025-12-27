#!/usr/bin/env python3
"""Remove an installed Claude Code skill."""

import argparse
import shutil
import sys
from pathlib import Path

from utils import (
    run_git,
    is_skills_dir_a_repo,
    find_skill,
)


def remove_skill(skill_name: str, skills_dir: Path):
    """Remove an installed skill."""
    skill_path = skills_dir / skill_name

    if not skill_path.exists():
        print(f"Skill '{skill_name}' is not installed.", file=sys.stderr)
        sys.exit(1)

    print(f"Removing {skill_name}...")

    if is_skills_dir_a_repo(skills_dir):
        # Remove submodule
        run_git(["submodule", "deinit", "-f", skill_name], cwd=skills_dir, check=False)
        run_git(["rm", "-f", skill_name], cwd=skills_dir, check=False)

    if skill_path.exists():
        shutil.rmtree(skill_path)

    print(f"Successfully removed {skill_name}")


def main():
    parser = argparse.ArgumentParser(
        description="Remove an installed Claude Code skill"
    )
    parser.add_argument(
        "skill",
        help="Name of the skill to remove"
    )

    args = parser.parse_args()

    skill_path = find_skill(args.skill)
    if skill_path:
        remove_skill(args.skill, skill_path.parent)
    else:
        print(f"Skill '{args.skill}' not found in user or project skills.", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
