autoload -U colors && colors

# Command execution time tracking
cmd_start_time=0
cmd_elapsed=0

preexec() {
    cmd_start_time=$(( $(date +%s) ))
}

precmd() {
    if [[ $cmd_start_time -gt 0 ]]; then
        local cmd_end_time=$(date +%s)
        cmd_elapsed=$(( cmd_end_time - cmd_start_time ))
        cmd_start_time=0
    else
        cmd_elapsed=0
    fi
}

function _cmd_exec_time() {
    if [[ $cmd_elapsed -ge 5 ]]; then
        local mins=$(( cmd_elapsed / 60 ))
        local secs=$(( cmd_elapsed % 60 ))
        if [[ $mins -gt 0 ]]; then
            echo "${mins}m ${secs}s"
        else
            echo "${secs}s"
        fi
    fi
}

function _git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

function _collapsed_pwd() {
    local pwd="$1"
    local home="$HOME"
    local size=${#home}
    [[ $# == 0 ]] && pwd="$PWD"
    [[ -z "$pwd" ]] && return
    if [[ "$pwd" == "/" ]]; then
        echo "/"
        return
    elif [[ "$pwd" == "$home" ]]; then
        echo "~"
        return
    fi
    [[ "$pwd" == "$home/"* ]] && pwd="~${pwd:$size}"
    if [[ -n "$BASH_VERSION" ]]; then
        local IFS="/"
        local elements=($pwd)
        local length=${#elements[@]}
        for ((i=0;i<length-1;i++)); do
            local elem=${elements[$i]}
            if [[ ${#elem} -gt 1 ]]; then
                if [[ "$elem" == .* ]]; then
                    # 取第一个非.字符
                    local non_dot=${elem//./}
                    elements[$i]=${non_dot:0:1}
                else
                    elements[$i]=${elem:0:1}
                fi
            fi
        done
    else
        local elements=("${(s:/:)pwd}")
        local length=${#elements}
        for i in {1..$((length-1))}; do
            local elem=${elements[$i]}
            if [[ ${#elem} > 1 ]]; then
                if [[ "$elem" == .* ]]; then
                    # 取第一个非.字符
                    local non_dot=${elem//./}
                    elements[$i]=${non_dot[1]}
                else
                    elements[$i]=${elem[1]}
                fi
            fi
        done
    fi
    local IFS="/"
    echo "${elements[*]}"
}

setopt PROMPT_SUBST
export PROMPT='%F{green}%n@%F{white}%m:%F{cyan}$(_collapsed_pwd)%F{green}$(_git_branch)%F{white}> '
export RPROMPT='%F{red}%(?..%?)%f $(_cmd_exec_time)'
