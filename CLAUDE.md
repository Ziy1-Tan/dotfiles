# CLAUDE.md

## What this is

A [dotbot](https://github.com/anishathalye/dotbot)-managed dotfiles repo (zsh / vim /
tmux / git / terminal). `./install` bootstraps and symlinks everything; the intent is
to run unmodified on Ubuntu and macOS.

## Conventions

- **No hardcoded paths**: use `$HOME`, never `/home/<user>`.
- **Startup boundaries**: `zprofile` = login shell (brew shellenv); `zshrc` =
  interactive composition. Don't move logic across the boundary.
- **Machine-specific settings** go in `~/.config/zsh/local.zsh` (copy of
  `local.zsh.example`), never in versioned modules. It can override
  `PROXY_HOST` / `PROXY_PORT`, consumed by the `setproxy` function in `alias.zsh`.
- **Optional tool sources need existence checks**: `[ -f ... ] && source ...` or
  `command -v`.
- **GNU/BSD pairs that must stay handled** (Ubuntu vs macOS): `ls --color=auto`
  vs `ls -lhG`; `stat -c %Y` vs `stat -f %m`; `readlink -f` (Linux) vs
  `/usr/libexec/java_home` (macOS); `nproc` vs `sysctl -n hw.ncpu`.
- **fd install differs per OS** (see the install step in `install.conf.yaml`): Linux uses
  apt `fd-find` + a `fdfind → fd` symlink into `~/.local/bin` (which is on PATH); macOS uses
  brew. `command -v fd` in `fzf.zsh` needs the binary to literally be named `fd`.

## zshrc ordering (fragile, keep in this order)

- The uv/uvx completion block must stay **before** `autoload -Uz compinit`: it drops
  `#compdef` files into `~/.cache/zsh/completions` and prepends that dir to `fpath`.
  It deletes `~/.zcompdump` only when uv is updated, forcing a reindex.
- `zsh-syntax-highlighting` must load **last** (it wraps every registered ZLE widget);
  `fzf-tab` after it; `zsh-history-substring-search` before it.
- `zsh-history-substring-search` must load **synchronously** (its widgets don't register
  under zinit turbo `wait="0"`) and needs explicit `bindkey` lines — the plugin only
  defines widgets, it doesn't bind keys.
- `zshrc` ends with `:` so sourcing it returns 0 (`zsh -i -c exit` must not return 1).
- fzf keybindings/completions are cached to `~/.cache/zsh/fzf-integration.zsh`
  (regenerated when the fzf binary is newer) to avoid a per-startup subprocess.

## Bootstrap gotchas

- dotbot shell commands have no TTY: yaml shell steps rely on cached sudo credentials.
  `install` only prompts for sudo when `needs_sudo()` finds a root-requiring step
  (apt / usermod / chsh / brew installer); re-runs on a configured machine are
  passwordless, and any existing sudo cache is reused.
- Shell-change check compares `basename "$SHELL"`, not the full path.
- Linux uses `sudo usermod -s`, macOS uses `sudo chsh -s`.
