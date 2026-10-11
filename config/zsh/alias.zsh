alias cl="clear"
alias sz="source ~/.zshrc"

# GNU ls vs BSD ls (-G) colour flags
if ls --color=auto >/dev/null 2>&1; then
    alias ll="ls -lh --color=auto"
else
    alias ll="ls -lhG"
fi

# ── Proxy ────────────────────────────────────────────────────────────────────
# PROXY_HOST / PROXY_PORT can be overridden in local.zsh (default 127.0.0.1:7890).
setproxy() {
    local host="${PROXY_HOST:-127.0.0.1}" port="${PROXY_PORT:-7890}"
    export https_proxy="http://$host:$port"
    export http_proxy="http://$host:$port"
    export all_proxy="socks5://$host:$port"
    echo "proxy on: $https_proxy"
}
unsetproxy() {
    unset http_proxy https_proxy all_proxy
    echo "proxy off"
}

# ── tmux ─────────────────────────────────────────────────────────────────────
alias t="tmux"
alias ta="tmux a -d -t 0"
alias td="tmux detach"
