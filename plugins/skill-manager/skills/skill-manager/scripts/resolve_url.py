#!/usr/bin/env python3
"""Resolve a GitHub shorthand (user/repo) to a full HTTPS URL."""

import argparse
import re
import sys


def resolve_url(url: str) -> tuple[str, str]:
    """Convert shorthand or URL to (full_url, repo_name)."""
    # Handle shorthand: user/repo
    if re.match(r"^[\w-]+/[\w.-]+$", url):
        url = f"https://github.com/{url}"

    # Extract repo name from URL
    match = re.search(r"github\.com[/:]([^/]+)/([^/.]+)", url)
    if not match:
        print(f"Error: Could not parse repository: {url}", file=sys.stderr)
        sys.exit(1)

    repo_name = match.group(2)

    # Normalize to HTTPS
    if not url.startswith("https://"):
        url = f"https://github.com/{match.group(1)}/{match.group(2)}"

    url = re.sub(r"\.git$", "", url)
    return url, repo_name


def main():
    parser = argparse.ArgumentParser(
        description="Resolve GitHub shorthand to full URL"
    )
    parser.add_argument(
        "repo",
        help="GitHub URL or shorthand (user/repo)"
    )

    args = parser.parse_args()
    url, name = resolve_url(args.repo)
    print(f"{url} {name}")


if __name__ == "__main__":
    main()
