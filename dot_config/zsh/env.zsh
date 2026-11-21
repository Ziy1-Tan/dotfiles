source "$HOME/.config/zsh/brew.zsh"

export LANG=en_US.UTF-8
export EDITOR=vim

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export GOPATH=$HOME/go
export GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
export PATH=$GOPATH/bin:$PATH

case "$(uname)" in
Darwin)
    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
    JAVA_HOME=$(/usr/libexec/java_home -v 11 2>/dev/null \
        || /usr/libexec/java_home 2>/dev/null \
        || echo /opt/homebrew/opt/java11)
    [ -n "$JAVA_HOME" ] && export JAVA_HOME && export PATH="$JAVA_HOME/bin:$PATH"
    ;;
Linux)
    if [ -d /usr/local/go ]; then
        export GOROOT=/usr/local/go
        export PATH=$GOROOT/bin:$PATH
    fi
    JAVA_HOME=""
    if (( $+commands[java] )); then
        JAVA_HOME=$(readlink -f "$commands[java]" 2>/dev/null | sed 's|/bin/java||')
    elif [ -d /usr/lib/jvm/java-11-openjdk-amd64 ]; then
        JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    fi
    [ -n "$JAVA_HOME" ] && export JAVA_HOME && export PATH="$JAVA_HOME/bin:$PATH"

    export M2_HOME=/usr/share/maven
    export MAVEN_HOME=/usr/share/maven
    export PATH=$M2_HOME/bin:$PATH
    ;;
esac
