alias u="sudo apt update && sudo apt upgrade"
alias s="neofetch"
alias cl="clear"
alias sz="source ~/.zshrc"
alias lg="lazygit"

# tmux
alias t="tmux"
alias ta="tmux a -t 0"
alias td="tmux detach"

if [ "$(uname -s)" = "Darwin" ]; then
    alias u="brew update && brew upgrade"
fi

if command -v exa >/dev/null 2>&1; then
    alias ll="exa -l -g"
    alias la="exa -l -a -g"
fi
