excludes="--exclude .git --exclude .cache --exclude .vscode --exclude .idea --exclude .DS_Store --exclude node_modules --exclude .conan --exclude .m2 --exclude .vim"

export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow ${excludes}"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow ${excludes} . $HOME"

export FZF_COMPLETION_TRIGGER='\'

export FZF_DEFAULT_OPTS='--height 40% --info=inline --layout=reverse'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}
