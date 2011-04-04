export HISTFILE=~/.hist/history.`date +%y%m%d%H%M`

HISTSIZE=10000
SAVEHIST=10000

export PATH=/opt/local/bin:/usr/local/bin:/usr/local/mysql/bin:$PATH
export PATH=/Applications/android_sdk/tools:$PATH
export LS_COLORS='di=01;36'
#LANG=C
#LANG=ja_JP.UTF-8
export PAGER=less
export TERM=xterm
autoload -U compinit
compinit -u

autoload -U colors
colors

LISTMAX=0
setopt auto_list
setopt auto_pushd
setopt list_packed
setopt nolistbeep
setopt append_history
setopt magic_equal_subst
setopt ignore_eof
setopt NO_flow_control
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
setopt multios

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

alias -g L='less'
alias -g T='tail'
alias -g G='grep'
alias vi='vim'
alias ll="ls -l"
alias ls="ls -w"

bindkey -e

PROMPT='[%n@%m]# '
RPROMPT='[%~ %*]'


function pcolor() {
    for ((f = 0; f < 255; f++)); do
        printf "\e[38;5;%dm %3d#\e[m" $f $f
        if [[ $f%8 -eq 7 ]] then
            printf "\n"
        fi
    done
    echo
}

if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi
