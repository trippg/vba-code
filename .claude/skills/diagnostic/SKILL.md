---
name: diagnostic
description: Run a self-diagnostic on Cowork's current state to identify why the session feels slow, degraded, or less intelligent than expected. Use whenever the user says things like "/diagnostic", "diagnose", "something is off", "cowork feels slow", "you seem dumber", "this session feels degraded", or "what's wrong", or otherwise expresses that output quality has dropped. Trigger this skill liberally any time the user complains about quality, speed, or intelligence rather than guessing at causes.
---

# Diagnostic

Run this self-diagnostic when the user suspects Cowork is underperforming. The goal is to localize the cause to one of: model state, account state, context state, scaffolding, external context, local environment, or platform/network. Be honest about what cannot be determined rather than guessing.

## Operating rules

- Output in plain ASCII. No emoji, no markdown decoration beyond what is needed for readability.
- For every item: state the answer, or state "cannot determine" with a one-line reason. Do not confabulate.
- Do not skip sections even if they seem irrelevant. Negative findings are diagnostic.
- After the structured report, end with a short "Most likely cause" paragraph naming the single best hypothesis and the one action that would test or fix it.

## Diagnostic report

Produce the following sections in order:

1. Model identity
- Exact model version string currently active.
- Thinking effort level: none, low, medium, high, xhigh, max.
- Whether the model or effort level appears to have changed mid-session.
- Any indication of fallback routing, reduced thinking budget, or capacity-driven degradation. State explicitly if this cannot be detected.

2. Account and plan state
- Current plan tier if visible.
- Usage consumed this period as a percent of limit, if visible.
- Any active throttling, rate limits, or quota warnings.
- Session token age; any auth refresh issues this session.

3. Context state
- Estimated context usage as a percent of total window.
- Top consumers in order: system prompt, tool definitions, file contents, prior turn outputs, tool results.
- Whether the session has been auto-summarized or compacted, and when.
- Specific redundant or stale content that could be pruned.

4. Scaffolding overhead
- Every active tool, skill, plugin, and MCP connector.
- For each: used this session yes or no, last response time, any timeouts or errors.
- Items loaded but unused.
- Connectors configured but unreachable.

5. External context and memory
- Test Hindsight reachability at https://ds1522.tail943e3.ts.net:8443/mcp/ with a recall on bank_id "default". Report latency and result.
- All other memory or context sources available.
- Specific context about Tripp, Innova Regenerative Health, NLTB, Vantage Data House, Fisher AGC, or the active task that is missing but would help.

6. Local environment
- VM working directory, Python version, key packages loaded.
- File system permissions: which folders are readable, writable.
- Host resource pressure if detectable: VM CPU, memory, disk.
- Any errors, warnings, or rate limit hits this session.

7. Network and platform
- Round-trip latency to Anthropic endpoints if measurable.
- Desktop app version and last update check if accessible.
- Any known platform incidents or status flags.
- Discrepancies between selected model and actual responding model.

8. Self assessment of recent quality
- Identify the single decision point in the recent session where output quality may have suffered.
- Classify the cause: missing context, ambiguous instruction, model uncertainty, tool failure, output constraint, context crowding, upstream degradation, or other.
- State the one change to the prompt or environment that would most improve quality on the current task.

## Closing

End with two short paragraphs:

- "Most likely cause" naming the single best hypothesis from the findings above.
- "Recommended next action" naming exactly one thing to try - restart the task, switch model, disable a connector, check status page, file a ticket, etc.
