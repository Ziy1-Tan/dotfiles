# proxy
#host_ip="127.0.0.1"
#https_proxy=http://$host_ip:7890
#http_proxy=http://$host_ip:7890
#all_proxy=socks5://$host_ip:7890
#export http_proxy https_proxy all_proxy

# go env
export GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
export GOROOT=/usr/local/go
export GOPATH=$HOME/code/go
export PATH=$GOROOT:$GOROOT/bin:$PATH

export EDITOR='vim'
export LANG=en_US.UTF-8

export PATH=$HOME/.local/bin:$PATH

case $(uname) in
Darwin)
    export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
    export PATH=/opt/homebrew/bin:$PATH
    export PATH=$HOME/Library/Python/3.9/bin:$PATH
    export JAVA_HOME=/opt/homebrew/opt/java11
    export PATH=$JAVA_HOME/bin:$PATH
    ;;
Linux)
    if [ -d /usr/lib/jvm/java-11-openjdk-amd64 ]; then
      export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    elif [ -d /usr/lib/jvm/java-11-openjdk-amd64 ]; then
      export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    else
      # Fallback: try to find any Java 11 installation
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

conda_bin=$HOME/miniconda3/bin/conda
if [ -f "$conda_bin" ]; then
  __conda_setup="$("$conda_bin" 'shell.zsh' 'hook' 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/miniconda3/etc/profile.d/conda.sh"
  else
    export PATH="$HOME/miniconda3/bin:$PATH"
  fi
  unset __conda_setup
fi

source $HOME/.cargo/env

HISDUP=erase
setopt sharehistory

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
