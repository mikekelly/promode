---
name: rationale-travels-with-the-rule
description: Mike ruled that duplicated principle rationale in promode prompts must NOT be deduped — the why is as important as the rule
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e6212ef2-659e-485c-8625-941ac99c7754
---

During the 2026-07-02 prompt-corpus review I proposed deduplicating the "why essays" that travel with promode's duplicated principles (user-need-evidence doctrine, tracer-ID requirement — each ~5 homes). Mike explicitly rejected this: "Explaining the why is arguably as important (if not more than) specifying the rule itself."

**Why:** the rationale is the frame for judgement calls the rule can't anticipate; a rule stripped of its why gets misapplied by agents in unanticipated situations.

**How to apply:** never propose stripping rationale from duplicated principle copies in promode (or similar prompt systems) to save tokens. When syncing principles across homes, sync the why along with the rule. This is now also recorded in-repo in `runbooks/sync-a-shared-principle.md` ("The rationale travels with the rule").
