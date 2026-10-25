---
name: dependabot-alert-check
description: Retrieves open Dependabot security alerts for configured or user-provided repositories using GitHub MCP, filters to critical and high by default, and prepares a structured summary table. Can separately report dependency-update pull requests when requested.
---

# Dependabot Alert Check

## Purpose

Retrieve open Dependabot security alerts from GitHub repositories, defaulting to critical and high severity, and present them in one Markdown table. When the user asks for all severities, include critical, high, medium, and low. Dependency-update pull requests are a separate record type and must never be assigned a security severity based on their title.

## Instructions

### 1. Select repositories

Read `.github/repositories.json`.

- Use a user-provided GitHub URL or `owner/repo` when supplied.
- If no repository is provided, use `repositories`.
- If the user requests multiple repositories, process each.
- If a repository is outside the configured list, ask the user before proceeding.
- If the configuration is missing, invalid, or has no valid default, ask the user to provide a repository.

This uses the same configuration as the `repo-issue-check` skill. See `.github/skills/repo-issue-check/references/repository-config.md`.

### 2. Determine severity scope

- Default to `critical` and `high` severity only.
- If the user explicitly requests only `high`, query only high. If the user explicitly requests all severities, query `critical`, `high`, `medium`, and `low`.
- Only open alerts are in scope unless the user asks for another state.

### 3. Retrieve alerts

Tell the user that this workflow retrieves alerts through GitHub MCP. It requires a GitHub MCP server that is installed, connected, and authenticated, with the `dependabot` toolset enabled.

- Use `list_dependabot_alerts` with `state: "open"` and a severity filter.
- The `severity` filter accepts one value per call. For the default scope, make one call for `critical` and one for `high`; add `medium` and `low` calls only if the user requests all severities.
- Retrieve all pages when pagination is supported.
- Use `get_dependabot_alert` only if a required field is missing from the list result. Do not call it for every alert.
- Preserve: alert number, URL, package name, ecosystem, severity, vulnerable version range, first patched version, advisory identifiers (GHSA/CVE), manifest path, dependency scope (runtime or development), and creation timestamp.
- Report inaccessible repositories, 403/404 responses (Dependabot alerts may be disabled for the repository, or the token may lack permission), and incomplete results honestly. Do not retry in a loop.
- If GitHub MCP tools are unavailable, do not claim that alerts were checked. Tell the user to enable the Dependabot toolset in their GitHub MCP configuration, authenticate, and retry.
- If the alerts endpoint fails, distinguish that failure from dependency-update pull requests. When the user asks for all Dependabot items/bumps, or provides evidence of Dependabot bump PRs, list open pull requests, paginate through all pages, and keep only PRs whose author is `dependabot[bot]`. Report these as dependency-update PRs, not security alerts. Do not infer vulnerability severity or advisory details from PR titles.
- Once all matching alerts have been retrieved for the current request, make no further GitHub MCP calls for that request.

Never claim retrieval succeeded unless the tool results confirm it.

### 4. Prepare alert rows

Produce one row per retrieved security alert, sorted critical first, then high. If using the pull-request fallback, include dependency updates as separate rows in the same table. For a grouped update PR, create one row for each dependency listed in the PR body or diff, repeating the PR reference as needed.

Columns, in order: Type, ID, Repository, Package, Affected Component, Ecosystem, Severity, Vulnerability / Advisory Summary, Advisory ID, Affected Version, Vulnerable Range, Patched Version, Dependency Scope, Affected File / Manifest, Created, Status, URL, Suggested Action.

- Type is `Security alert` or `Dependency update PR`.
- ID is `ALERT-<number>` using the GitHub alert number, or `PR-<number>` using the pull request number.
- For security alerts, populate vulnerability summary, package, affected component, severity, versions, advisory ID, dependency scope, and manifest/file from the alert/advisory data when available.
- Use `Not provided` for unavailable values. Do not invent affected files, versions, advisory IDs, vulnerability descriptions, or severities. For a failed alert retrieval, clearly state the error and distinguish it from a verified empty result.
- Suggested Action is derived only from the data: `Upgrade to <patched version>` when a patched version exists, otherwise `No patched version listed; review advisory`.
- For dependency-update PR rows, put the package/component, from-version, to-version, and affected manifest/file from the PR body or diff when identifiable. Put the PR title in Vulnerability / Advisory Summary only as a PR title (not a vulnerability claim), set alert-only fields to `Not applicable`, use the PR state as Status, and set Suggested Action to `Review dependency update PR`.
- Keep multi-part cell content within the cell using `<br>`; escape literal pipe characters as `\|`.

### 5. Present results

- Always return exactly one table, including when no alerts match. For no matches, return the table header with no data rows and no extra prose.
- Do not include separate per-alert sections or prose outside the table.

### 6. Save reports

- Always ask whether the user wants the results saved. Do not save until the user confirms for the current results.
- On confirmation, save one Markdown file containing the single summary table for all repositories in the current request.
- Name the file `dependabot-report-DDMMYYSS.md` using local day, month, two-digit year, and seconds, digits only and no separators.
- Never overwrite an existing file. If the name already exists, wait until the next second and use a new name.
- Verify the write succeeded before confirming the path.
- After saving, tell the user the exact filename and absolute path, repository or repositories covered, severity scope, record count and types, and any retrieval limitations. Do not imply dependency-update PRs are security alerts.

Never claim a report was saved without verifying the write.
