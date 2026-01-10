# Recommended MCP Servers

MCP servers are **optional optimisations** that improve agent effectiveness for documentation lookup and code search. Promode works without them, but they're recommended for enhanced capabilities.

## Configuration

Create `.mcp.json` in the project root:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "exa": {
      "command": "npx",
      "args": ["-y", "exa-mcp-server"],
      "env": {
        "EXA_API_KEY": "${EXA_API_KEY}"
      }
    },
    "grep_app": {
      "type": "http",
      "url": "https://mcp.grep.app"
    }
  }
}
```

## Purpose

| Server | Purpose | When useful |
|--------|---------|-------------|
| **context7** | Fetches up-to-date official documentation for libraries | Working with unfamiliar libraries, checking API changes |
| **exa** | Real-time web search (requires `EXA_API_KEY` env var) | Finding recent solutions, checking current best practices |
| **grep_app** | Ultra-fast code search across GitHub repositories | Finding usage examples, understanding patterns in OSS |

## When to Install

These are worth installing if:
- You frequently work with libraries where docs change
- You want agents to find real-world usage examples
- You need real-time web search for current info

Skip them if:
- You prefer agents to work offline
- You're working on an air-gapped system
- You have other documentation/search tools you prefer

## Installation Location

If you choose to install MCP servers, put them in the **project's** `.mcp.json`, not the user's `~/.claude/` directory. This ensures:

1. Project-specific configuration travels with the codebase
2. Team members get consistent tooling
3. Different projects can have different MCP configurations

## Notes

- `EXA_API_KEY` should be set in the user's environment, not committed to git
- The `grep_app` server is HTTP-based (no local process needed)
- `context7` and `exa` use npx to run the MCP servers on-demand
