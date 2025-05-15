#!/bin/bash
# ======================================================================
# ~/.bashrc - Custom bash configuration
# 
# Curated by: Sunil (GitHub: @prince4you | YouTube: @noobcybertech)
# Created on: $(date +"%Y-%m-%d")
# 
# Features:
# - Enhanced prompt with system info
# - 100+ useful aliases and functions
# - Improved security and productivity
# - Kali Linux optimized
# ======================================================================

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ======================================================================
#                     TERMINAL BEHAVIOR SETTINGS
# ======================================================================

# History settings
HISTCONTROL=ignoreboth           # Ignore duplicate commands and spaces
HISTSIZE=5000                    # Larger command history
HISTFILESIZE=10000               # Larger history file
HISTTIMEFORMAT="%F %T "          # Timestamp in history
shopt -s histappend              # Append to history file
shopt -s cmdhist                 # Save multi-line commands properly
shopt -s checkwinsize            # Check window size after each command
shopt -s globstar                # Enable ** pattern matching
shopt -s dotglob                 # Include dotfiles in path expansion
shopt -s extglob                 # Extended pattern matching

# ======================================================================
#                      CUSTOM PROMPT (POWERLINE-STYLE)
# ======================================================================

__prompt_command() {
    local EXIT="$?"
    
    # Colors
    local RED="\[\033[1;31m\]"
    local GREEN="\[\033[1;32m\]"
    local YELLOW="\[\033[1;33m\]"
    local BLUE="\[\033[1;34m\]"
    local PURPLE="\[\033[1;35m\]"
    local CYAN="\[\033[1;36m\]"
    local WHITE="\[\033[1;37m\]"
    local RESET="\[\033[0m\]"
    
    # Git branch info
    local git_branch=""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        git_branch="$(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
        [[ -n "$git_branch" ]] && git_branch="${BLUE} (${git_branch})"
    fi
    
    # Python virtualenv
    local venv=""
    [[ -n "$VIRTUAL_ENV" ]] && venv="${YELLOW} ($(basename "$VIRTUAL_ENV"))"
    
    # Root/user indicator
    local user_indicator="㉿"
    [[ $EUID -eq 0 ]] && user_indicator="💀"
    
    # First line - user@host:directory
    PS1="\n${GREEN}┌──${RESET}[${CYAN}\u${RESET}${user_indicator}${PURPLE}\h${RESET}]${venv}${git_branch}\n"
    
    # Second line - directory and prompt
    PS1+="${GREEN}├──${RESET}[${YELLOW}\w${RESET}]\n"
    
    # Third line - status indicator and prompt
    if [ $EXIT != 0 ]; then
        PS1+="${GREEN}└──${RESET}[${RED}✘${EXIT}${RESET}]➜ "
    else
        PS1+="${GREEN}└──${RESET}[${GREEN}✔${RESET}]➜ "
    fi
    
    # Set terminal title
    echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"
}

PROMPT_COMMAND=__prompt_command

# ======================================================================
#                       ALIASES (PRODUCTIVITY BOOST)
# ======================================================================

# System Monitoring
alias cpu='htop'
alias mem='free -mth'
alias disk='df -h'
alias netstat='ss -tulpn'
alias ports='netstat -tulanp'
alias traffic='iftop'
alias temp='sensors'
alias services='systemctl list-units --type=service --state=running'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias c='clear'
alias cls='clear; ls'
alias desktop='cd ~/Desktop'
alias downloads='cd ~/Downloads'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'

# Listing
alias ls='ls --color=auto -hF'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias l.='ls -d .*'
alias lt='ls -ltrh'
alias lsize='ls -lSr'
alias ldate='ls -lt'
alias tree='tree -C'

# File Operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv --preserve-root'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias df='df -h'
alias du='du -ch'
alias mkdir='mkdir -pv'
alias wget='wget -c'

# Grep/Find
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ffind='find . -type f -name'
alias dfind='find . -type d -name'
alias hg='history | grep'
alias pg='ps aux | grep'

# Networking
alias myip='curl ifconfig.me && echo'
alias myip4='curl -4 ifconfig.me && echo'
alias myip6='curl -6 ifconfig.me && echo'
alias ports='netstat -tulanp'
alias header='curl -I'
alias ping='ping -c 5'
alias trace='traceroute'
alias listen='lsof -i -P -n | grep LISTEN'
alias netcons='lsof -i'

# Git Shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gcm='git commit --amend'
alias gcl='git clone'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpl='git pull'
alias gst='git stash'
alias gfp='git fetch --all --prune'

# Package Management
alias update='sudo apt update'
alias upgrade='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias purge='sudo apt purge'
alias autoremove='sudo apt autoremove'
alias clean='sudo apt autoclean && sudo apt autoremove'
alias search='apt search'
alias show='apt show'
alias depends='apt depends'
alias pkglist='dpkg --get-selections | grep -v deinstall'

# Kali Specific
alias kali-metapkg='sudo apt install kali-linux-large'
alias kali-desktop='sudo apt install dbus-x11 xwayland kali-desktop-xfce -y'
alias kali-tools='sudo apt install kali-tools-top10'
alias kali-update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'

# Termux Specific
alias termux='cd /data/data/com.termux/files/home'
alias pkg='pkg install'

# Security
alias firewall='sudo ufw status verbose'
alias vulnscan='sudo lynis audit system'
alias rootkit='sudo rkhunter --check'

# Python
alias py='python3'
alias py2='python2'
alias py3='python3'
alias venv='python3 -m venv'
alias pipup='pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U'

# Docker
alias dk='docker'
alias dki='docker images'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dklog='docker logs'
alias dkstart='docker start'
alias dkstop='docker stop'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dkup='docker-compose up -d'
alias dkdown='docker-compose down'

# Fun Stuff
alias matrix='cmatrix -ab'
alias starwars='telnet towel.blinkenlights.nl'
alias weather='curl wttr.in'
alias moon='curl wttr.in/Moon'
alias cheat='curl cheat.sh'

# ======================================================================
#                       CUSTOM FUNCTIONS
# ======================================================================

# Extract any compressed file
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"    ;;
            *.tar.gz)    tar xvzf "$1"    ;;
            *.bz2)      bunzip2 "$1"     ;;
            *.rar)      unrar x "$1"     ;;
            *.gz)       gunzip "$1"      ;;
            *.tar)      tar xvf "$1"     ;;
            *.tbz2)     tar xvjf "$1"    ;;
            *.tgz)      tar xvzf "$1"    ;;
            *.zip)      unzip "$1"       ;;
            *.Z)        uncompress "$1"  ;;
            *.7z)       7z x "$1"        ;;
            *)          echo "Don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Create and cd into directory
mcd() {
    mkdir -p "$1" && cd "$1" || return
}

# Change directory and list contents
cl() {
    cd "$1" && ls
}

# Create a backup of a file
bak() {
    cp -iv "$1" "$1.bak"
}

# Get IP geolocation
geoip() {
    curl -s "http://ip-api.com/json/${1:-}" | jq .
}

# Create a password
genpass() {
    local length=${1:-16}
    tr -dc 'A-Za-z0-9!@#$%^&*()' < /dev/urandom | head -c "$length" && echo
}

# Count files in directory
count() {
    find "${1:-.}" -type f | wc -l
}

# Calculator
calc() {
    echo "$*" | bc -l
}

# Get weather forecast
weather() {
    curl -s "wttr.in/${1:-}"
}

# Create a tar.gz archive
targz() {
    tar -zcvf "${1%%/}.tar.gz" "${1%%/}/"
}

# SSH with color and title
ssh() {
    echo -ne "\033]0;${@: -1}\007"
    command ssh "$@"
}

# ======================================================================
#                     ENVIRONMENT VARIABLES
# ======================================================================

export PATH="$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/bin"
export EDITOR=nano
export VISUAL=nano
export PAGER=less
export BROWSER=firefox
export TERM=xterm-256color
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# For Python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONSTARTUP=~/.pythonrc

# For Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# For Ruby
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

# For Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# For Android SDK
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# ======================================================================
#                     WELCOME MESSAGE & SYSTEM INFO
# ======================================================================

clear
echo -e "\033[1;34m$(figlet -f slant "Welcome Sunil")\033[0m"
echo -e "\033[1;32m$(date '+%A, %B %d %Y %H:%M:%S')\033[0m"
echo -e "\033[1;33mHostname: \033[1;37m$(hostname)\033[0m"
echo -e "\033[1;33mKernel: \033[1;37m$(uname -srm)\033[0m"
echo -e "\033[1;33mUptime: \033[1;37m$(uptime -p)\033[0m"
echo -e "\033[1;33mCPU: \033[1;37m$(grep 'model name' /proc/cpuinfo | head -1 | cut -d ':' -f2 | sed 's/^[ \t]*//')\033[0m"
echo -e "\033[1;33mMemory: \033[1;37m$(free -h | awk '/^Mem/ {print $3 "/" $2}')\033[0m"
echo -e "\033[1;33mDisk: \033[1;37m$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')\033[0m"
echo -e "\033[1;33mIP: \033[1;37m$(hostname -I | awk '{print $1}')\033[0m"
echo -e "\033[1;35mFollow me on GitHub: \033[1;36mgithub.com/prince4you\033[0m"
echo -e "\033[1;35mYouTube Channel: \033[1;36m@noobcybertech\033[0m"
echo -e "\033[1;31mType 'helpme' for quick command reference\033[0m"

# ======================================================================
#                     QUICK HELP FUNCTION
# ======================================================================

helpme() {
    echo -e "\n\033[1;34m=== QUICK COMMAND REFERENCE ===\033[0m"
    echo -e "\033[1;32mSystem Info:\033[0m"
    echo "  cpu       - Show process monitor (htop)"
    echo "  mem       - Show memory usage"
    echo "  disk      - Show disk usage"
    echo "  netstat   - Show network connections"
    echo "  myip      - Show public IP"
    
    echo -e "\n\033[1;32mFile Operations:\033[0m"
    echo "  extract   - Extract any compressed file"
    echo "  mcd       - Create and enter directory"
    echo "  bak       - Create backup of file"
    echo "  count     - Count files in directory"
    
    echo -e "\n\033[1;32mNetworking:\033[0m"
    echo "  ports     - Show listening ports"
    echo "  header    - Show HTTP headers"
    echo "  ping      - Ping with 5 packets"
    echo "  geoip     - Geolocate an IP"
    
    echo -e "\n\033[1;32mPackage Management:\033[0m"
    echo "  update    - Update package list"
    echo "  upgrade   - Upgrade all packages"
    echo "  install   - Install package"
    echo "  remove    - Remove package"
    
    echo -e "\n\033[1;32mMore Info:\033[0m"
    echo "  Type 'alias' to see all aliases"
    echo "  Type 'declare -f' to see all functions"
    echo -e "\033[1;34m===============================\033[0m"
}

# ======================================================================
#                     COMPLETION & FINAL SETUP
# ======================================================================

# Enable programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load local customizations
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_local ] && . ~/.bash_local

# Clear any existing notifications
notify-send "Terminal Ready" "Welcome back, Sunil!" -t 3000 2>/dev/null
