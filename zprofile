if [ $(uname) = "Darwin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ $(uname) = "Linux" ] && [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
