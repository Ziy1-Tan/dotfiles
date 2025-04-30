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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init --cmd cd zsh)"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=23'
export YSU_MODE=BESTMATCH

source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/fzf.zsh
source $HOME/.config/zsh/prompt.zsh
source $HOME/.config/zsh/alias.zsh

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light conda-incubator/conda-zsh-completion
zinit light zsh-users/zsh-syntax-highlighting
zinit light MichaelAquilina/zsh-you-should-use
zinit light ael-code/zsh-colored-man-pages

zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
zinit snippet OMZ::lib/git.zsh
