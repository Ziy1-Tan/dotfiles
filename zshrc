# Fix locale warnings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

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
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}" # brew comp
fi

source $HOME/.config/zsh/env.zsh

# Load fzf only if it's installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=23'
export YSU_MODE=BESTMATCH

source $HOME/.config/zsh/fzf.zsh
source $HOME/.config/zsh/prompt.zsh
source $HOME/.config/zsh/alias.zsh

zinit ice blockf
zinit light zsh-users/zsh-completions

zinit ice lucid wait="0" atload="_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions
zinit ice lucid wait='0' atinit='zpcompinit'
zinit light zsh-users/zsh-syntax-highlighting

zinit light conda-incubator/conda-zsh-completion
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
compinit

zinit cdreplay -q

eval "$(zoxide init --cmd cd zsh)"
### End of Zinit's installer chunk

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias claude-mem='bun "/home/simple/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'
