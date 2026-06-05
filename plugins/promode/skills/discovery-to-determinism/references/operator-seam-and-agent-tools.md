# The operator seam ⇄ agent-tool convergence

Depth on the load-bearing claim in the [discovery-to-determinism](../SKILL.md) skill: the below-UI **operator seam** you build for fast, deterministic headless testability is the *same architectural investment* that makes the system AI-agent-operable. This file says exactly where that holds, where it breaks, and how to build a seam that *could* serve an agent without ever becoming an unguarded one by accident.

## The defensible claim

Decoupling real logic from the UI behind a clean, observable, scriptable boundary is **one architectural move that pays out twice**:
1. a **fast deterministic headless test client**, and
2. a **substrate AI-agent tools can be built on** —

because a test runner and an agent are both **non-human operators** needing `observe()` + `act()` over the real logic with the GUI stripped away. The convergence is genuine and strongest at the **low adapter layer** (`observe() → state/element-tree`, `act(action)` over a stable tree). It is weakest — and must never be asserted as identity — at the **policy layer**.

> **Convergence of the SEAM, not identity of the INTERFACE.** One seam underneath; two *tailored* artifacts on top. Do not ship a single interface to both consumers.

## The four divergence axes

| Axis | Test client wants… | Agent surface wants… |
|------|--------------------|----------------------|
| **Granularity** | fine, deterministic primitives ("tap node X", "set field Y") | intent-level, composable affordances ("refund this order") |
| **Authority / blast-radius** | sandbox **god-mode**: reset, seed, freeze, auth-bypass, time control | **least privilege**, under the *same* auth / permission / tenancy boundary as a human user |
| **Self-description** | terse, positional, implicit — the author knows the contract | LLM-readable names, schemas, descriptions, and *error messages* — see the `axi` skill |
| **Failure semantics** | deterministic **fail-fast** (and, in discovery, freeze) | tolerant, recoverable, **idempotent**; partial failure must be safe |

**Defer self-description to `axi`.** The discipline of making a CLI/tool ergonomic for an agent (clear names, discoverable help, structured errors) is exactly what the `axi` skill governs. When you expose a seam as an agent tool, apply `axi` — don't re-derive agent-facing ergonomics here.

## The security fence (non-negotiable)

- **Never expose test god-mode to a production agent.** Reset, seed, freeze, and auth-bypass exist so a *sandboxed test* can arrange state cheaply. Handed to a production-facing agent, the same primitives are a privilege-escalation and data-destruction path.
- **An agent surface is a new external boundary.** It earns the same security review as any other public interface — authn/authz, tenancy isolation, rate limits, audit. "It's just the test seam with a nicer description" is the mistake that gets someone owned.
- The shared substrate is the *low-level* `observe()`/`act()` adapter and the decoupling it enforces — **not** the privileged operations layered on top for tests.

## How to build the seam so it *could* serve an agent later

Without over-building (the seam is still a **test-driven extraction**, no wider than today's failing test demands):
- **Shape `observe()`/`act()` cleanly.** A stable, inspectable view of state and a small set of orthogonal actions over real logic is what *both* consumers need; getting this right is the convergence, and it costs nothing extra to keep it clean.
- **Keep privileged/test-only operations clearly separable** from the neutral operate-the-system core, so a future agent surface can be composed from the safe subset without dragging god-mode along.
- **Don't build the agent surface now.** Designing *toward* agent-operability is free; *shipping* an agent tool is a separate, goal-backed piece of work with its own security review. Until a real goal traces up to it (feature-knowledge-base rule), it stays a design heuristic, not a deliverable.

## Honest status (n=1)

On the one real build behind this methodology, **only the testability half was actually realised** — a fast headless client over a below-UI seam. **No agent surface was ever shipped on it.** The agent-operability leg is therefore a *structural prediction*: a strong, specific hypothesis about what the same seam enables, worth designing toward and worth validating on a second build — but **not** a proven result, and **not** a reason on its own to build a seam. State it as such wherever it appears; overselling "free agent-operability" invites exactly the auth / side-effect / blast-radius counterexample that would discredit the whole frame.
