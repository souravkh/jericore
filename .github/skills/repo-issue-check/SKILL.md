---
name: repo-issue-check
description: Retrieves open GitHub issues from configured or user-provided repositories using GitHub MCP, filters by creation date, and prepares structured bug reports. Use when checking repository issues, tracking reported bugs, or compiling GitHub issues into Markdown reports.
---

# Repo Issue Check

## Purpose

Retrieve open issues from GitHub repositories, filter them by date, and prepare structured reports using the `bug-report-format` skill.

## Instructions

### 1. Select repositories

Read `.github/repositories.json`.

- Use a user-provided GitHub URL or `owner/repo` when supplied.
- If no repository is provided, use `repositories`.
- If the user requests multiple repositories, process each.
- If a repository is outside the configured list, ask the user before proceeding.
- If the configuration is missing, invalid, or has no valid default, ask the user to provide a repository.
- Verify repository access through GitHub MCP.

See [repository configuration](references/repository-config.md).

### 2. Determine the date range

Filter issues using their creation timestamp (`created_at`).

- No dates supplied: last 14 days, including today.
- Only `from` supplied: from that date through today.
- Both `from` and `to` supplied: include both dates.
- Only `to` supplied: the 14-day period ending on that date.

Validate dates and reject invalid ranges where the start date is later than the end date. Use the current date at execution time.

### 3. Retrieve GitHub issues

Tell the user that this workflow retrieves issues through GitHub MCP. It requires a GitHub MCP server that is installed, connected, and authenticated in the current Copilot/VS Code session. Use its issue-listing tools to retrieve issues.

- Retrieve open issues only.
- Exclude pull requests.
- Apply the selected repository and date filters.
- Retrieve all matching pages when pagination is supported.
- Preserve the issue number, URL, title, body, author, creation timestamp, status, labels, and available reproduction details.
- Report inaccessible repositories, authentication failures, and incomplete results honestly.
- If GitHub MCP tools are unavailable, do not claim that issues were checked. Tell the user to install or enable a GitHub MCP server in their Copilot/VS Code setup, authenticate it with GitHub, and retry. Do not claim to install or configure the server for them.

Never claim retrieval succeeded unless the tool results confirm it.

### 4. Prepare issue rows

Use the `bug-report-format` skill's factuality rules to populate one table row per issue. The final output and saved report must contain a single table only; do not add separate headings or prose reports for each issue.

- Keep model use economical: prefer an available low-cost model, then escalate once to a higher-cost/capability model only if needed for accuracy or completion. If explicit model selection or escalation is unavailable, use the runtime/default model. Do not hard-code model names.
- Do not repeat issue retrieval or issue formatting solely to try another model.
- Preserve facts from the original issue.
- Include the source repository, issue number, issue URL, author, and creation timestamp in the row.
- Use the GitHub issue number as the report ID (for example, `ISSUE-42`); do not assign a sequential ID.
- Use `Not provided` for unavailable details. Do not invent reproduction steps, actual or expected results, severity, environment, or attachments.
- Use these columns, in order: ID, Repository, Title, Issue URL, Author, Created, Status, Labels, Description, Steps to Reproduce, Actual Result, Expected Result, Environment, Screenshots / Attachments, Suggested Severity.
- Keep multi-part cell content within the cell using `<br>` for line breaks; escape literal pipe characters as `\|`.

### 5. Present results

- Always return exactly one issue table, including when no issues match. Use the columns defined above.
- Put all issue details in their corresponding table cells. Do not include separate per-issue reports, headings, or prose outside the table.
- For no matches, return the table with its header and no data rows; do not add prose outside the table.

### 6. Save reports

- Always ask whether the user wants the results saved, even if they previously saved a report. Do not save until the user confirms for the current results.
- On confirmation, save one Markdown file containing the single summary table for all repositories included in the current request.
- Name the file `issue-report-DDMMYYSS.md`, using the local day, month, two-digit year, and seconds at the time of saving. Use digits without separators (for example, `issue-report-25102628.md`).
- Do not use a cumulative report file across separate runs or create separate per-issue sections. Never overwrite an existing file; if the generated name already exists, wait until the next second and generate a unique filename.

- Use an available file-writing tool and verify that the operation succeeded before confirming.

Never claim a report was saved without verifying the write operation.

### 7. Summarize results

See [usage examples](examples/usage-examples.md) for expected behavior.