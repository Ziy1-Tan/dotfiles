source "$HOME/.config/zsh/env.zsh"

# History dedup: erase all duplicates (not just consecutive), OMZL::history.zsh adds more opts
setopt HIST_IGNORE_ALL_DUPS
setopt sharehistory

setopt AUTO_CD             # 直接输入目录名即可进入
setopt EXTENDED_GLOB        # 增强 glob（^ / # / ~）
setopt INTERACTIVE_COMMENTS # 交互式 shell 允许 # 注释
setopt NO_BEEP              # 关闭错误提示音

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

if command -v brew >/dev/null 2>&1; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
export YSU_MODE=BESTMATCH

# ── 同步加载 ───────────────────────────────────────────────
# blockf: 防止 zsh-completions 直接写 fpath，由 zinit 管理
# compile: 生成 .zwc 字节码，加速加载
zinit ice blockf compile
zinit light zsh-users/zsh-completions

# OMZ lib/plugin（顺序敏感：git.zsh 须在 git plugin 前）
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git/git.plugin.zsh
zinit snippet OMZL::completion.zsh   # zstyle/zmodload，须在 compinit 前
zinit snippet OMZL::history.zsh      # setopt history，须在 OMZL 前
zinit snippet OMZL::key-bindings.zsh # bindkey，须在 ZLE 初始化前
zinit snippet OMZL::theme-and-appearance.zsh  # LS_COLORS / 终端标题

# 先输入再按 ↑ 匹配历史前缀（zsh4humans 同款交互）
# 同步加载（该插件在 zinit turbo 下 widget 不注册，必须同步）；在 syntax-highlighting 之前
zinit ice lucid compile
zinit light zsh-users/zsh-history-substring-search
# 插件只注册 widget，不自动绑键——显式绑定 ↑/↓（兼容 CSI 与应用模式两种转义）
bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
bindkey '\eOA' history-substring-search-up
bindkey '\eOB' history-substring-search-down

# ── 异步加载（wait="0"：首次 prompt 渲染后按注册顺序加载）─
# autosuggestions 需要最先拿到 ZLE，所以排在 async 队列头
zinit ice lucid wait="0" atload="_zsh_autosuggest_start" compile
zinit light zsh-users/zsh-autosuggestions

# 纯 alias/hook 插件，无 ZLE 依赖，可完全异步
zinit ice lucid wait="0" compile
zinit light MichaelAquilina/zsh-you-should-use

# copypath / copybuffer 依赖 OMZL::clipboard.zsh 提供的 clipcopy/clippaste 函数
zinit ice lucid wait="0" compile
zinit snippet OMZL::clipboard.zsh

zinit ice lucid wait="0" compile
zinit snippet OMZP::copypath/copypath.plugin.zsh

zinit ice lucid wait="0" compile
zinit snippet OMZP::copybuffer/copybuffer.plugin.zsh

zinit ice lucid wait="0" compile
zinit snippet OMZP::sudo/sudo.plugin.zsh          # Esc-Esc 加 sudo（ZLE widget）

zinit ice lucid wait="0" compile
zinit snippet OMZP::colored-man-pages/colored-man-pages.plugin.zsh

# kubectl/docker 是工具相关 alias 插件：仅当对应命令存在才加载。
# （alias 型插件无法用 wait"-0" 按需触发，用 if 条件门控更可靠）
zinit ice lucid wait="0" compile if'(( ${+commands[kubectl]} ))'
zinit snippet OMZP::kubectl/kubectl.plugin.zsh    # k kgp kex 等 aliases

zinit ice lucid wait="0" compile if'(( ${+commands[docker]} ))'
zinit snippet OMZP::docker/docker.plugin.zsh      # dps dex 等 aliases

# syntax-highlighting 必须最后加载：它在 zle -N 时 wrap 所有已注册 widget
zinit ice lucid wait="0" compile
zinit light zsh-users/zsh-syntax-highlighting

# fzf-tab: 用 fzf 替换 zsh 原生补全，需放在 syntax-highlighting 之后
zinit ice lucid wait="0" compile
zinit light Aloxaf/fzf-tab

# uv/uvx 补全：缓存为 #compdef 文件放入 fpath，由 compinit 懒加载
# （uv 生成的补全 ~500KB，每次启动 eval 会拖慢 ~120ms；懒加载首次按 Tab 才解析）
# 仅在 uv 更新或缓存缺失时重新生成；重新生成时删 dump 强制重建索引
if command -v uv >/dev/null 2>&1; then
    uv_comp_dir="$HOME/.cache/zsh/completions"
    if [[ ! -f "$uv_comp_dir/_uv" ]] || [[ "$(command -v uv)" -nt "$uv_comp_dir/_uv" ]]; then
        mkdir -p "$uv_comp_dir" 2>/dev/null
        uv generate-shell-completion zsh > "$uv_comp_dir/_uv" 2>/dev/null
        uvx --generate-shell-completion zsh > "$uv_comp_dir/_uvx" 2>/dev/null
        rm -f "$HOME/.zcompdump"   # 让 compinit 重建索引，纳入新补全
    fi
    fpath=("$uv_comp_dir" "${fpath[@]}")
    unset uv_comp_dir
fi

autoload -Uz compinit
() {
    local dump="$HOME/.zcompdump"
    local dump_mtime=0
    if [[ -f "$dump" ]]; then
        if [[ "$OSTYPE" == darwin* ]]; then
            dump_mtime=$(stat -f %m "$dump" 2>/dev/null || echo 0)
        else
            dump_mtime=$(stat -c %Y "$dump" 2>/dev/null || echo 0)
        fi
    fi
    if (( EPOCHSECONDS - dump_mtime < 86400 )); then
        compinit -C -d "$dump"
    else
        compinit -d "$dump"
    fi
}

zinit cdreplay -q

# ── fzf-tab 配置 ────────────────────────────────────────────
# 用 fzf 模糊搜索替代原生 tab 补全
zstyle ':fzf-tab:*' fzf-flags --height=50% --border --color=hl:yellow,hl+:yellow:bold

# 补全组名着色
zstyle ':fzf-tab:*' prefix ''
zstyle ':completion:*:descriptions' format '[%d]'

# 按补全组切换（ctrl-space / ctrl-/ 在组间跳转）
zstyle ':fzf-tab:*' switch-group 'ctrl-space' 'ctrl-/'

# 文件/目录补全时显示预览
zstyle ':fzf-tab:complete:(cd|ls|ll|cat|vim|nvim|code|less|more):*' \
    fzf-preview 'ls -la $realpath'

# cd 补全时显示目录内容
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'

# kill/ps 补全时显示进程信息
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-preview 'ps -p $word -o pid,user,comm,args 2>/dev/null'

# git 补全时不排序（保持最相关在前）
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-sort fzf-size

# 环境变量补全显示值
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
    fzf-preview 'echo ${(P)word}'

# brew 补全显示包信息
zstyle ':fzf-tab:complete:brew-(install|info|search):*' \
    fzf-preview 'brew info $word 2>/dev/null || brew search $word 2>/dev/null'

# docker 补全预览
zstyle ':fzf-tab:complete:docker:*' \
    fzf-preview 'docker inspect $word 2>/dev/null | jq -C ".[0]" 2>/dev/null || docker $word --help'

# kubectl 补全预览
zstyle ':fzf-tab:complete:kubectl:*' fzf-sort fzf-size


# Load fzf only if it's installed
# NOTE: ~/.fzf.zsh removed - fzf init consolidated in fzf.zsh with TTY guard

[ -f "$HOME/.config/zsh/fzf.zsh" ] && source "$HOME/.config/zsh/fzf.zsh"
[ -f "$HOME/.config/zsh/prompt.zsh" ] && source "$HOME/.config/zsh/prompt.zsh"
[ -f "$HOME/.config/zsh/alias.zsh" ] && source "$HOME/.config/zsh/alias.zsh"


export NVM_DIR="$HOME/.nvm"

# Put nvm default node on PATH immediately (reads one file, <1ms).
# This lets #!/usr/bin/env node shebangs (e.g. claude-internal) work without
# triggering the full lazy-load. The heavy nvm.sh is still deferred.
() {
    local alias_file="$NVM_DIR/alias/default"
    [[ ! -f "$alias_file" ]] && return
    local alias_val
    alias_val=$(<"$alias_file")
    # Follow one level of indirection (e.g. "default" -> "lts/*" or "22")
    [[ -f "$NVM_DIR/alias/$alias_val" ]] && alias_val=$(<"$NVM_DIR/alias/$alias_val")
    alias_val="${alias_val//[[:space:]]/}"
    # Match versions/node/v<alias_val>* — prefer exact, fall back to prefix
    local node_bin
    node_bin=$(ls -d "$NVM_DIR/versions/node/v${alias_val}"*/bin 2>/dev/null | sort -V | tail -1)
    [[ -n "$node_bin" && -d "$node_bin" ]] && export PATH="$node_bin:$PATH"
}

_lazy_load_nvm() {
    unset -f _lazy_load_nvm nvm node npm npx pnpm yarn corepack
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}

for cmd in nvm node npm npx pnpm yarn corepack; do
    eval "$cmd() { _lazy_load_nvm; $cmd \"\$@\"; }"
done

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export _ZO_DOCTOR=0
eval "$(zoxide init --cmd cd zsh)"

[ -f "$HOME/.config/zsh/local.zsh" ] && source "$HOME/.config/zsh/local.zsh"

# 保证 sourcing zshrc 成功返回（否则最后一条 `[ -f ] && source` 在文件缺失时返回 1，
# 会让 `zsh -i -c exit` 报退出码 1，可能被 CI/脚本误判为失败）
:
