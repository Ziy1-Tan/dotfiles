source "$HOME/.config/zsh/env.zsh"

HISDUP=erase
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

autoload -Uz compinit
if [[ -f "$HOME/.zcompdump" && $(( EPOCHSECONDS - $(stat -c %Y "$HOME/.zcompdump" 2>/dev/null || echo 0) )) -lt 86400 ]]; then
    compinit -C -d "$HOME/.zcompdump"
else
    compinit -d "$HOME/.zcompdump"
fi

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
export YSU_MODE=BESTMATCH

zinit ice blockf
zinit light zsh-users/zsh-completions

zinit ice lucid wait="0" atload="_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions
zinit ice lucid wait="0"
zinit light zsh-users/zsh-syntax-highlighting

zinit light MichaelAquilina/zsh-you-should-use

zinit snippet OMZP::sudo/sudo.plugin.zsh
zinit snippet OMZP::colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZP::git/git.plugin.zsh

zinit snippet OMZL::git.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh

autoload -Uz compinit
if [[ -f "$HOME/.zcompdump" && $(( EPOCHSECONDS - $(stat -c %Y "$HOME/.zcompdump" 2>/dev/null || echo 0) )) -lt 86400 ]]; then
    compinit -C -d "$HOME/.zcompdump"
else
    compinit -d "$HOME/.zcompdump"
fi

zinit cdreplay -q

# uv - Python 版本和环境管理 (must be after compinit)
eval "$(uv generate-shell-completion zsh 2>/dev/null)"
eval "$(uvx --generate-shell-completion zsh 2>/dev/null)"

# Load fzf only if it's installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
