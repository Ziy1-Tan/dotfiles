export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR="vim"

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export GOPROXY=https://mirrors.aliyun.com/goproxy/,direct

export PATH=$HOME/.local/bin:$PATH

case "$(uname)" in
Darwin)
    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
    export JAVA_HOME=/opt/homebrew/opt/java11
    export PATH=$JAVA_HOME/bin:$PATH
    ;;
Linux)
    # GOROOT — only needed when Go is installed manually (not via package manager)
    if [ -d /usr/local/go ]; then
      export GOROOT=/usr/local/go
      export PATH=$GOROOT/bin:$PATH
    fi
    if [ -d /usr/lib/jvm/java-11-openjdk-amd64 ]; then
      export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    else
      export JAVA_HOME=$(update-alternatives --display java 2>/dev/null | grep java-11 | head -1 | awk '{print $3}' | sed 's|/bin/java||' 2>/dev/null || echo "")
    fi
    [ -n "$JAVA_HOME" ] && export PATH=$JAVA_HOME/bin:$PATH

    export M2_HOME=/usr/share/maven
    export MAVEN_HOME=/usr/share/maven
    export PATH=${M2_HOME}/bin:${PATH}
    ;;
*) ;;
esac
