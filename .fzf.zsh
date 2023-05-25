# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/simple/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/simple/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/simple/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/simple/.fzf/shell/key-bindings.zsh"
