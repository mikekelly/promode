# LSP Server Configuration

Promode projects should have LSP servers configured for all languages used in the project. This enables code intelligence features like go-to-definition, find references, and diagnostics.

## Configuration Location

LSP servers can be configured in two ways:

1. **Official plugins** (recommended) — Enable in `.claude/settings.local.json`
2. **Custom `.lsp.json`** — For languages without official plugins

## Official LSP Plugins

These plugins are available from the Claude Code marketplace:

| Language | Plugin | Binary Required |
|----------|--------|-----------------|
| TypeScript/JavaScript | `typescript-lsp@claude-plugins-official` | `typescript-language-server` (npm) |
| Python | `pyright-lsp@claude-plugins-official` | `pyright` (pip or npm) |
| Rust | `rust-lsp@claude-plugins-official` | `rust-analyzer` |

### Enabling Official Plugins

Add to `.claude/settings.local.json`:

```json
{
  "enabledPlugins": {
    "typescript-lsp@claude-plugins-official": true,
    "pyright-lsp@claude-plugins-official": true,
    "rust-lsp@claude-plugins-official": true
  }
}
```

## Custom LSP Configuration

For languages without official plugins, create `.lsp.json` in the project root:

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".go": "go"
    }
  },
  "elixir": {
    "command": "elixir-ls",
    "extensionToLanguage": {
      ".ex": "elixir",
      ".exs": "elixir"
    }
  }
}
```

### Common Language Servers

| Language | Command | Install |
|----------|---------|---------|
| Go | `gopls` | `go install golang.org/x/tools/gopls@latest` |
| Elixir | `elixir-ls` | Build from source or use release |
| Ruby | `solargraph` | `gem install solargraph` |
| C/C++ | `clangd` | System package manager |
| Java | `jdtls` | Eclipse JDT LS |
| PHP | `phpactor` | Composer or PHAR |

## Language Detection

Detect languages by file extension:

| Extensions | Language | LSP Required |
|------------|----------|--------------|
| `.ts`, `.tsx` | TypeScript | typescript-lsp |
| `.js`, `.jsx` | JavaScript | typescript-lsp |
| `.py` | Python | pyright-lsp |
| `.rs` | Rust | rust-lsp |
| `.go` | Go | gopls (custom) |
| `.ex`, `.exs` | Elixir | elixir-ls (custom) |
| `.rb` | Ruby | solargraph (custom) |

## Installation Requirements

LSP plugins only configure the connection — **you must install the language server binary separately**:

```bash
# TypeScript
npm install -g typescript-language-server typescript

# Python
pip install pyright
# or: npm install -g pyright

# Rust
# See: https://rust-analyzer.github.io/manual.html#installation

# Go
go install golang.org/x/tools/gopls@latest
```

## Notes

- LSP servers provide: diagnostics, go-to-definition, find references, hover info
- Binary must be in PATH for the LSP plugin to work
- Project-level config (`.lsp.json`) is checked into git for team consistency
