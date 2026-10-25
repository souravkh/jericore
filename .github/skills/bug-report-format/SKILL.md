---
name: bug-report-format
description: Structures a free-text bug description into a standard bug report with Title, Description, Steps to Reproduce, Actual Result, Expected Result, Environment, and Screenshots/Attachments. Use whenever the user describes a bug, issue, defect, or something broken and wants it written up formally.
---

# Bug Report Format

Turn the user's raw description into a clean, structured bug report. Follow these rules exactly.

## Rules

- Accept the input as-is, however messy. Never ask the user to reformat it first.
- Do not invent facts. If a piece of information (steps, environment, etc.) is missing, write "Not provided". Only fill a gap with an inferred value if it's obvious from context, and mark it `(inferred)`.
- Steps to Reproduce: numbered list, one discrete action per step, in execution order.
- Actual Result / Expected Result: 1–3 sentences each, stated as observable facts — no opinions, no blame.
- Environment: include only if the user mentioned OS, browser, app version, device, or build information. Omit the section entirely otherwise.
- Screenshots/Attachments: list anything mentioned or implied as attached; otherwise write "None provided".
- Suggested Severity: only include if severity is reasonably inferable from the described impact, such as data loss, a crash, a blocked workflow, or a cosmetic issue. Always label it as a suggestion.
- If the description is too vague to produce a title or a single reproduction step, ask exactly one targeted clarifying question instead of guessing.
- Keep the tone neutral and factual. No filler or restating the obvious.
- After generating a bug report, ask the user whether they want to save it to a Markdown (`.md`) file.
- Do not create or modify any file until the user explicitly confirms they want to save it.
- If the user confirms, create or update a Markdown file containing the bug report(s).
- If the user wants to track multiple bugs, maintain a cumulative Markdown document rather than creating a separate file for every bug, unless the user requests otherwise.
- When updating an existing document, preserve previously saved bug reports and append the new report. Do not overwrite existing content.
- Use a clear heading and unique sequential ID for each saved bug report, such as `BUG-001`, `BUG-002`, and so on.
- After saving, tell the user the exact file path. Never claim a file was saved unless the file was actually created or updated successfully.

## Output template

Always respond with exactly this structure for the bug report itself:

**### Title**
<short, specific, action-oriented>

**### Description**
<1–3 sentence summary of the problem and its impact>

**### Steps to Reproduce**
1. ...
2. ...

**### Actual Result**
<what actually happens>

**### Expected Result**
<what should happen instead>

**### Environment**
<omit this whole section if nothing was mentioned>

**### Screenshots / Attachments**
<list, or "None provided">

If severity is reasonably inferable, add:

**### Suggested Severity**
<suggested severity and brief factual justification>

After the report, ask separately:

Would you like me to save this bug report to a Markdown file?

If the user says yes, create or update the cumulative bug-report Markdown file and confirm its actual path.

See [worked examples](references/examples.md) for full input-to-output transformations covering vague reports, crash reports, and reports with environment details.