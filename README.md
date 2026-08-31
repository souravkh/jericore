---
title: bug-task-writer
description: Lightweight bug-report authoring and issue-analysis assets for turning rough bug notes into structured reports.
---

# Bug Task Writer

A comprehensive toolkit for converting rough bug descriptions into clean, structured bug reports and analyzing GitHub issues into consolidated reports.

## Overview

This repository contains a small set of custom agent and skill assets for converting rough bug descriptions into clean, structured bug reports and for analyzing GitHub issues into a single consolidated report. Whether you're triaging incoming bug reports or analyzing existing GitHub issues, bug-task-writer streamlines the process with consistent, professional output.

## Features

- **Bug Report Generation**: Convert raw, unstructured bug notes into properly formatted bug reports with standardized sections
- **Issue Analysis**: Automatically retrieve GitHub issues and format them into a consolidated report
- **Customizable Output**: Structured reporting with Title, Description, Steps to Reproduce, Actual Result, Expected Result, and more
- **Examples Included**: Reference examples showing transformation from raw input to polished reports

## Included Assets

The following assets are available in this repository:

* **`.github/agents/bug-task-writer.agent.md`** - Agent that converts raw bug notes into a structured bug report
* **`.github/agents/issue-analyser.agent.md`** - Agent that reads a GitHub repository URL, fetches issue details, and formats them for reporting
* **`.github/skills/bug-report-format/SKILL.md`** - Defines the exact bug-report output structure and rules
* **`.github/skills/bug-report-format/references/examples.md`** - Shows input-to-output transformations with real examples

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/souravkh/bug-task-writer.git
   ```

2. Navigate to the repository directory:
   ```bash
   cd bug-task-writer
   ```

3. The assets are ready to use immediately. No additional installation is required for the agents and skills.

## Usage

### Using the Bug Task Writer Agent

The bug-task-writer agent converts rough bug descriptions into structured reports:

1. Open your VS Code editor with GitHub Copilot enabled
2. Reference the bug-task-writer agent in your chat
3. Provide your raw bug description
4. The agent will generate a structured bug report

### Using the Issue Analyzer Agent

The issue-analyser agent retrieves and formats GitHub issues:

1. Create a `repo-input.md` file with your target repository URL
2. Reference the issue-analyser agent
3. The agent will fetch all issues and create a consolidated report

### Example Output Structure

Bug reports generated follow this structure:

- **Title**: Brief, descriptive title of the bug
- **Description**: Detailed explanation of the issue
- **Steps to Reproduce**: Clear, numbered steps to recreate the bug
- **Actual Result**: What currently happens
- **Expected Result**: What should happen instead
- **Environment**: System details and configuration
- **Screenshots/Attachments**: Visual evidence if applicable

## How It Works

1. **Input Processing**: Agents parse raw bug descriptions or GitHub issues
2. **Standardization**: Content is formatted according to the bug-report-format SKILL
3. **Enrichment**: Additional context and structure is added
4. **Output Generation**: Polished, ready-to-use bug reports are created

## Contributing

Contributions are welcome! If you'd like to improve bug-task-writer:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Make your changes and add tests if applicable
4. Commit with clear messages
5. Push to your fork
6. Open a Pull Request with a detailed description

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or suggestions, please open a GitHub issue in this repository. We appreciate feedback and contributions!

## Related Projects

- **GitHub Copilot**: AI-powered coding assistant that powers these agents
- **VS Code**: The editor where these agents are used
- **Prompt Engineering**: Foundation for effective agent design

---

**Last Updated**: August 2026
