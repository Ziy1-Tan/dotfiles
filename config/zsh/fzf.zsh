# Check if fd is installed before using it
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude={.git,.idea,.vscode,node_modules,.cache,.conan}"

  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git . $HOME"
else
  export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.*' 2>/dev/null"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.*' 2>/dev/null"
fi

export FZF_COMPLETION_TRIGGER='\'

export FZF_DEFAULT_OPTS='--height 80% --info=inline --layout=reverse'

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
