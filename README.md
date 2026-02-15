# dotfiles

Powered by [dotbot](https://github.com/anishathalye/dotbot)

## Features

- **Cross-platform**: Ubuntu / macOS
- **Auto-bootstrap**: zsh, curl, Homebrew, Miniconda
- **Shell**: zsh + zinit (plugin manager)
- **Tools**: fzf, zoxide, vim-plug, zinit
- **Languages**: Conda (Python), nvm (Node.js), Go, Rust
- **Editors**: Vim, Alacritty, Tmux, IDEA Vim

## Directory Structure

```
dotfiles/
├── install              # Bootstrap script
├── install.conf.yaml    # Dotbot configuration
├── zshrc               # Main zsh config
├── zprofile            # Zsh login config
├── vimrc               # Vim config
├── tmux.conf           # Tmux config
├── gitconfig           # Git config
├── ideavimrc           # IDEA Vim plugin config
├── settings.xml        # Maven settings
├── config/
│   ├── alacritty/
│   │   └── alacritty.toml
│   └── zsh/
│       ├── alias.zsh   # Aliases
│       ├── env.zsh     # Environment variables
│       ├── fzf.zsh     # FZF keybindings
│       └── prompt.zsh  # Prompt theme
└── .ssh/
    └── config          # SSH client config
```

## Configuration Files

| File | Purpose |
|------|---------|
| `zshrc` | Main zsh config, loads zinit plugins |
| `zprofile` | Login shell configuration |
| `vimrc` | Vim editor config |
| `tmux.conf` | Tmux terminal multiplexer |
| `gitconfig` | Git aliases and settings |
| `.ssh/config` | SSH client configuration |
| `ideavimrc` | IDEA Vim plugin keymappings |
| `settings.xml` | Maven repository settings |
| `config/zsh/alias.zsh` | Shell aliases |
| `config/zsh/env.zsh` | Environment variables (PATH, Java, Go, Conda) |
| `config/zsh/fzf.zsh` | FZF keybindings and completion |
| `config/zsh/prompt.zsh` | Powerlevel10k prompt theme |
| `config/alacritty/alacritty.toml` | Alacritty terminal config |

## Quick Start

```bash
git clone https://github.com/Ziy1-Tan/dotfiles.git
cd dotfiles
git submodule update --init --recursive
./install
```

## What ./install Does

1. **Cache sudo** — One-time password for system changes
2. **Bootstrap** — Install zsh, curl, Homebrew
3. **Setup shell** — Switch default shell to zsh
4. **Install Conda** — Miniconda with zsh auto-init
5. **Link configs** — Symlink all config files to home
6. **Install tools** — zoxide, fzf, vim-plug, zinit
