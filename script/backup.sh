#!/bin/sh
SRC_PATH=~
CONFIG_PATH=.config
DIST_PATH=~/MyConfig

cp $SRC_PATH/.vimrc $DIST_PATH
cp $SRC_PATH/.ideavimrc $DIST_PATH
cp $SRC_PATH/.zshrc $DIST_PATH
cp $SRC_PATH/.Xresources $DIST_PATH
cp $SRC_PATH/.xprofile $DIST_PATH
cp $SRC_PATH/$CONFIG_PATH/libinput-gestures.conf $DIST_PATH/$CONFIG_PATH
cp -r $SRC_PATH/$CONFIG_PATH/alacritty $DIST_PATH/$CONFIG_PATH
cp -r $SRC_PATH/$CONFIG_PATH/i3 $DIST_PATH/$CONFIG_PATH
cp -r $SRC_PATH/$CONFIG_PATH/tmux $DIST_PATH/$CONFIG_PATH


pacman -Qqen > $DIST_PATH/pacman.list
pacman -Qqem > $DIST_PATH/aur.list
