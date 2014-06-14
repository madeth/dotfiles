export HISTFILE=~/.hist/history.`date +%y%m%d%H%M`

HISTSIZE=10000
SAVEHIST=10000

export PATH=$HOME/app/local/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/bin:/bin:/usr/sbin:/sbin
export LS_COLORS='di=01;36'
export LANG=ja_JP.UTF-8
export PAGER=less
export LDFLAGS="-L/usr/local/Cellar/libiconv/1.14/lib"
export CPPFLAGS="-I/usr/local/Cellar/libiconv/1.14/include"
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
export TERM=xterm-256color
export GREP_OPTIONS='--color=auto'

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
alias ll="ls -l"
alias ls="ls -w"
alias be="bundle exec"
alias bed="bundle exec rails dbconsole"
alias bec="bundle exec rails c"
alias bes="bundle exec rails s"
alias grep='grep -s'

bindkey -e

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

function pcolor() {
    for ((f = 0; f < 255; f++)); do
        printf "\e[38;5;%dm %3d#\e[m" $f $f
        if [[ $f%8 -eq 7 ]] then
            printf "\n"
        fi
    done
}

function rprompt-git-current-branch {
    local name st color

    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
            return
    fi
    name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
    if [[ -z $name ]]; then
            return
    fi
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
            color=${fg[green]}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
            color=${fg[yellow]}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
            color=${fg_bold[red]}
    else
            color=${fg[red]}
    fi

    # %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
    # これをしないと右プロンプトの位置がずれる
    echo "%{$color%}$name%{$reset_color%} "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
PROMPT='[%n@local]# '
RPROMPT='[`rprompt-git-current-branch`%~ %*]'

function psg() {
  ps aux | head -n 1
  if [ ${#1} -gt 0 ]; then
    ps aux | grep $1
  fi
}

function regions() {
cat <<EOF
tokyo     ap-northeast-1  ec2.ap-northeast-1.amazonaws.com

calfornia us-west-1       ec2.us-west-1.amazonaws.com
oregon    us-west-2       ec2.us-west-2.amazonaws.com
ireland   eu-west-1       ec2.eu-west-1.amazonaws.com
sao paulo sa-east-1       ec2.sa-east-1.amazonaws.com
virginia  us-east-1       ec2.us-east-1.amazonaws.com
singap    ap-southeast-1  ec2.ap-southeast-1.amazonaws.com
EOF
}

function curl-head() {
  if [ $# -ne 1 ]; then
    echo "invalid argument"
    echo "ex) # curl-head URL"
  else
    curl -LI $1
  fi
}

function curl-download {
  if [ $# -ne 2 ]; then
    echo "invalid arguments"
    echo "ex) # curl-download URL LOCALFILE"
  else
    curl -L -o $2 $1
  fi
}

function curl-json {
  if [ $# -ne 2 ]; then
    echo "invalid arguments"
    echo "ex) # curl-json URL FILTER"
  else
    curl -s $1 | jq $2
  fi
}

function json-pp {
  ruby -r json -e 'jj(JSON.parse!(STDIN.read))'
}

__git_files () { 
  _wanted files expl 'local files' _files     
}
function gi() { curl http://gitignore.io/api/$@ ;}
