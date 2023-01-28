# kernel
os=`uname`
if [ "$os" = "Darwin" ]; then
    host_ip="127.0.0.1"
    export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
fi

host_ip=$(cat /etc/resolv.conf | grep "nameserver" | cut -f 2 -d " ")
export https_proxy=http://${host_ip}:7890
export http_proxy=http://${host_ip}:7890
export all_proxy=socks5://${host_ip}:7890

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

export PATH=/usr/local/cuda-11.8/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export GIT=git@github.com:Ziy1-Tan

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

