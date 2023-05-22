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

read -p "Install to $install_dir? [y/n] " c

if [ "$c" != "y" ]; then
    echo "${red}Install aborted${nc}"
    exit 1
fi

if [ ! -d $install_dir ]; then
    echo "${red}Dir $install_dir does not exist${nc}"
    exit 1
fi

echo "Install..."

plug_path=$HOME/.vim/autoload/plug.vim
if [ ! -f "$plug_path" ]; then
    echo "Install vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "${green}vim-plug installed${nc}"
fi

cp $(pwd)/.vimrc $install_dir/
cp $(pwd)/.zshrc $install_dir/
cp $(pwd)/.ideavimrc $install_dir/
cp $(pwd)/.gitconfig $install_dir/
mkdir -p $install_dir/.ssh && cp $(pwd)/.ssh/config $install_dir/.ssh/
cp -r $(pwd)/.config/alacritty $install_dir/.config
cp -r $(pwd)/.config/zsh $install_dir/.config/
cp -r $(pwd)/.config/tmux $install_dir/.config

# zsh plugins
if [ -z "$(git submodule status)" ]; then
    echo "Install zsh plugins..."
    git submodule update --init --recursive
    rsync --exclude '.git' -auvhP $(pwd)/.zsh/ $install_dir/.zsh/
fi

ln -snf $install_dir/.config/tmux/.tmux.conf $install_dir/

echo "${green}Finished${nc}"
