# AGENTS.md

- Use `~/github/dotfiles` as the chezmoi source directory; no `~/dotfiles` alias.
- Repo-only files go in `.chezmoiignore`. `local.zsh` is copied once, never overwritten.
- `brew` is the only CLI package manager on Linux and macOS; apt only bootstraps it. Ubuntu 22.04's apt zoxide 0.4.3 recurses on `cd`. Windows: `winget.json` for GUI apps, `scoop.json` for Git and Nerd Fonts.
- `~/.config/zsh/local.zsh` is untracked and may hold secrets; never read, expose or commit it.

## Decisions

- Keep source files free of explanatory comments; put rationale here.
- Zsh load order is load-bearing: plugins needed before `compinit` and ZLE load synchronously; syntax-highlighting and fzf-tab come last.
- The Codex wrapper forces `--no-daemon` for the TUI because the shared daemon gives herdr's SessionStart hook the wrong `HERDR_PANE_ID`.
- The macOS Dock is configured by a `run_once` script because it gets hand-tuned afterwards.
- `compinit -C` skips the `fpath` security check (issue #12). The first zsh startup in `bin/check.sh` is discarded while zinit clones plugins (issue #11).
- `~/.zshenv` is chezmoi-managed so it runs before Ubuntu's `/etc/zsh/zshrc`, whose `compinit` runs on every startup; `skip_global_compinit` leaves the cached `compinit -C` in `.zshrc` as the only one.
- WSL PATH is rebuilt in `.zshenv` from an allowlist (VS Code, scoop shims) after dropping `/mnt/c/*`. Each zsh startup enumerates every PATH directory, and `/mnt/c/WINDOWS/system32` alone cost ~1.3s; startup measured ~1.8s before and ~0.14s after. `/etc/wsl.conf` also sets `appendWindowsPath = false`. Add a directory to the allowlist when a Windows tool is needed.
- Startup avoids forking where a zsh parameter works: `$HOMEBREW_PREFIX` replaces `brew --prefix`, `$OSTYPE` replaces `uname`, `${commands[java]:A:h:h}` replaces `readlink -f | sed`, and the `ls --color` probe is gone. `typeset -gU path` keeps PATH duplicate-free.
- The OMZ git plugin and library are not loaded: the ~150 aliases went unused (one `grv` in history) and the plugin forked `git version` on every startup.
- Go comes from brew. `GOROOT` and `GOPATH` are not exported: both are derived, `GOPATH` defaults to `$HOME/go`, and a shell `GOPATH` would override `go env -w`. `$HOME/go/bin` is on PATH for `go install` binaries. `GOPROXY` lives in `env.zsh`; don't also set it with `go env -w`.
- rustup is installed by `run_onchange_after_install-runtimes.sh` with the minimal profile. `$HOME/.cargo/env` is sourced conditionally in `.zshenv` because CI images have no Rust.
- Windows config lives in `windows/` and is applied by a nested chezmoi config in file mode; the main repo stays in symlink mode because Windows programs cannot follow symlinks into WSL. The nested source directory is repo-only and ignored by the outer chezmoi. Nested source files use the `executable_` attribute and `umask = 0` because WSL drvfs reports mode 777 for Windows files, which would otherwise make `chezmoi verify` fail on permission diffs. Nushell 0.117 ignores `NU_CONFIG_DIR` on Windows, so a `run_once` script sets user-level `XDG_CONFIG_HOME=C:\Users\admin\.config`; new shells then read `C:\Users\admin\.config\nushell`.
- `winget.json` owns Windows GUI and developer tools. PowerShell and Everything were removed; CLI tools that also exist in brew are declared for parity. The three msstore IDs are Snipaste, Apple Music and Raycast. Nushell's generated fzf autoload file stays unmanaged.
- Magpie comes from the `magpie` scoop bucket (`yetone/magpie-releases`); the desktop app is `magpie-app`. Its winget manifest is not in the official source yet.
