# dotfiles

Ubuntu / macOS, managed by [chezmoi](https://www.chezmoi.io).

## Quick start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
~/.local/bin/chezmoi -S ~/github/dotfiles init --apply Ziy1-Tan/dotfiles
```

The source directory is `~/github/dotfiles`, **not** chezmoi's default `~/.local/share/chezmoi`;
always pass `-S ~/github/dotfiles` on `init`. The generated config records it (`sourceDir`), so
later commands need no flag.

On macOS `init` asks one question, `gui` (casks, fonts, Dock layout; default yes). Linux never asks. To answer without a prompt: `chezmoi init --promptBool gui=false --apply Ziy1-Tan/dotfiles`.

Files are symlinked into the clone (`~/github/dotfiles`), so editing `~/.zshrc` edits git
directly. Day to day:

| Command | Effect |
|---------|--------|
| `chezmoi diff` | Preview what `apply` would change |
| `chezmoi apply` | Reconcile `~` with the repo; re-runs only scripts whose content changed |
| `chezmoi edit ~/.zshrc` | Edit a managed file through its source path |
| `chezmoi cd` | Open a shell in the repo |

## Layout

`.chezmoiroot` points chezmoi at `home/`; names there map to `~` (`dot_` → `.`).

```text
home/
├── .chezmoi.toml.tmpl      # the `gui` prompt, symlink mode
├── .chezmoidata/
│   ├── packages.yaml       # brew / apt / cask lists
│   └── dock.yaml           # Dock order
├── .chezmoiscripts/        # run in filename order
│   ├── 10-packages         # Homebrew or apt; casks and fonts only if gui
│   ├── 20-default-shell    # chsh to zsh
│   ├── 30-runtimes         # uv, nvm + LTS node, vim-plug
│   ├── 40-macos-defaults   # defaults write, pmset
│   └── 50-dock             # dockutil layout (macOS, gui only)
├── dot_zshrc  dot_zprofile  dot_vimrc  dot_tmux.conf  dot_gitconfig
└── dot_config/
    ├── alacritty/
    ├── ghostty/
    ├── herdr/              # config.toml only; logs, sockets and sessions stay local
    └── zsh/                # env, alias, fzf, prompt; local.zsh is created once
test/check.sh               # post-install assertions
```

## Machine-local config

`~/.config/zsh/local.zsh` is created from a template on first apply and never overwritten. Put
proxy settings, tokens and tool-installer PATH lines there; it is not tracked.
