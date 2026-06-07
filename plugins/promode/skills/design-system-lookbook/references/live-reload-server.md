# Live-reload static preview server

A dependency-light reference implementation for the live-refresh loop in the [design-system-lookbook](../SKILL.md) skill: serve static design/marketing artifacts (lookbook, decks, landing pages), watch the files, and push a reload to the browser on every change.

**Use this only for static HTML artifacts with no dev server of their own.** If the project already has HMR/live-reload (Vite, Next, etc.), use *that* — don't run a second server.

**Shape:** static file server + `fs.watch` file-watcher + Server-Sent Events (SSE) reload channel + a ~10-line browser client. Node built-ins only — zero npm dependencies. KISS: no debounce config, no cache layer, no framework.

## Server — `preview.js`

```js
#!/usr/bin/env node
// Static preview server with live reload over SSE. No dependencies.
// Usage: node preview.js [root-dir] [port]   (defaults: . and 4321)
const http = require('http');
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(process.argv[2] || '.');
const PORT = Number(process.argv[3] || 4321);
const TYPES = { '.html': 'text/html', '.css': 'text/css', '.js': 'text/javascript',
  '.json': 'application/json', '.svg': 'image/svg+xml', '.png': 'image/png',
  '.jpg': 'image/jpeg', '.woff2': 'font/woff2' };

// The snippet injected into every HTML response: opens an SSE channel and
// reloads the page when the server signals a file change.
const CLIENT = `<script>
new EventSource('/__reload').onmessage = () => location.reload();
</script>`;

const clients = new Set(); // open SSE responses

const server = http.createServer((req, res) => {
  if (req.url === '/__reload') {                       // SSE channel
    res.writeHead(200, { 'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache', Connection: 'keep-alive' });
    res.write('\n');
    clients.add(res);
    req.on('close', () => clients.delete(res));
    return;
  }
  // Resolve path, default to index.html, and block path traversal.
  let urlPath = decodeURIComponent(req.url.split('?')[0]);
  if (urlPath.endsWith('/')) urlPath += 'index.html';
  const file = path.join(ROOT, urlPath);
  if (!file.startsWith(ROOT)) { res.writeHead(403).end('Forbidden'); return; }

  fs.readFile(file, (err, buf) => {
    if (err) { res.writeHead(404).end('Not found'); return; }
    const ext = path.extname(file).toLowerCase();
    let body = buf;
    if (ext === '.html') body = buf.toString().replace('</body>', CLIENT + '</body>');
    res.writeHead(200, { 'Content-Type': TYPES[ext] || 'application/octet-stream' });
    res.end(body);
  });
});

// Watch the tree; on any change, tell every connected browser to reload.
fs.watch(ROOT, { recursive: true }, () => {
  for (const res of clients) res.write('data: reload\n\n');
});

server.listen(PORT, () =>
  console.log(`Preview: http://localhost:${PORT}  (serving ${ROOT}, live-reload on)`));
```

## Run it

```bash
node preview.js docs/product/lookbook 4321
# open http://localhost:4321 — edit any file under the dir and the browser reloads
```

## Notes

- **The browser client is injected, not authored.** Every HTML response gets the `<script>` before `</body>`, so artifacts stay plain HTML with no reload plumbing in source. If a page has no `</body>` (a bare fragment), append the snippet another way or wrap it in a minimal HTML shell.
- **SSE, not websockets, on purpose.** One-way server→browser is all a reload needs; SSE is a few lines and auto-reconnects. Swap in a websocket only if you later need browser→server messages.
- **`fs.watch({recursive:true})`** is supported on macOS and Windows; on Linux, recursive mode lands in newer Node — if it's unavailable, watch the top dir or add a tiny poll. Editors that save via atomic-rename can fire multiple events; a reload is idempotent so it's harmless (add a small debounce only if reloads feel chatty).
- **Promode ownership:** `environment-manager` runs this as a managed dev service and reports the URL; `verifier` screenshots the served page against the lookbook / source-of-truth. Keep it dev-only — it serves files unauthenticated and is not a production surface.
</content>
