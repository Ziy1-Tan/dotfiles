# dotfiles

```shell
git clone https://github.com/Ziy1-Tan/dotfiles.git --recurse-submodules
cd dotfiles/script && ./install && ./vim-plug
```

|         配置文件         | 说明                 |
| :----------------------: | -------------------- |
|       **`.vimrc`**       | **vim 配置**         |
|       **`.zshrc`**       | **zsh 配置**         |
|     **`.ideavimrc`**     | **vim plugins 配置** |
|         **`i3`**         | **i3wm 配置**        |
| **`.aur[pacmanc.list]`** | **软件列表**         |

## 高分屏下 KDE-WPS 字体发虚

编辑`/usr/bin/{wps、wpspdf、et、wpp}`

```shell
export QT_SCREEN_SCALE_FACTORS=1
export QT_FONT_DPI=168
```

> GNOME 在`.zshrc`加入`export QT_AUTO_SCREEN_SCALE_FACTOR=1`
