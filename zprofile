for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew_bin" ]; then
        eval "$("$brew_bin" shellenv)"
        break
    fi
done
