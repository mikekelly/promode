#!/usr/bin/env python3
"""List installed Claude Code skills."""

import argparse
import sys
from pathlib import Path

from utils import (
    USER_SKILLS_DIR,
    get_remote_url,
    get_short_sha,
)


def list_skills_in_dir(skills_dir: Path, label: str) -> bool:
    """List skills in a directory. Returns True if any skills found."""
    if not skills_dir.exists():
        return False

    skills = []
    for item in skills_dir.iterdir():
        if item.is_dir() and ((item / "SKILL.md").exists() or (item / ".git").exists()):
            url = get_remote_url(item)
            sha = get_short_sha(item)
            skills.append((item.name, url, sha))

    if skills:
        print(f"{label} skills ({skills_dir}):\n")
        for name, url, sha in sorted(skills):
            version_info = f" ({sha})" if sha else ""
            print(f"  {name}{version_info}")
            if url:
                print(f"    {url}")
            print()
        return True
    return False


def main():
    parser = argparse.ArgumentParser(
        description="List installed Claude Code skills"
    )
    parser.add_argument(
        "--user",
        action="store_true",
        help="List skills in user directory (~/.claude/skills/)"
    )
    parser.add_argument(
        "--project",
        metavar="PATH",
        type=str,
        help="List skills in project directory (PATH/.claude/skills/)"
    )

    args = parser.parse_args()

    found_any = False

    # If neither --user nor --project specified, show both (user only)
    if not args.user and not args.project:
        if list_skills_in_dir(USER_SKILLS_DIR, "User"):
            found_any = True
    else:
        if args.user:
            if list_skills_in_dir(USER_SKILLS_DIR, "User"):
                found_any = True

        if args.project:
            project_path = Path(args.project).resolve()
            if not project_path.exists():
                print(f"Error: Project path does not exist: {project_path}", file=sys.stderr)
                sys.exit(1)
            skills_dir = project_path / ".claude" / "skills"
            if list_skills_in_dir(skills_dir, "Project"):
                found_any = True

    if not found_any:
        print("No skills installed.")
        print("\nInstall a skill with:")
        print("  python install.py --user user/repo")
        print("  python install.py --project /path/to/project user/repo")


if __name__ == "__main__":
    main()
