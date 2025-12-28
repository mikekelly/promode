#!/usr/bin/env python3
"""Remove an installed Claude Code skill."""

import argparse
import shutil
import sys
from pathlib import Path

from utils import (
    USER_SKILLS_DIR,
    run_git,
    is_skills_dir_a_repo,
)


def remove_skill(skill_name: str, skills_dir: Path):
    """Remove an installed skill."""
    skill_path = skills_dir / skill_name

    if not skill_path.exists():
        print(f"Skill '{skill_name}' is not installed in {skills_dir}.", file=sys.stderr)
        sys.exit(1)

    print(f"Removing {skill_name}...", flush=True)

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

    location = parser.add_mutually_exclusive_group(required=True)
    location.add_argument(
        "--user",
        action="store_true",
        help="Remove skill from user directory (~/.claude/skills/)"
    )
    location.add_argument(
        "--project",
        metavar="PATH",
        type=str,
        help="Remove skill from project directory (PATH/.claude/skills/)"
    )

    args = parser.parse_args()

    if args.user:
        remove_skill(args.skill, USER_SKILLS_DIR)
    else:
        project_path = Path(args.project).resolve()
        if not project_path.exists():
            print(f"Error: Project path does not exist: {project_path}", file=sys.stderr)
            sys.exit(1)
        skills_dir = project_path / ".claude" / "skills"
        remove_skill(args.skill, skills_dir)


if __name__ == "__main__":
    main()
