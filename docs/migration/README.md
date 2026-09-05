# Migration overview

This directory is the operational layer of the repository. It captures
the actual migration plan from the outgoing MacBook to the incoming Dell
Windows workstation.

## Documents

| Doc | Purpose | When to use |
| --- | --- | --- |
| [`pre-return-mac-checklist.md`](pre-return-mac-checklist.md) | Final actions before handing back the Mac | Last week on the MacBook |
| [`windows-arrival-checklist.md`](windows-arrival-checklist.md) | Step-by-step bootstrap on the new machine | First day on the Dell |
| [`mac-to-windows-matrix.md`](mac-to-windows-matrix.md) | Per-tool mapping | During planning |

## Workflow

```text
+-----------------------------+    +----------------------+    +----------------------+
| Run macOS inventory script  | -> | Review and sanitize  | -> | Commit to inventory/  |
+-----------------------------+    +----------------------+    +----------------------+
                                                                      |
                                                                      v
+-----------------------------+    +----------------------+    +----------------------+
| Validate Windows bootstrap  | <- | Follow arrival       | <- | Execute arrival      |
| (scripts/inventory/         |    | checklist            |    | checklist on Dell    |
|  validate.sh)               |    +----------------------+    +----------------------+
+-----------------------------+
```

## Companion documents

- `docs/decisions/0001-windows-vs-wsl2.md` — the Windows architecture
- `docs/decisions/0002-windows-package-manager.md` — winget policy
- `docs/secrets-policy.md` — what never leaves your hands
- `inventory/` — what is currently installed
- `platforms/windows/` — Windows-specific configuration files