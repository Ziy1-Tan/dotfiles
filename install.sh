#!/bin/sh

if [ $(dirname $0) != "." ]; then
    echo "must be executed in root"
    exit 1
fi

SRC=.
CONF=.config

install_linux_conf() {
    cp $SRC/.Xresources $HOME
    cp $SRC/.xprofile $HOME
    cp $SRC/$CONF/libinput-gestures.conf $HOME/$CONF
    cp -r $SRC/$CONF/i3 $HOME/$CONF
}

cp $SRC/.vimrc $HOME
cp $SRC/.ideavimrc $HOME
cp $SRC/.zshrc $HOME
cp -r $SRC/$CONF/alacritty $HOME/$CONF
cp -r $SRC/$CONF/tmux $HOME/$CONF
cp -r $SRC/$CONF/zsh $HOME/$CONF

ln -snf $HOME/$CONF/tmux/.tmux.conf $HOME/

/usr/bin/which rsync
if [ $? -eq 0 ]; then
    rsync --exclude '.git' -av $SRC/zsh/ $HOME/.zsh/
else
    echo '`rsync` is not available!'
    exit 1
fi

os=$(uname)
if [ "$os"=="Linux" ]; then
    install_linux_conf
fi
