export LANG=en_US.UTF-8
export EDITOR=vim

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export GOPATH=$HOME/go
export GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
export PATH=$HOME/.local/bin:$GOPATH/bin:$PATH

case "$(uname)" in
Darwin)
    # Homebrew's GNU sed (BSD sed has different -i semantics)
    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
    # Locate the JDK through java_home (prefer 11, else newest) rather than
    # hardcoding a version path.
    JAVA_HOME=$(/usr/libexec/java_home -v 11 2>/dev/null \
        || /usr/libexec/java_home 2>/dev/null \
        || echo /opt/homebrew/opt/java11)
    [ -n "$JAVA_HOME" ] && export JAVA_HOME && export PATH="$JAVA_HOME/bin:$PATH"
    ;;
Linux)
    # GOROOT only matters for a manual Go install; package managers set it themselves.
    if [ -d /usr/local/go ]; then
        export GOROOT=/usr/local/go
        export PATH=$GOROOT/bin:$PATH
    fi
    # Derive JAVA_HOME from the java binary (readlink -f resolves the symlink
    # chain), which is sturdier than parsing update-alternatives. Reset first so
    # a stale value inherited from the environment can't leak onto PATH.
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
