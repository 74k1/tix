# Custom Zsh theme inspired by Starship configuration

# Color definitions
local purple='%F{#573fbd}'
local dark_purple='%F{#332671}'
local darker_purple='%F{#22194b}'
local green='%F{#22EF92}'
local red='%F{#FF5A74}'
local yellow='%F{yellow}'
local reset='%f'

# Helper function to get Git information
git_info() {
    local ref
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "${ref#refs/heads/}"
}

git_status() {
    local STATUS=""
    local -a FLAGS
    FLAGS=('--porcelain')
    if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
        if [[ $POST_1_7_2_GIT -gt 0 ]]; then
            FLAGS+='--ignore-submodules=dirty'
        fi
        if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
            FLAGS+='--untracked-files=no'
        fi
        STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
    fi
    if [[ -n $STATUS ]]; then
        echo "%F{red}●%f"
    else
        echo "%F{green}●%f"
    fi
}

# Prompt segments
username() {
    echo "${purple}[%n]${reset}"
}

hostname() {
    echo "${dark_purple}[%m]${reset}"
}

directory() {
    local path_color="${darker_purple}"
    local path_length=4
    local cwd="${PWD/#$HOME/~}"
    local formatted_cwd

    if [[ "$cwd" == (#m)[/~] ]]; then
        formatted_cwd="$MATCH"
    else
        formatted_cwd="${${${${(@j:/:M)${(@s:/:)cwd}##.#?}:h}%/}//\%/%%}/${${cwd:t}//\%/%%}"
        if [[ $#formatted_cwd -gt $path_length ]]; then
            formatted_cwd=".../${formatted_cwd:$#formatted_cwd-$path_length+1}"
        fi
    fi

    echo "${path_color}[${formatted_cwd}]${reset}"
}

git_branch() {
    local ref
    ref=$(git_info)
    if [[ -n "$ref" ]]; then
        echo "${green}[  ${ref}]${reset}"
    fi
}

git_status_indicator() {
    local status
    status=$(git_status)
    if [[ -n "$status" ]]; then
        echo "${status}"
    fi
}

cmd_execution_time() {
    local duration=$((SECONDS - start_time))
    if (( duration >= 1 )); then
        echo "${yellow}[${duration}s]${reset}"
    fi
}

# Set the prompt
setopt prompt_subst

PROMPT='$(username)$(hostname)$(directory)$(git_branch)$(git_status_indicator)
%(?:%F{#8366fc}:%F{red})❯%f '

RPROMPT='$(cmd_execution_time)'

# Record the start time of each command
preexec() {
    start_time=$SECONDS
}
