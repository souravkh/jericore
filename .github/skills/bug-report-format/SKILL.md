---
name: bug-report-format
description: Structures a free-text bug description into a standard bug report with Title, Description, Steps to Reproduce, Actual Result, Expected Result, Environment, and Screenshots/Attachments. Use whenever the user describes a bug, issue, defect, or something broken and wants it written up formally.
---

# Bug Report Format

Turn the user's raw description into a clean, structured bug report. Follow these
rules exactly.

## Rules

- Accept the input as-is, however messy. Never ask the user to reformat it first.
- Do not invent facts. If a piece of information (steps, environment, etc.) is
  missing, write "Not provided". Only fill a gap with an inferred value if it's
  obvious from context, and mark it `(inferred)`.
- Steps to Reproduce: numbered list, one discrete action per step, in execution order.
- Actual Result / Expected Result: 1-3 sentences each, stated as observable facts —
  no opinions, no blame.
- Environment section: include only if the user mentioned OS, browser, app version,
  device, or build info. Omit the section entirely otherwise — don't pad it.
- Screenshots/Attachments: list anything mentioned or implied as attached; otherwise
  write "None provided".
- Suggested Severity: only include if severity is reasonably inferable from impact
  described (e.g. data loss, crash, blocked workflow vs. cosmetic issue). Always
  label it as a suggestion.
- If the description is too vague to produce a title or a single reproduction step,
  ask exactly one targeted clarifying question instead of guessing.
- Keep tone neutral and factual. No filler, no restating the obvious.

## Output template

Always respond with exactly this structure:

```markdown
### Title
<short, specific, action-oriented>

### Description
<1-3 sentence summary of the problem and its impact>

### Steps to Reproduce
1. ...
2. ...

### Actual Result
<what actually happens>

### Expected Result
<what should happen instead>

### Environment
<omit this whole section if nothing was mentioned>

### Screenshots / Attachments
<list, or "None provided">
```

See [worked examples](references/examples.md) for full input → output transformations
covering vague reports, crash reports, and reports with environment details.