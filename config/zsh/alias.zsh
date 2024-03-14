alias s="neofetch"
alias cl="clear"
alias sz="source ~/.zshrc"
alias cmb="cmake --build build -j 12"
alias setproxy="export http_proxy https_proxy all_proxy"
alias unsetproxy="unset http_proxy https_proxy all_proxy"

# tmux
alias t="tmux"
alias ta="tmux a -d -t 0"
alias td="tmux detach"

alias u="sudo apt update && sudo apt upgrade"
if [ $(uname) = "Darwin" ]; then
    alias u="brew update && brew upgrade"
fi

alias bc="brew cleanup --prune=all; brew autoremove"

