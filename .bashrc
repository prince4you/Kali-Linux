# ======================================================================
# ~/.bashrc - Custom bash configuration
# Maintainer : Sunil (GitHub: prince4you | YouTube: @noobcybertech)
# ======================================================================

[[ $- != *i* ]] && return

# ======================================================================
# History Settings
# ======================================================================
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T "
shopt -s histappend cmdhist checkwinsize globstar dotglob extglob

# ======================================================================
# Prompt (Inspired by Kali Linux)
# ======================================================================
__custom_prompt() {
    local EXIT="$?"
    local RED="\\\033[1;31m\"
    local GREEN="\\\033[1;32m\"
    local YELLOW="\\\033[1;33m\"
    local BLUE="\\\033[1;34m\"
    local PURPLE="\\\033[1;35m\"
    local CYAN="\\\033[1;36m\"
    local RESET="\\\033[0m\"

    local git_branch=""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        git_branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
        [[ -n "$git_branch" ]] && git_branch="${BLUE}(${git_branch})"
    fi

    local venv=""
    [[ -n "$VIRTUAL_ENV" ]] && venv="${YELLOW}($(basename "$VIRTUAL_ENV"))"

    local user_symbol="㉿"
    [[ $EUID -eq 0 ]] && user_symbol="💀"

    PS1="\\n${GREEN}┌──[${CYAN}\\u${RESET}${user_symbol}${PURPLE}\\h${RESET}]${venv}${git_branch}\\n"
    PS1+="${GREEN}├──[${YELLOW}\\w${RESET}]\\n"
    if [[ $EXIT -ne 0 ]]; then
        PS1+="${GREEN}└──[${RED}✘$EXIT${RESET}]➜ "
    else
        PS1+="${GREEN}└──[${GREEN}✔${RESET}]➜ "
    fi

    echo -ne "\\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\\007"
}
PROMPT_COMMAND=__custom_prompt

# ======================================================================
# Aliases
# ======================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias cls='clear; ls'
alias h='history'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias lt='ls -ltrh'
alias lsize='ls -lSr'
alias ldate='ls -lt'
alias grep='grep --color=auto'

# System Commands
alias update='sudo apt update'
alias upgrade='sudo apt update && sudo apt full-upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias purge='sudo apt purge'
alias autoremove='sudo apt autoremove -y'
alias clean='sudo apt autoclean && sudo apt autoremove -y'

# Git Shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'

# Networking Tools
alias myip='curl ifconfig.me && echo'
alias ping='ping -c 5'
alias listen='lsof -i -P -n | grep LISTEN'

# Fun
alias matrix='cmatrix -ab'
alias weather='curl wttr.in'

# ======================================================================
# Functions
# ======================================================================

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1" ;;
            *.tar.gz)    tar xvzf "$1" ;;
            *.bz2)       bunzip2 "$1" ;;
            *.rar)       unrar x "$1" ;;
            *.gz)        gunzip "$1" ;;
            *.tar)       tar xvf "$1" ;;
            *.zip)       unzip "$1" ;;
            *.7z)        7z x "$1" ;;
            *)           echo "Unknown archive format: $1" ;;
        esac
    else
        echo "$1 is not a valid file"
    fi
}

mcd() {
    mkdir -p "$1" && cd "$1"
}

cl() {
    cd "$1" && ls
}
