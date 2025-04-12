# disable oh my zsh update
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
ZSH_DISABLE_COMPFIX="true"

pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
ZSH=$HOME/.zsh/ohmyzsh

ZSH_THEME=""

plugins=(sudo git z colored-man-pages docker)


if command -v brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}" # brew comp
fi

fpath+=($HOME/.zsh/zsh-completions/src)
fpath+=($HOME/.zsh/conda-zsh-completion)
autoload -U compinit && compinit

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=23'
source ~/.zsh/zsh-you-should-use/you-should-use.plugin.zsh
export YSU_MODE=BESTMATCH

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir -p $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/fzf.zsh
source $HOME/.config/zsh/prompt.zsh
source $HOME/.config/zsh/alias.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey "ç" fzf-cd-widget
