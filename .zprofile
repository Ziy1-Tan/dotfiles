if [ "$(uname -s)" = "Darwin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ "$(uname -s)" = "Linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
