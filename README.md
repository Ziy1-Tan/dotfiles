# dotfiles

Managed by [Nix](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager).

The Nix configuration is the installation and activation entrypoint.

## Features

- **Cross-platform**: Ubuntu / macOS
- **Base tools**: zsh, curl, Alacritty, fzf, fd, zoxide, Bun via Nix
- **Shell**: zsh with layered startup files and zinit plugins
- **Plugin managers**: zinit for zsh, vim-plug for Vim
- **Languages**: Python (uv), Node.js (nvm), Go, Rust
- **Editors**: Vim, Alacritty, Tmux

## Directory Structure

```text
dotfiles/
├── flake.nix               # Nix and Home Manager entrypoint
├── home.nix                # User packages and file mappings
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
| `zprofile` | Login shell setup; the Nix profile supplies PATH |
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

### Nix (current path)

On a supported macOS or Linux machine, run the bootstrap script from the
repository root:

```bash
./bootstrap.sh
```

The script installs Nix with the official multi-user installer when needed,
adds USTC/TUNA store mirrors before the official cache as fallbacks, and then
activates Home Manager. Every run applies the current configuration, so rerun it
after changing managed files. An existing Nix installation is kept, and the
existing `/etc/nix/nix.conf` is not replaced. Updating the system Nix
configuration requires `sudo`.

The `--impure` flag on `nix run` is intentional: the Flake reads the current
`USER`, `HOME` and host system, so the same repository works for different
single-user machines without embedding a username or home path. `flake.lock`
pins the nixpkgs and Home Manager revisions shared across machines. To inspect
the configuration without activating it, run these checks when Nix is
available:

```bash
nix flake check --impure --no-update-lock-file
nix build --impure --no-update-lock-file --no-link \
  .#homeConfigurations.default.activationPackage
```

The repository also runs these checks in GitHub Actions on every push and pull
request.

Nix selects the current host system automatically. No username or architecture
edit is required when moving between the office Mac, a personal Mac, or Linux.
The app uses the pinned Home Manager package where available and falls back to
the pinned nixpkgs package on systems where Home Manager does not publish a
standalone binary.

Nix owns the base tools and configuration files. zinit still owns zsh plugins,
vim-plug still owns Vim plugins, nvm still owns Node.js versions when installed
on the host, and Bun still owns project dependencies. No two managers should
install the same resource.

Binary caches do not replace Flake source downloads. If GitHub is unavailable,
replace the two `inputs.*.url` values in `flake.nix` with trusted Git mirrors
that contain the exact locked commits, then run `nix flake lock` and commit the
updated lock file. Do not use a moving channel URL as a source mirror.

## Zsh Layout

- `zprofile` is for login-shell setup.
- `zshrc` handles interactive startup in one place, including zinit, compinit, nvm, zoxide, fzf, uv completions, prompt, aliases, and the local override. Bun is supplied by the Nix profile; projects continue to use their own `package.json` and lockfile.
- Copy `config/zsh/local.zsh.example` to `~/.config/zsh/local.zsh` for machine-specific settings you do not want committed.
