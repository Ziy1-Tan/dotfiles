# AGENTS.md

- Use `~/github/dotfiles` as the chezmoi source directory; no `~/dotfiles` alias.
- Repo-only files go in `.chezmoiignore`. `local.zsh` is copied once, never overwritten.
- `brew` is the only CLI package manager on Linux and macOS; apt only bootstraps it. Ubuntu 22.04's apt zoxide 0.4.3 recurses on `cd`. Windows: `winget.json` for GUI apps, `scoop.json` for Git and Nerd Fonts.
- `~/.config/zsh/local.zsh` is untracked and may hold secrets; never read, expose or commit it.

## Decisions

- Keep source files free of explanatory comments; put rationale here.
- Zsh load order is load-bearing: plugins needed before `compinit` and ZLE load synchronously; syntax-highlighting and fzf-tab come last.
- The Codex wrapper forces `--no-daemon` for the TUI because the shared daemon gives herdr's SessionStart hook the wrong `HERDR_PANE_ID`.
- The macOS Dock is configured by a `run_once` script because it gets hand-tuned afterwards.
- `compinit -C` skips the `fpath` security check (issue #12). The first zsh startup in `bin/check.sh` is discarded while zinit clones plugins (issue #11).
