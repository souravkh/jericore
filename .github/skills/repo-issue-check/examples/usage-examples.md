# Usage Examples

## Default repository

**Prompt:** `Check GitHub issues`

Expected behavior:

- Read `defaultRepository`.
- Check open issues from the last 14 days.
- Format the retrieved issues using `bug-report-format`.

## Specific repository

**Prompt:** `Check issues in microsoft/vscode`

Expected behavior:

- Check the specified repository.
- Use the last 14 days unless the user supplies dates.
- Verify repository access.

## Custom date range

**Prompt:** `Check issues in owner/repo from: 2026-10-01 to: 2026-10-15`

Expected behavior:

- Include issues created from October 1 through October 15, inclusive.
- Exclude closed issues and pull requests.

## Start date only

**Prompt:** `Check issues in owner/repo from: 2026-10-01`

Expected behavior:

- Include issues created on or after October 1, 2026, through the current date.

## End date only

**Prompt:** `Check issues in owner/repo to: 2026-10-15`

Expected behavior:

- Check the 14-day period ending October 15, 2026, including that date.

## Multiple repositories

**Prompt:** `Check issues in owner/api and owner/web from: 2026-10-01`

Expected behavior:

- Process both repositories separately.
- Apply the same date range to both.
- Report counts and failures per repository.

## Tabular issue summary

Present the retrieved issues in a Markdown table before or alongside the detailed bug reports.

| Repository | Issue | Title | Raised By | Issued At (UTC) | Status | Issue URL |
|---|---|---|---|---|---|---|
| `owner/repo` | `#123` | Example issue title | `octocat` | `2026-10-20 09:30:00` | Open | [View issue](https://github.com/owner/repo/issues/123) |

**Column requirements:**

- **Repository:** GitHub repository in `owner/repo` format.
- **Issue:** Original GitHub issue number.
- **Title:** Original issue title.
- **Raised By:** GitHub username of the issue author, not a commenter.
- **Issued At (UTC):** Original issue creation timestamp, converted to UTC when necessary.
- **Status:** Current issue status; include open issues only.
- **Issue URL:** Link to the original GitHub issue.

The row above is an illustrative example, not a real retrieved issue. Populate the table only with verified GitHub data. If the author or timestamp is unavailable, use `Not provided`.

## No matching issues

State that no open issues matched the requested repository and date filters. Do not create an empty example row.

## Save reports

After preparing the table and detailed reports, ask whether the user wants them saved unless saving was already requested.

On confirmation:

- Append the table and detailed reports to the agreed Markdown file.
- Preserve existing content.
- Avoid duplicates using the repository and issue number.
- Keep the reporter's username and original creation timestamp for each issue.
- Verify the file write succeeded before confirming the save.

Never claim retrieval or saving succeeded unless verified.