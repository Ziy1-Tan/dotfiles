- 自用配置文件
- 目的：
  1. 节省配置时间
  2. 实现开发环境无缝迁移
- List：

|     配置文件     | 说明                |
| :--------------: | ------------------- |
|   **`.vimrc`**   | **vim配置**         |
|   **`.zshrc`**   | **zsh配置**         |
| **`.ideavimrc`** | **vim plugins配置** |
|     **`i3`**     | **i3wm配置**        |
|  **`polybar`**   | **polybar配置**     |

## 高分屏下KDE-WPS字体发虚

- 编辑`/usr/bin/{wps、wpspdf、et、wpp}`
- 文件首行加入

```shell
export QT_SCREEN_SCALE_FACTORS=1
export QT_FONT_DPI=168
```

> GNOME在`.zshrc`加入`export QT_AUTO_SCREEN_SCALE_FACTOR=1`

