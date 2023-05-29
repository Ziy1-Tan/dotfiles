# proxy
host_ip="127.0.0.1"
if [ "$(uname -s)" = "Linux" ] && $(grep -qi "Microsoft" /proc/version); then
    host_ip=$(cat /etc/resolv.conf | grep "nameserver" | cut -f 2 -d " ")
fi

export https_proxy=http://${host_ip}:7890
export http_proxy=http://${host_ip}:7890
export all_proxy=socks5://${host_ip}:7890

# go env
export GOPROXY=https://proxy.golang.com.cn,direct
export GOROOT=/usr/local/go
export GOPATH=$HOME/code/go
export PATH=$GOROOT:$GOROOT/bin:$PATH

export EDITOR='vim'
export LANG=en_US.UTF-8

if [ "$(uname -s)" = "Darwin" ]; then
    export PATH=/opt/homebrew/opt/openjdk@11/bin:$PATH
    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
    export PATH=/opt/homebrew/bin:$PATH
    export PATH=$HOME/Library/Python/3.9/bin:$PATH
    export JAVA_HOME=$(/usr/libexec/java_home)
    export PATH=$JAVA_HOME/bin:$PATH
fi

if [ "$(uname -s)" = "Linux" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
    export M2_HOME=/usr/share/maven
    export MAVEN_HOME=/usr/share/maven
    export PATH=${M2_HOME}/bin:${PATH}
fi

export PATH=/usr/local/cuda-11.8/bin${PATH:+:${PATH}}
export PATH=$HOME/.local/bin:$PATH
export GAR_TEST_DATA=$HOME/code/cpp/GraphAr/testing/

conda_bin=$HOME/miniconda3/bin/conda
__conda_setup="$(${conda_bin} 'shell.zsh' 'hook' 2>/dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/miniconda3/etc/profile.d/conda.sh"
else
    export PATH="$HOME/miniconda3/bin:$PATH"
fi
# fi

unset __conda_setup
