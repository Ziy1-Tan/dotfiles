# Sourced by zprofile (login shells) and env.zsh (non-login interactive shells,
# e.g. tmux panes and editor terminals on Linux), so it must be idempotent.
[[ -n "$HOMEBREW_PREFIX" ]] && return
for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_bin" ]]; then
        eval "$("$brew_bin" shellenv)"
        break
    fi
done
unset brew_bin
