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

alias ce='claude'
alias ced='claude --dangerously-skip-permissions'
alias cedc='claude --dangerously-skip-permissions --continue'
alias cedr='claude --dangerously-skip-permissions --resume'
alias cx='codex'
alias che='chezmoi'
alias cb='codebuddy'

alias cop='copypath'
alias rep='copypath'

# Run the interactive Codex TUI without the shared app-server daemon. The daemon
# runs hooks with the environment of the pane that started it, so herdr's
# SessionStart hook reports the wrong HERDR_PANE_ID for every other pane.
# --no-daemon is accepted only by the TUI (bare, with a prompt, resume, fork),
# so known non-TUI subcommands and explicit --no-daemon pass through as-is.
codex() {
  if (( ${@[(Ie)--no-daemon]} )); then
    command codex "$@"
    return
  fi
  case "${1-}" in
    agents|exec|e|review|login|logout|mcp|plugin|app-server|remote-control|app|completion|update|doctor|sandbox|debug|apply|queue|archive|delete|migrate-rollouts|migrate-nfs-db|unarchive|cloud|exec-server|features|help)
      command codex "$@" ;;
    *) command codex --no-daemon "$@" ;;
  esac
}
