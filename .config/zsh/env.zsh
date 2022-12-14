# go env
export GOPROXY=https://proxy.golang.com.cn,direct
export GOROOT=/usr/local/go
export GOPATH=$HOME/code/go
export PATH=$GOROOT:$GOROOT/bin:$PATH
# QT program scale
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_IM_MODULE=fcitx5

export EDITOR='vim'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=23'
export LANG=en_US.UTF-8

conda_bin=$HOME/miniconda3/bin/conda
__conda_setup="$(${conda_bin} 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi

unset __conda_setup
os=$(uname)
if [ "$os"=="Darwin" ]; then
    export https_proxy=http://127.0.0.1:7890
    export http_proxy=http://127.0.0.1:7890
    export all_proxy=socks5://127.0.0.1:7890
    export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
fi
