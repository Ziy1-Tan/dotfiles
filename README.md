# dotfiles

Powered by [dotbot](https://github.com/anishathalye/dotbot)

## Features

- **Cross-platform**: Ubuntu / macOS
- **Auto-bootstrap**: zsh, curl, Homebrew
- **Shell**: zsh with layered startup files and zinit plugins
- **Tools**: fzf, zoxide, fd, vim-plug, zinit
- **Languages**: Python (uv), Node.js (nvm), Go, Rust
- **Editors**: Vim, Alacritty, Tmux

## Directory Structure

```text
dotfiles/
├── install                 # Bootstrap script
├── install.conf.yaml       # Dotbot configuration
├── zprofile                # Login-shell setup
├── zshrc                   # Interactive shell orchestrator
├── vimrc                   # Vim config
├── tmux.conf               # Tmux config
├── gitconfig               # Git config
├── config/
│   ├── alacritty/
│   │   └── alacritty.toml
│   └── zsh/
│       ├── alias.zsh           # Aliases only
│       ├── env.zsh             # Shared environment exports
│       ├── fzf.zsh             # FZF defaults and helpers
│       ├── local.zsh.example   # Machine-specific override template
│       └── prompt.zsh          # Prompt theme
└── .ssh/
    └── config              # SSH client config
```

## Configuration Files

| File | Purpose |
|------|---------|
| `zprofile` | Login shell setup, mainly Homebrew shellenv |
| `zshrc` | Interactive shell entrypoint that sources modular config |
| `vimrc` | Vim editor config |
| `tmux.conf` | Tmux terminal multiplexer |
| `gitconfig` | Git aliases and settings |
| `.ssh/config` | SSH client configuration |
| `config/zsh/env.zsh` | Shared environment variables and PATH setup |
| `config/zsh/fzf.zsh` | FZF defaults and completion helpers |
| `config/zsh/prompt.zsh` | Prompt theme |
| `config/zsh/alias.zsh` | Shell aliases |
| `config/zsh/local.zsh.example` | Template for machine-specific overrides |
| `config/alacritty/alacritty.toml` | Alacritty terminal config |

## Quick Start

```bash
git clone https://github.com/Ziy1-Tan/dotfiles.git
cd dotfiles
git submodule update --init --recursive
./install
```

## What ./install Does

1. **Cache sudo**: One-time password for system changes
2. **Bootstrap**: Install zsh, curl, Homebrew
3. **Setup shell**: Switch default shell to zsh
4. **Link configs**: Symlink startup files and `~/.config/*` modules
5. **Install tools**: zoxide, fzf, fd, vim-plug, zinit

## Zsh Layout

- `zprofile` is for login-shell setup.
- `zshrc` handles interactive startup in one place, including zinit, compinit, nvm, bun, zoxide, fzf, uv completions, prompt, aliases, and the local override.
- Copy `config/zsh/local.zsh.example` to `~/.config/zsh/local.zsh` for machine-specific settings you do not want committed.
