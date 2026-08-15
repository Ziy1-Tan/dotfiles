autoload -U colors && colors
autoload -Uz vcs_info
zmodload zsh/datetime  # 提供 $EPOCHREALTIME（float，微秒精度）

# vcs_info: only git, only branch name in brackets
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '[%b]'
zstyle ':vcs_info:git:*' actionformats '[%b|%a]'

# Command execution time tracking（用 EPOCHREALTIME 替代 EPOCHSECONDS，无 fork）
typeset -F cmd_start_time=0
typeset -F cmd_elapsed=0

preexec() {
    cmd_start_time=$EPOCHREALTIME
}

precmd() {
    vcs_info
    if (( cmd_start_time > 0 )); then
        cmd_elapsed=$(( EPOCHREALTIME - cmd_start_time ))
        cmd_start_time=0
    else
        cmd_elapsed=0
    fi
}

function _cmd_exec_time() {
    # 只显示 >= 1s 的命令耗时
    (( cmd_elapsed < 1.0 )) && return

    typeset -i total_secs=$(( cmd_elapsed ))
    typeset -i hrs=$(( total_secs / 3600 ))
    typeset -i mins=$(( (total_secs % 3600) / 60 ))
    local secs=$(( cmd_elapsed - hrs * 3600 - mins * 60 ))

    if (( hrs > 0 )); then
        printf '%dh %dm %.1fs' $hrs $mins $secs
    elif (( mins > 0 )); then
        printf '%dm %.1fs' $mins $secs
    else
        printf '%.1fs' $secs
    fi
}

function _collapsed_pwd() {
    local pwd="${1:-$PWD}"
    local home="$HOME"
    local size=${#home}
    [[ -z "$pwd" ]] && return
    if [[ "$pwd" == "/" ]]; then
        echo "/"
        return
    elif [[ "$pwd" == "$home" ]]; then
        echo "~"
        return
    fi
    [[ "$pwd" == "$home/"* ]] && pwd="~${pwd:$size}"
    local -a elements=("${(s:/:)pwd}")
    local length=${#elements}
    for i in {1..$((length-1))}; do
        local elem=${elements[$i]}
        if [[ ${#elem} > 1 ]]; then
            if [[ "$elem" == .* ]]; then
                elements[$i]=${${elem//./}[1]}   # 取第一个非.字符
            else
                elements[$i]=${elem[1]}
            fi
        fi
    done
    local IFS="/"
    echo "${elements[*]}"
}

setopt PROMPT_SUBST
export PROMPT='%F{green}%n@%F{white}%m:%F{cyan}$(_collapsed_pwd)%F{green}${vcs_info_msg_0_}%F{white}> '
export RPROMPT='%F{red}%(?..%?)%f $(_cmd_exec_time)'
