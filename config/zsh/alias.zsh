alias cl="clear"
alias sz="source ~/.zshrc"

if ls --color=auto >/dev/null 2>&1; then
    alias ll="ls -lh --color=auto"
else
    alias ll="ls -lhG"
fi

# ── 代理管理 ───────────────────────────────────────────
# PROXY_HOST / PROXY_PORT 可在 local.zsh 覆盖（默认 127.0.0.1:7890）
setproxy() {
    export https_proxy="http://${PROXY_HOST:-127.0.0.1}:${PROXY_PORT:-7890}"
    export http_proxy="http://${PROXY_HOST:-127.0.0.1}:${PROXY_PORT:-7890}"
    export all_proxy="socks5://${PROXY_HOST:-127.0.0.1}:${PROXY_PORT:-7890}"
    echo "proxy on: ${https_proxy}"
}
unsetproxy() {
    unset http_proxy https_proxy all_proxy
    echo "proxy off"
}

# ── tmux ───────────────────────────────────────────────
alias t="tmux"
alias ta="tmux a -d -t 0"
alias td="tmux detach"
