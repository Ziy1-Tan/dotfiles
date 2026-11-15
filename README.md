# dotfiles

Ubuntu / macOS, managed by [chezmoi](https://www.chezmoi.io).

## Quick start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
~/.local/bin/chezmoi -S ~/github/dotfiles init --apply Ziy1-Tan/dotfiles
```


## Contents

Managed with [chezmoi](https://www.chezmoi.io/).

- zsh config: env, aliases, fzf integration and prompt
- tmux, vim and git config
- Alacritty, Ghostty and [herdr](https://herdr.dev/) config
- Package lists: `Brewfile` for Linux and macOS, `apt-packages.txt` for the brew bootstrap
- Windows packages: `winget.json` and `scoop.json`, imported from WSL
- Install scripts: packages, default shell, runtimes (uv and nvm), macOS defaults and Dock layout
- `bin/check.sh` post-install assertions

## Machine-local config

`~/.config/zsh/local.zsh` is created from a template on first apply and never overwritten. Put
proxy settings, tokens and tool-installer PATH lines there; it is not tracked.
