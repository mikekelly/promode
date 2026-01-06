# Required MCP Servers

Promode projects must have a `.mcp.json` file in the project root with these three MCP servers:

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

| Server | Purpose |
|--------|---------|
| **context7** | Fetches up-to-date official documentation for libraries |
| **exa** | Real-time web search (requires `EXA_API_KEY` env var) |
| **grep_app** | Ultra-fast code search across GitHub repositories |

## Installation Location

MCP servers must be installed in the **project's** `.mcp.json`, not the user's `~/.claude/` directory. This ensures:

1. Project-specific configuration travels with the codebase
2. Team members get consistent tooling
3. Different projects can have different MCP configurations

## Notes

- `EXA_API_KEY` should be set in the user's environment, not committed to git
- The `grep_app` server is HTTP-based (no local process needed)
- `context7` and `exa` use npx to run the MCP servers on-demand
