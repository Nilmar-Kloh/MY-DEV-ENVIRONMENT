# tmux configuration

This file explains how to activate the tmux configuration stored in this repository.

1. Create a symlink from the repository to your home directory (install location):

```bash
ln -sf ~/Code/MY-DEV-ENVIRONMENT/configs/tmux/tmux.conf ~/.tmux.conf
```

2. Reload the configuration inside an existing tmux session:

```bash
tmux source-file ~/.tmux.conf
# or press the configured prefix + r
```

Notes:

- The tmux config uses `~/.tmux.conf` as the canonical entry point so the
  repository can be moved without changing the installed configuration.
- Edit the file in the repository and re-run the reload command (or press
  the reload binding) to apply changes.
