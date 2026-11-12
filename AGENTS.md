# AGENTS.md

- `~/.config/zsh/local.zsh` is untracked machine-local configuration and may contain secrets. Do not read or expose its contents, and never add it to the repo.
- Tool installers append lines to `~/.zshrc`, which is a symlink into this repo. Revert such edits and put them in `local.zsh`.
- To test a bootstrap in Docker (colima), the clone must live under `$HOME`; colima mounts nothing else.
