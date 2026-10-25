# jericore

Custom GitHub Copilot agents for VS Code that help with bug reporting and repository security checks.

| Agent | What it does |
| --- | --- |
| `bug-task-writer` | Turns a messy bug description into a clean, structured bug report. |
| `repo-issue-check` | Retrieves open GitHub issues from one or more repositories and returns them as a single summary table. |
| `dependabot-alert-check` | Retrieves open Dependabot alerts (critical and high by default) and returns them as a single summary table. |

All agents are read-only with respect to GitHub: they never create, edit, or close issues or alerts. Files are written only after you confirm.

## Requirements

- VS Code with GitHub Copilot Chat and support for custom agents
- A GitHub account with access to the repositories you want to check
- A GitHub MCP server connected and authenticated (needed by `repo-issue-check` and `dependabot-alert-check`; not needed by `bug-task-writer`)

## Repository layout

```
.github/
  agents/
    bug-task-writer.agent.md
    repo-issue-check.agent.md
    dependabot-alert-check.agent.md
  skills/
    bug-report-format/
    repo-issue-check/
    dependabot-alert-check/
  repositories.example.json
.vscode/
  mcp.json
```

Each agent keeps its rules short and defers the detailed format and behavior to a matching skill in `.github/skills/`.

## Setup

### 1. Configure the GitHub MCP server

`.vscode/mcp.json` connects VS Code to the hosted GitHub MCP server:

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "X-MCP-Toolsets": "repos,issues,pull_requests,dependabot",
        "X-MCP-Readonly": "true"
      }
    }
  }
}
```

The Dependabot tools are not part of the server's default toolsets, so the `dependabot` toolset must be listed explicitly. After editing this file, restart the server (see [Managing the MCP server](#managing-the-mcp-server)).

### 2. Choose the repositories to check

Copy the example file and edit it:

```
cp .github/repositories.example.json .github/repositories.json
```

```json
{
  "repositories": [
    "your-org/your-default-repo",
    "your-username/personal-project"
  ]
}
```

- Use the `owner/repo` format. GitHub URLs are accepted and normalized.
- `.github/repositories.json` is listed in `.gitignore`, so your own list is never committed.
- Never put tokens or other secrets in this file.
- You can also pass a repository directly in chat. If it is not in your list, the agent asks before continuing.

## Usage

Open Copilot Chat in agent mode and pick an agent from the agent dropdown.

### bug-task-writer

Paste anything: a chat message, dictated notes, an error log, a stack trace. The agent returns:

- Title
- Description
- Steps to Reproduce
- Actual Result
- Expected Result
- Environment (only if you mentioned it)
- Screenshots / Attachments
- Suggested Severity (only if it can reasonably be inferred, and labeled as a suggestion)

It does not invent details. Missing information is shown as "Not provided", and if the report is too vague to write a title or a single step, it asks one clarifying question. It then asks whether to save the report to a Markdown file. Saved reports are appended to a cumulative file with IDs like `BUG-001`.

### repo-issue-check

```
[GitHub repository] [from: YYYY-MM-DD] [to: YYYY-MM-DD]
```

- With no dates, it covers the last 14 days, including today.
- Only open issues are included, and pull requests are excluded.
- Output is one table with the columns: ID, Repository, Title, Issue URL, Author, Created, Status, Labels, Description, Steps to Reproduce, Actual Result, Expected Result, Environment, Screenshots / Attachments, Suggested Severity.
- IDs use the GitHub issue number, for example `ISSUE-42`.
- After the table it asks whether to save. Reports are written to `issue-report-DDMMYYSS.md` and are never overwritten.

### dependabot-alert-check

```
[GitHub repository] [severity: critical|high|both]
```

- By default it returns open alerts with `critical` and `high` severity. Medium and low are included only if you ask.
- Output is one table with the columns: ID, Repository, Package, Ecosystem, Severity, Vulnerable Range, Patched Version, Advisory, Scope, Manifest, Created, Alert URL, Suggested Action.
- IDs use the Dependabot alert number, for example `ALERT-12`.
- Suggested Action comes only from the data: upgrade to the listed patched version, or note that none is listed.
- After the table it asks whether to save. Reports are written to `dependabot-report-DDMMYYSS.md` and are never overwritten.
- Your token or login needs permission to read Dependabot alerts, and Dependabot alerts must be enabled on the target repository.

## Managing the MCP server

Agents cannot start or stop an MCP server. They can only stop calling its tools.

To restart or stop the server in VS Code:

1. Open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`).
2. Run **MCP: List Servers**.
3. Select `github`, then choose **Restart Server** or **Stop Server**.

A remote server that is left running and idle uses no tokens. Enabled tool definitions are included in each chat request, so keeping the tool list small (as the agents' `tools:` lists do) keeps requests lean.

## Troubleshooting

**`MCP error -32020: header mismatch: missing Mcp-Param-owner header`**

The server expects the client to send a header for the `owner` parameter, and the client did not. Try, in order:

1. Restart the `github` server, then run **Developer: Reload Window** and start a new chat.
2. Update VS Code and the GitHub Copilot Chat extension.
3. Run the local GitHub MCP server over stdio instead of the hosted one. Stdio has no HTTP headers, so this error cannot occur.

**Dependabot tools are missing**

Make sure `dependabot` is included in `X-MCP-Toolsets` in `.vscode/mcp.json`, then restart the server.

**403 or 404 when listing alerts**

Dependabot alerts may be disabled for the repository, or your token or login lacks permission to read them.

## Principles

- Never fabricate details. Unknown values are written as `Not provided`.
- Never claim an action succeeded unless it was verified.
- Never save a file without confirmation, and verify the write before reporting the path.

## License

MIT. See [LICENSE](LICENSE).