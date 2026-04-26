export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR="vim"

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
if [ -x "$HOME/.local/lib/go/bin/go" ]; then
  export GOROOT="$HOME/.local/lib/go"
elif [ -d /usr/lib/go-1.18 ]; then
  export GOROOT=/usr/lib/go-1.18
else
  export GOROOT=/usr/local/go
fi
export GOPATH=$HOME/code/go
export PATH=$GOROOT/bin:$PATH

export PATH=$HOME/.local/bin:$PATH

case "$(uname)" in
Darwin)
    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
    export PATH=$HOME/Library/Python/3.9/bin:$PATH
    export JAVA_HOME=/opt/homebrew/opt/java11
    export PATH=$JAVA_HOME/bin:$PATH
    ;;
Linux)
    if [ -d /usr/lib/jvm/java-11-openjdk-amd64 ]; then
      export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    else
      export JAVA_HOME=$(update-alternatives --display java 2>/dev/null | grep java-11 | head -1 | awk '{print $3}' | sed 's|/bin/java||' 2>/dev/null || echo "")
    fi
    [ -n "$JAVA_HOME" ] && export PATH=$JAVA_HOME/bin:$PATH

    if [ -d /usr/local/cuda-11.8 ]; then
      export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
      export PATH=/usr/local/cuda-11.8/bin${PATH:+:${PATH}}
    fi
    export M2_HOME=/usr/share/maven
    export MAVEN_HOME=/usr/share/maven
    export PATH=${M2_HOME}/bin:${PATH}
    ;;
*) ;;
esac
