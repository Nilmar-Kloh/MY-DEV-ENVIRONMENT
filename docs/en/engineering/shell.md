
## Components

- zsh
- Starship
- Homebrew
- fzf
- ripgrep
- fd
- bat
- eza

## Configuration

Shell configuration is stored under: `configs/shell/`

Prompt configuration is stored under: `configs/starship/`

## Design Decisions

- Keep the shell close to stock zsh.
- Avoid large shell frameworks.
- Install only tools that solve a specific problem.
- Keep configuration modular.

```
configs/
  shell/
    zshrc
  starship/
    starship.toml
  git/
    gitconfig
  tmux/
    tmux.conf
  vscode/
    settings.json
```

---
