# Repository Configuration Reference

Configuration file: `.github/repositories.json`

## Schema

- `defaultRepository`: if user passed in argument any url for git.
- `repositories`: the list of repositories configured for selection.

Use the `owner/repo` format.

Example:

```json
{
  "repositories": [
    "your-org/default-repo",
    "your-org/service-api",
    "your-username/personal-project"
  ]
}
```

## Rules

- Include the default repository in the repository list.
- Replace all example values with actual repository identifiers.
- Accept GitHub URLs and normalize them to `owner/repo`.
- Ask before proceeding with repositories outside the configured list.
- Verify access through GitHub MCP; configuration does not guarantee access.
- Never store GitHub tokens or other secrets in this file.

If the configuration is missing, malformed, or has no valid default, ask the user to provide a repository.