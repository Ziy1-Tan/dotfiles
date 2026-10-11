# Load Homebrew's shellenv from the first brew present (macOS ARM, Linuxbrew, Intel macOS).
for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew_bin" ]; then
        eval "$("$brew_bin" shellenv)"
        break
    fi
done
