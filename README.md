# dotfiles

## 首次使用
```shell
git clone https://github.com/Ziy1-Tan/dotfiles.git --recurse-submodules
cd dotfiles/script && ./install && ./vim-plug
```
## 文件说明
|      配置文件       | 说明             |
| :-----------------: | ---------------- |
|      `.vimrc`       | vim 配置         |
|      `.zshrc`       | zsh 配置         |
|    `.ideavimrc`    | vim plugins 配置 |
|        `i3`         | i3wm 配置        |
| `aur[pacmanc.list]` | 软件列表         |

## 高分屏下 KDE-WPS 字体发虚

编辑`/usr/bin/{wps、wpspdf、et、wpp}`

```shell
export QT_SCREEN_SCALE_FACTORS=1
export QT_FONT_DPI=168
```

> GNOME 在`.zshrc`加入`export QT_AUTO_SCREEN_SCALE_FACTOR=1`
## WSL2代理设置
`.zshrc`中加入
```shell
host_ip=$(cat /etc/resolv.conf | grep "nameserver" | cut -f 2 -d " ")
export https_proxy=http://${host_ip}:7890
export http_proxy=http://${host_ip}:7890
export all_proxy=socks5://${host_ip}:7890
```
