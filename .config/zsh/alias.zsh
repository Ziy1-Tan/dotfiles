alias u="sudo apt update && sudo apt upgrade"
alias s="neofetch"
alias cl="clear"
alias sz="source ~/.zshrc"
alias lg="lazygit"
alias cmb="cmake --build build -j 12"
alias setproxy="export http_proxy https_proxy all_proxy"
alias unsetproxy="unset http_proxy https_proxy all_proxy"

# tmux
alias t="tmux"
alias ta="tmux a -t 0"
alias td="tmux detach"

if [ "$(uname -s)" = "Darwin" ]; then
    alias u="brew update && brew upgrade"
fi

if command -v batcat >/dev/null 2>&1; then
    alias cat="batcat --number"
fi

if command -v bat >/dev/null 2>&1; then
    alias cat="bat --number"
fi
