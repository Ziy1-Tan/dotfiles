alias u="sudo apt update && sudo apt upgrade"
alias s="neofetch"
alias cl="clear"
alias sz="source ~/.zshrc"

# tmux
alias t="tmux"
alias ta="tmux a -t 0"
alias td="tmux detach"

os=`uname`
if [ "$os" = "Darwin" ]; then
    alias u="brew upgrade"
fi
