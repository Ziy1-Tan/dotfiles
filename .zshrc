# opt paste speed
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

plugins=(sudo git z colored-man-pages)

source ~/.zsh/wakatime/wakatime.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=($HOME/.zsh/zsh-completions/src)
fpath+=($HOME/.zsh/conda-zsh-completion)

autoload -U compinit && compinit

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir -p $ZSH_CACHE_DIR
fi

source $HOME/.config/zsh/alias.zsh
source $HOME/.config/zsh/env.zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.config/zsh/prompt.zsh



# enable pure prompt
# fpath+=($HOME/.zsh/pure)
# autoload -U promptinit; promptinit
# prompt pure
# PURE_PROMPT_SYMBOL="#"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
