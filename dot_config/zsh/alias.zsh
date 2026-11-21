alias cl="clear"
alias sz="source ~/.zshrc"

if ls --color=auto >/dev/null 2>&1; then
    alias ll="ls -lh --color=auto"
else
    alias ll="ls -lhG"
fi

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
