#!/bin/bash
# Assert that a machine bootstrapped with chezmoi ended up in the expected state.
# Usage: test/check.sh <repo-dir>
set -euo pipefail
repo="$(cd "$1" && pwd -P)"   # -P: any path into the repo (incl. symlinks) must resolve
fail() { echo "FAIL: $*" >&2; exit 1; }

export PATH="$HOME/.local/bin:$HOME/.fzf/bin:$PATH"
for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew_bin" ]; then eval "$("$brew_bin" shellenv)"; break; fi
done

echo "--- tools on PATH"
for cmd in chezmoi zsh curl fzf fd rg zoxide tmux tldr uv; do
  command -v "$cmd" >/dev/null || fail "$cmd not installed"
done
fzf --zsh >/dev/null || fail "fzf too old for 'fzf --zsh'"
[ -s "$HOME/.nvm/nvm.sh" ] && [ -f "$HOME/.nvm/alias/default" ] || fail "nvm or its default node missing"

echo "--- managed files are symlinks into the repo"
for f in .zshrc .zprofile .vimrc .tmux.conf .gitconfig .config/zsh/env.zsh .config/zsh/alias.zsh; do
  target="$(readlink "$HOME/$f" || true)"
  [ -n "$target" ] || fail "~/$f is not a symlink"
  case "$target" in "$repo"/home/*) ;; *) fail "~/$f -> $target (outside $repo)" ;; esac
done
[ -f "$HOME/.config/zsh/local.zsh" ] && [ ! -L "$HOME/.config/zsh/local.zsh" ] \
  || fail "local.zsh should be a regular file"

echo "--- target state matches source"
chezmoi verify || fail "chezmoi verify reported drift"

echo "--- second apply runs no scripts"
out="$(chezmoi apply --verbose 2>&1)"
if printf '%s' "$out" | grep -qE 'packages|default-shell|runtimes|macos-defaults|dock'; then
  printf '%s\n' "$out"
  fail "scripts re-ran on an unchanged source"
fi

echo "--- interactive zsh starts cleanly"
export TERM="${TERM:-xterm-256color}" # CI has no TERM; zinit's installer calls tput
zsh -i -c exit </dev/null >/dev/null 2>&1 || true # first start lets zinit clone its plugins
err="$(zsh -i -c exit </dev/null 2>&1 >/dev/null)" || fail "zsh -i exited non-zero"
[ -z "$err" ] || { printf '%s\n' "$err"; fail "zsh -i wrote to stderr"; }
[ -d "$HOME/.local/share/zinit/zinit.git" ] || fail "zinit not installed"

if [ "$(uname)" = Darwin ]; then
  echo "--- macOS defaults"
  [ "$(defaults read NSGlobalDomain KeyRepeat)" = 2 ] || fail "KeyRepeat != 2"
  [ "$(defaults read com.apple.dock orientation)" = bottom ] || fail "Dock orientation != bottom"
fi
echo "OK"
