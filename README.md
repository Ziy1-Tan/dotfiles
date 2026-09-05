# dotfiles

Ubuntu / MacOS 

Powered by [dotbot](https://github.com/anishathalye/dotbot)

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
