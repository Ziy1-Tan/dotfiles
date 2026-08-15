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
    # macOS 用 /usr/libexec/java_home 定位（优先 Java 11，找不到则取最新），
    # 不再硬编码版本路径
    JAVA_HOME=$(/usr/libexec/java_home -v 11 2>/dev/null \
        || /usr/libexec/java_home 2>/dev/null \
        || echo /opt/homebrew/opt/java11)
    [ -n "$JAVA_HOME" ] && export JAVA_HOME && export PATH="$JAVA_HOME/bin:$PATH"
    ;;
Linux)
    # GOROOT — only needed when Go is installed manually (not via package manager)
    if [ -d /usr/local/go ]; then
      export GOROOT=/usr/local/go
      export PATH=$GOROOT/bin:$PATH
    fi
    # 从 java 二进制推导 JAVA_HOME（readlink -f 解析 symlink 链），
    # 不再依赖脆弱的 update-alternatives 管道
    JAVA_HOME=""
    if command -v java >/dev/null 2>&1; then
      JAVA_HOME=$(readlink -f "$(command -v java)" 2>/dev/null | sed 's|/bin/java||')
    elif [ -d /usr/lib/jvm/java-11-openjdk-amd64 ]; then
      JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    fi
    [ -n "$JAVA_HOME" ] && export JAVA_HOME && export PATH="$JAVA_HOME/bin:$PATH"

    export M2_HOME=/usr/share/maven
    export MAVEN_HOME=/usr/share/maven
    export PATH=${M2_HOME}/bin:${PATH}
    ;;
*) ;;
esac
