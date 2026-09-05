# Decision log

This directory holds lightweight Architecture Decision Records (ADRs) for
non-obvious choices in this repository. Each decision gets a Markdown file
numbered in chronological order; once written, files are not edited except
to mark `Superseded by 000X` if the decision is reversed.

Format:

```text
# NNNN — short title

Status: Proposed | Accepted | Superseded
Date:   YYYY-MM-DD

## Context
## Decision
## Consequences
```

## Index

| ID | Title | Status |
| --- | --- | --- |
| 0001 | [Windows + WSL2 hybrid for Linux-oriented development](0001-windows-vs-wsl2.md) | Accepted |
| 0002 | [winget as the primary Windows package manager](0002-windows-package-manager.md) | Accepted |