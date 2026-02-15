# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository managed by [dotbot](https://github.com/anishathalye/dotbot). It contains configuration files for a Linux/macOS development environment.

## Installation

```bash
git clone https://github.com/Ziy1-Tan/dotfiles.git
cd dotfiles
git submodule update --init --recursive
./install
```

The `install` script runs dotbot which:
1. Caches sudo credentials (one-time password prompt)
2. Cleans old symlinks
3. Creates required directories (~/.m2, ~/.ssh, ~/.zsh, ~/.vim/plugged, ~/.config)
4. Symlinks config files to home directory
5. Bootstraps system: zsh, curl, brew, chsh, miniconda
6. Installs tools: zoxide, fzf, vim-plug, zinit

## Architecture

- `install` - Bootstrap script: caches sudo, then runs dotbot
- `install.conf.yaml` - Dotbot configuration defining link/create/shell tasks
- `zshrc` - Main zsh configuration, sources files from `~/.config/zsh/`
- `config/zsh/` - Modular zsh configs (alias.zsh, env.zsh, fzf.zsh, prompt.zsh)
- `dotbot/` - Git submodule for dotbot installer tool

## Key Configurations

| File | Purpose |
|------|---------|
| `zshrc` | Zsh shell config with zinit plugin manager |
| `vimrc` | Vim editor config |
| `tmux.conf` | Tmux terminal multiplexer |
| `gitconfig` | Git configuration with aliases |
| `.ssh/config` | SSH client configuration |
| `config/alacritty/alacritty.toml` | Alacritty terminal config |

## Plugin Managers

- **zinit** - Zsh plugin manager (loaded in zshrc)
- **vim-plug** - Vim plugin manager (installed during dotbot setup)

## Environment Tools

- **conda** - Python environment manager (miniconda3)
- **nvm** - Node.js version manager
- **bun** - JavaScript runtime
- **zoxide** - Smarter cd command
- **fzf** - Fuzzy finder

## Key Aliases

```bash
s       # neofetch
ll      # ls -lh --color=auto
sz      # source ~/.zshrc
cmb     # cmake --build build -j 12
setproxy/unsetproxy  # proxy management
t/ta/td # tmux commands
```

## Development Notes

- **No hardcoded paths** — use `$HOME` not `/home/username` in zshrc/env.zsh
- **Dotbot shell commands have no TTY** — `sudo -v` must run in `install` script before dotbot; sudo commands inside yaml rely on cached credentials
- **chsh path mismatch** — compare `basename "$SHELL"` not full path (`/bin/zsh` vs `/usr/bin/zsh`)
- **Shell change** — Linux uses `sudo usermod -s`, macOS uses `sudo chsh -s` (no usermod on macOS)
- **Optional tool sources need existence checks** — e.g. `[ -f "$HOME/.cargo/env" ] && source ...`
- Proxy settings in `config/zsh/env.zsh` are for WSL2 (port 7890)
- Java/Maven paths auto-detected for Linux/macOS
- CUDA 11.8 paths configured for Linux
- Git config includes custom aliases: `cm`, `co`, `ac`, `lo`, `sh`, `shp`
