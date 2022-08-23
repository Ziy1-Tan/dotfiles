#!/bin/sh

SRC_PATH=~/MyConfig
CONFIG_PATH=.config
DIST_PATH=~

install_linux_conf() {
    cp $SRC_PATH/.Xresources $DIST_PATH
    cp $SRC_PATH/.xprofile $DIST_PATH
    cp $SRC_PATH/$CONFIG_PATH/libinput-gestures.conf $DIST_PATH/$CONFIG_PATH
    cp -r $SRC_PATH/$CONFIG_PATH/i3 $DIST_PATH/$CONFIG_PATH
}

cp $SRC_PATH/.vimrc $DIST_PATH
cp $SRC_PATH/.ideavimrc $DIST_PATH
cp $SRC_PATH/.zshrc $DIST_PATH
cp -r $SRC_PATH/$CONFIG_PATH/alacritty $DIST_PATH/$CONFIG_PATH
cp -r $SRC_PATH/$CONFIG_PATH/tmux $DIST_PATH/$CONFIG_PATH

ln -s $DIST_PATH/$CONFIG_PATH/tmux/.tmux.conf $DIST_PATH/

uname=$(uname -s)
OS=${uname:0:5}
if [ "$OS" == "Linux" ]; then
    backup_linux_conf
fi
