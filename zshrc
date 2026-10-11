source "$HOME/.config/zsh/env.zsh"

# History: drop all duplicates (not just consecutive ones) and share across
# sessions. OMZL::history.zsh (loaded below) adds further options.
setopt HIST_IGNORE_ALL_DUPS sharehistory

setopt AUTO_CD              # type a bare directory name to cd into it
setopt EXTENDED_GLOB        # ^ / # / ~ glob operators
setopt INTERACTIVE_COMMENTS # allow # comments at the interactive prompt
setopt NO_BEEP              # no beep on error

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

# Homebrew's site completions (macOS / Linuxbrew)
if (( $+commands[brew] )); then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
export YSU_MODE=BESTMATCH

# ── Synchronous loads ────────────────────────────────────────────────────────
# Everything here must exist before compinit (below) and before ZLE starts, so
# none of it can be turbo-loaded.
#
# blockf keeps zsh-completions from writing to fpath itself — zinit manages it.
zinit blockf compile light-mode for zsh-users/zsh-completions

# OMZ libs/plugins. Order matters: git.zsh before the git plugin, completion.zsh
# before compinit, key-bindings.zsh before ZLE initialises.
zinit for \
    OMZL::git.zsh \
    OMZP::git/git.plugin.zsh \
    OMZL::completion.zsh \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::theme-and-appearance.zsh

# Prefix-aware history search on ↑ (zsh4humans-style). Must load synchronously
# (its widgets don't register under turbo) and before syntax-highlighting.
zinit lucid compile light-mode for zsh-users/zsh-history-substring-search
# The plugin only registers widgets — bind them here.
bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
bindkey '\eOA' history-substring-search-up
bindkey '\eOB' history-substring-search-down

# ── Turbo loads ──────────────────────────────────────────────────────────────
# wait="0" defers these until after the first prompt renders, keeping startup
# fast. Order is load-bearing: autosuggestions needs the ZLE first; clipboard.zsh
# provides the clipcopy/clippaste that copypath/copybuffer use, so it comes
# before them; syntax-highlighting wraps every widget registered before it;
# fzf-tab replaces native completion, so it comes after syntax-highlighting.
zinit lucid wait="0" compile light-mode for \
    atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    MichaelAquilina/zsh-you-should-use \
    OMZL::clipboard.zsh \
    OMZP::copypath/copypath.plugin.zsh \
    OMZP::copybuffer/copybuffer.plugin.zsh \
    OMZP::sudo/sudo.plugin.zsh \
    OMZP::colored-man-pages/colored-man-pages.plugin.zsh \
    if'(( ${+commands[kubectl]} ))' OMZP::kubectl/kubectl.plugin.zsh \
    if'(( ${+commands[docker]} ))' OMZP::docker/docker.plugin.zsh \
    zsh-users/zsh-syntax-highlighting \
    Aloxaf/fzf-tab

# uv/uvx completions: generate #compdef files into fpath once, then let compinit
# pick them up lazily. (uv's completion is ~500 KB; eval-ing it every startup
# costs ~120 ms.) Regenerate only when uv changes or the cache is missing.
if (( $+commands[uv] )); then
    uv_comp_dir="$HOME/.cache/zsh/completions"
    if [[ ! -f "$uv_comp_dir/_uv" ]] || [[ "$commands[uv]" -nt "$uv_comp_dir/_uv" ]]; then
        mkdir -p "$uv_comp_dir" 2>/dev/null
        uv generate-shell-completion zsh > "$uv_comp_dir/_uv" 2>/dev/null
        uvx --generate-shell-completion zsh > "$uv_comp_dir/_uvx" 2>/dev/null
        rm -f "$HOME/.zcompdump"   # force compinit to rebuild its index
    fi
    fpath=("$uv_comp_dir" "${fpath[@]}")
    unset uv_comp_dir
fi

autoload -Uz compinit
() {
    local dump="$HOME/.zcompdump" mtime
    # Reuse the dump when it is under a day old: -C skips compinit's fpath
    # security check. zsh/stat avoids forking stat(1) and its GNU/macOS flag split.
    zmodload -F zsh/stat b:zstat 2>/dev/null
    mtime=$(zstat +mtime "$dump" 2>/dev/null || echo 0)
    if (( EPOCHSECONDS - mtime < 86400 )); then
        compinit -C -d "$dump"
    else
        compinit -d "$dump"
    fi
}

zinit cdreplay -q

# ── fzf-tab ──────────────────────────────────────────────────────────────────
# fzf-tab routes completion through fzf. `fzf-preview` sets the preview pane per
# command; `fzf-sort fzf-size` opts out of fzf's re-sorting to keep zsh's
# relevance order; `${(P)word}` expands the parameter being completed.
zstyle ':fzf-tab:*' fzf-flags --height=50% --border --color=hl:yellow,hl+:yellow:bold
zstyle ':fzf-tab:*' prefix ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group 'ctrl-space' 'ctrl-/'

zstyle ':fzf-tab:complete:(cd|ls|ll|cat|vim|nvim|code|less|more):*' fzf-preview 'ls -la $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-preview 'ps -p $word -o pid,user,comm,args 2>/dev/null'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-sort fzf-size
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:brew-(install|info|search):*' fzf-preview 'brew info $word 2>/dev/null || brew search $word 2>/dev/null'
zstyle ':fzf-tab:complete:docker:*' fzf-preview 'docker inspect $word 2>/dev/null | jq -C ".[0]" 2>/dev/null || docker $word --help'
zstyle ':fzf-tab:complete:kubectl:*' fzf-sort fzf-size

[[ -f "$HOME/.config/zsh/fzf.zsh" ]] && source "$HOME/.config/zsh/fzf.zsh"
[[ -f "$HOME/.config/zsh/prompt.zsh" ]] && source "$HOME/.config/zsh/prompt.zsh"
[[ -f "$HOME/.config/zsh/alias.zsh" ]] && source "$HOME/.config/zsh/alias.zsh"

export NVM_DIR="$HOME/.nvm"

# Put nvm's default node on PATH now, cheaply, so `#!/usr/bin/env node` shebangs
# work without triggering the lazy load below. The heavy nvm.sh stays deferred.
() {
    local alias_file="$NVM_DIR/alias/default" alias_val node_bin
    [[ -f "$alias_file" ]] || return
    alias_val=$(<"$alias_file")
    # Follow one level of indirection (e.g. "lts/*" -> "22").
    [[ -f "$NVM_DIR/alias/$alias_val" ]] && alias_val=$(<"$NVM_DIR/alias/$alias_val")
    alias_val="${alias_val//[[:space:]]/}"
    node_bin=$(ls -d "$NVM_DIR/versions/node/v${alias_val}"*/bin 2>/dev/null | sort -V | tail -1)
    [[ -n "$node_bin" && -d "$node_bin" ]] && export PATH="$node_bin:$PATH"
}

# nvm.sh is slow, so load it (once) on first use of any node-family command.
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

[[ -f "$HOME/.config/zsh/local.zsh" ]] && source "$HOME/.config/zsh/local.zsh"

# Keep this file's exit status 0: with local.zsh absent the line above returns 1,
# which would make `zsh -i -c exit` look like a failure to scripts and CI.
:
