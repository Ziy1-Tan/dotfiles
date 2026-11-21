source "$HOME/.config/zsh/brew.zsh"

export LANG=en_US.UTF-8
export EDITOR=vim

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
path=("$HOME/go/bin" "${path[@]}")

[[ $OSTYPE == darwin* ]] && export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
