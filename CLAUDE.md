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
3. Creates required directories (`~/.m2`, `~/.ssh`, `~/.zsh`, `~/.vim/plugged`, `~/.config`)
4. Symlinks config files to the home directory
5. Bootstraps system: zsh, curl, brew, chsh, miniconda
6. Installs tools: zoxide, fzf, vim-plug, zinit

## Architecture

- `install`: bootstrap script, caches sudo, then runs dotbot
- `install.conf.yaml`: Dotbot configuration defining link, create, and shell tasks
- `zprofile`: login-shell setup
- `zshrc`: interactive shell entrypoint, includes zinit, compinit, tool init, and sources files from `~/.config/zsh/`
- `config/zsh/`: shared zsh modules plus optional local override template
- `dotbot/`: git submodule for the dotbot installer tool

## Key Configurations

| File | Purpose |
|------|---------|
| `zprofile` | Login-shell setup, mainly Homebrew shellenv |
| `zshrc` | Interactive shell config that assembles zsh modules |
| `vimrc` | Vim editor config |
| `tmux.conf` | Tmux terminal multiplexer |
| `gitconfig` | Git configuration with aliases |
| `.ssh/config` | SSH client configuration |
| `config/alacritty/alacritty.toml` | Alacritty terminal config |

## Plugin Managers

- **zinit**: Zsh plugin manager
- **vim-plug**: Vim plugin manager, installed during dotbot setup

## Environment Tools

- **conda**: Python environment manager (miniconda3)
- **nvm**: Node.js version manager
- **bun**: JavaScript runtime
- **zoxide**: Smarter `cd` command
- **fzf**: Fuzzy finder

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

- **No hardcoded paths**: use `$HOME`, not `/home/username`
- **Keep startup boundaries clean**: `zprofile` for login, `zshrc` for interactive composition
- **Machine-specific settings belong in local override**: use `~/.config/zsh/local.zsh`, not shared versioned modules
- **Dotbot shell commands have no TTY**: `sudo -v` must run in `install` before dotbot, shell commands inside yaml rely on cached credentials
- **chsh path mismatch**: compare `basename "$SHELL"` not the full path
- **Shell change**: Linux uses `sudo usermod -s`, macOS uses `sudo chsh -s`
- **Optional tool sources need existence checks**: for example `[ -f "$HOME/.cargo/env" ] && source ...`
- Java, Maven, and CUDA paths are auto-detected for Linux/macOS
