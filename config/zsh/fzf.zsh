# fzf PATH
[[ ! "$PATH" == */.fzf/bin* ]] && export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"

# fzf shell integration (key bindings + completions), cached to a file so we
# don't fork an `fzf --zsh` subprocess on every startup.
# -t 1 (a real TTY) guards against zinit's option restore triggering
# "can't change option: zle" in non-TTY interactive shells.
if [[ -o interactive && -t 1 ]] && (( $+commands[fzf] )); then
    _fzf_int_file="$HOME/.cache/zsh/fzf-integration.zsh"
    # Regenerate only when fzf is newer than the cache.
    [[ ! -f "$_fzf_int_file" || "$commands[fzf]" -nt "$_fzf_int_file" ]] \
        && fzf --zsh > "$_fzf_int_file" 2>/dev/null
    [[ -f "$_fzf_int_file" ]] && source "$_fzf_int_file"
    unset _fzf_int_file
fi

# Prefer fd for the default search; fall back to find if it isn't installed.
if (( $+commands[fd] )); then
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

# fzf's completion helpers; $1 is the base path to traverse.
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}
