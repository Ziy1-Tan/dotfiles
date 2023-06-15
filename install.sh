#!/bin/sh
green='\033[1;32m'
red='\033[1;31m'
nc='\033[0m'

if [ "." != "$(dirname "$0")" ]; then
    echo "${red}Install aborted${nc}"
    exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
    echo "${red}$(rsync) is not installed${nc}"
    exit 1
fi

install_dir=${1:-$HOME}

read -p "Install to $install_dir? ([y]/n) " c

if [ "$c" != "y" ] && [ -n "$c" ]; then
    echo "${red}Install aborted${nc}"
    exit 1
fi

if [ ! -d $install_dir ]; then
    echo "${red}Dir $install_dir does not exist${nc}"
    exit 1
fi

echo "Install..."

cp $(pwd)/.vimrc $install_dir/ &&
    cp $(pwd)/.zshrc $install_dir/ && 
    source $install_dir/.zshrc&&
    cp $(pwd)/.zprofile $install_dir/ &&
    cp $(pwd)/.ideavimrc $install_dir/ &&
    cp $(pwd)/.gitconfig $install_dir/ &&
    mkdir -p $install_dir/.ssh && cp $(pwd)/.ssh/config $install_dir/.ssh/ &&
    cp -r $(pwd)/.config/alacritty $install_dir/.config/ &&
    cp -r $(pwd)/.config/zsh $install_dir/.config/ &&
    cp -r $(pwd)/.config/tmux $install_dir/.config/ &&
    ln -snf $install_dir/.config/tmux/.tmux.conf $install_dir/

# zsh plugins
if git submodule status | grep -q "^[-+]"; then
    echo "Install zsh plugins..."
    git submodule update --init --recursive
fi
rsync --exclude '.git' -auvhP --delete $(pwd)/.zsh/ $install_dir/.zsh/

# vim plugins
plug_path=$HOME/.vim/autoload/plug.vim
if [ ! -f "$plug_path" ]; then
    echo "Install vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# fzf
if ! command -v fzf >/dev/null 2>&1; then
    echo "Install fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &&
        ~/.fzf/install
fi

# brew
if ! command -v brew >/dev/null 2>&1; then
    echo "Install homebrew..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "${green}Finished${nc}"
