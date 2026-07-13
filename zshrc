source "$HOME/.config/zsh/env.zsh"

# History dedup: erase all duplicates (not just consecutive), OMZL::history.zsh adds more opts
setopt HIST_IGNORE_ALL_DUPS
setopt sharehistory

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

zinit ice lucid wait="0" compile
zinit snippet OMZP::kubectl/kubectl.plugin.zsh    # k kgp kex 等 aliases

zinit ice lucid wait="0" compile
zinit snippet OMZP::docker/docker.plugin.zsh      # dps dex 等 aliases

# syntax-highlighting 必须最后加载：它在 zle -N 时 wrap 所有已注册 widget
zinit ice lucid wait="0" compile
zinit light zsh-users/zsh-syntax-highlighting

# fzf-tab: 用 fzf 替换 zsh 原生补全，需放在 syntax-highlighting 之后
zinit ice lucid wait="0" compile
zinit light Aloxaf/fzf-tab

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
zstyle ':fzf-tab:complete:(cd|ls|ll|cat|bat|vim|nvim|code|less|more):*' \
    fzf-preview 'bat --color=always --style=numbers $realpath 2>/dev/null || ls -la $realpath'

# cd 补全时显示目录树预览
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'

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

# uv - Python 版本和环境管理 (must be after compinit)
if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion zsh)"
    eval "$(uvx --generate-shell-completion zsh)"
fi

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
