#!/usr/bin/env python3
"""List installed Claude Code skills."""

import argparse

from utils import (
    USER_SKILLS_DIR,
    PROJECT_SKILLS_DIR,
    get_remote_url,
    get_short_sha,
)


def list_skills():
    """List skills from both user and project directories."""
    found_any = False

    for label, skills_dir in [("Project", PROJECT_SKILLS_DIR), ("User", USER_SKILLS_DIR)]:
        if not skills_dir.exists():
            continue

        skills = []
        for item in skills_dir.iterdir():
            if item.is_dir() and ((item / "SKILL.md").exists() or (item / ".git").exists()):
                url = get_remote_url(item)
                sha = get_short_sha(item)
                skills.append((item.name, url, sha))

        if skills:
            found_any = True
            print(f"{label} skills ({skills_dir}):\n")
            for name, url, sha in sorted(skills):
                version_info = f" ({sha})" if sha else ""
                print(f"  {name}{version_info}")
                if url:
                    print(f"    {url}")
                print()

    if not found_any:
        print("No skills installed.")
        print("\nInstall a skill with:")
        print("  python install.py --user user/repo")
        print("  python install.py --project user/repo")


def main():
    parser = argparse.ArgumentParser(
        description="List installed Claude Code skills"
    )
    parser.parse_args()

    list_skills()


if __name__ == "__main__":
    main()
