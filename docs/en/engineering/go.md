# Go

## Purpose

Go is part of the engineering workstation toolchain for building, testing,
and maintaining software that benefits from a compiled language with a small
standard toolchain.

## Installation Policy

Go is installed as a general-purpose workstation capability. It is managed by
Homebrew and declared in the repository `Brewfile` as the `go` formula. This
keeps installation and upgrades reproducible without pinning a patch release.

Go is useful across different projects and does not depend on a particular
application, service, or repository architecture.

## Version Policy

The workstation follows the current stable Go release provided by
Homebrew. The `Brewfile` tracks the formula without pinning a patch
release so new workstations receive the current stable patch version
through the normal Homebrew update process.

To discover the installed version at any time:

```bash
go version
```

## GOPATH and GOBIN

The default `GOPATH` is `$HOME/go`. No explicit `GOPATH` export is required.
When `GOBIN` is unset, Go installs command binaries into `$GOPATH/bin`, which
is `$HOME/go/bin` on this workstation. That directory is included in the
shared shell `PATH`.

Setting `GOBIN` changes the installation directory for Go command binaries.
Any custom `GOBIN` directory must also be added to `PATH` when its binaries
should be available from the shell.

## Installed Go Tools

- `gopls` for language-server support.
- `govulncheck` for checking dependencies and source code for known
  vulnerabilities.
- `goimports` for formatting and import organization.
- `staticcheck` for static analysis.
- `dlv` (Delve) for debugging Go programs.

Additional Go tools should be added only when they provide workstation-wide
value rather than to support one project.

## VS Code Setup

The Go extension is included in the shared VS Code extension recommendations.
The shared settings enable the Go language server, use `gofmt` for formatting,
and keep automatic Go tool updates disabled. Import organization follows the
existing explicit save-action policy.

## Workstation Philosophy

Go is documented here as a reusable workstation capability. Project-specific
frameworks, generators, linters, build systems, and development servers do not
belong in this repository until they are broadly useful across future
engineering workstations.
