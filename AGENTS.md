# AGENTS.md

- The chezmoi source directory is `~/github/dotfiles` (not the default `~/.local/share/chezmoi`). Clone/init with `chezmoi -S ~/github/dotfiles init --apply Ziy1-Tan/dotfiles`. Do not create a `~/dotfiles` alias; operate in `~/github/dotfiles` directly.
- The repo root is the chezmoi source directory; `dot_` names map to `~`. Repo-only files must be listed in `.chezmoiignore`, or `chezmoi apply` will copy them into `~`.
- `brew` is the only CLI package manager on Linux and macOS; on Linux apt exists only to bootstrap brew. Never install CLI tools via apt. On Windows, `winget.json` covers GUI apps and `scoop.json` covers Git and Nerd Fonts; both are imported from WSL.
- `~/.config/zsh/local.zsh` is untracked machine-local configuration and may contain secrets. Do not read or expose its contents, and never add it to the repo.
- Tool installers append lines to `~/.zshrc`, which is a symlink into this repo. Revert such edits and put them in `local.zsh`.
- To test a bootstrap in Docker (colima), the clone must live under `$HOME`; colima mounts nothing else.
