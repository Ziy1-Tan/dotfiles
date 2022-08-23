- 自用配置文件
- 目的：
  1. 节省配置时间
  2. 实现开发环境无缝迁移
- List：

|         配置文件         | 说明                 |
| :----------------------: | -------------------- |
|       **`.vimrc`**       | **vim 配置**         |
|       **`.zshrc`**       | **zsh 配置**         |
|     **`.ideavimrc`**     | **vim plugins 配置** |
|         **`i3`**         | **i3wm 配置**        |
| **`.aur[pacmanc.list]`** | **软件列表**         |

## 高分屏下 KDE-WPS 字体发虚

- 编辑`/usr/bin/{wps、wpspdf、et、wpp}`
- 文件首行加入

```shell
export QT_SCREEN_SCALE_FACTORS=1
export QT_FONT_DPI=168
```

> GNOME 在`.zshrc`加入`export QT_AUTO_SCREEN_SCALE_FACTOR=1`
