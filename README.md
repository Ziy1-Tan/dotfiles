# dotfiles

Ubuntu / macOS, managed by [chezmoi](https://www.chezmoi.io).

## Quick start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
~/.local/bin/chezmoi -S ~/github/dotfiles init --apply Ziy1-Tan/dotfiles
```

## Contents

- zsh: env, aliases, fzf integration, prompt
- tmux, vim, git
- Alacritty, Ghostty, [herdr](https://herdr.dev/)
- `Brewfile` for Linux and macOS; `apt-packages.txt` bootstraps brew
- `winget.json` and `scoop.json`, imported from WSL
- Install scripts: packages, default shell, runtimes (uv, nvm), macOS defaults, Dock
- `bin/check.sh` post-install assertions

## Machine-local config

- `~/.config/zsh/local.zsh` comes from `dot_config/zsh/create_local.zsh`, is created once and stays untracked.
- Put proxy settings, tokens and installer PATH lines there.
