HISTSIZE=10000
SAVEHIST=10000
HISTDIR=~/.hist && [ ! -e $HISTDIR ] && mkdir $HISTDIR
export HISTFILE=~/.hist/history.`date +%y%m%d%H%M`
export PATH=/usr/local/bin:/usr/local/mysql/bin:/usr/bin:/bin:/usr/sbin:/sbin
if [ -d "$HOME/bin" ]; then
  PATH=$HOME/bin:$PATH
fi
export LS_COLORS='di=01;36'
export LANG=ja_JP.UTF-8
export PAGER=less
export EDITOR=vim
export TERM=xterm-256color
export GREP_OPTIONS='--color=auto'
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
# go
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH
# direnv
eval "$(direnv hook zsh)"

LISTMAX=0
setopt auto_list
setopt auto_pushd
setopt list_packed
setopt nolistbeep
setopt append_history
setopt share_history
setopt magic_equal_subst
setopt ignore_eof
setopt NO_flow_control
setopt sh_word_split
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
setopt multios

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

alias -g L='less'
alias -g T='tail'
alias -g G='grep'
alias ll='ls -l'
alias ls='ls -w'
alias be='bundle exec'
alias bed='bundle exec rails dbconsole -p'
alias bec='bundle exec rails c'
alias bes='bundle exec rails s'
alias grep='grep -s'
alias g='git'
alias h='hub'
alias t='tig'

bindkey -e

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
PROMPT='[%n@local]# '
RPROMPT='[`rprompt-git-current-branch`%~ %*]'

__git_files () {
  _wanted files expl 'local files' _files
}

function reload()
{
  source ~/.zshrc
}

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

function ignore() {
  if [ $# -ne 1 ]; then
    echo "invalid argument"
    echo "ex) # ignore rails"
  else
    curl --silent https://www.gitignore.io/api/$@;
  fi
}

# http://blog.kenjiskywalker.org/blog/2014/06/12/peco/
function peco-select-history() {
  BUFFER=$(history -n 1 | \
    tail -r | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# http://weblog.bulknews.net/post/89635306479/ghq-peco-percol
function peco-src () {
  # set your PECO_SEARCH_PATHS
  # ex) $ PECO_SEARCH_PATHS=(~/*)
  local selected_dir=$(ls -df $PECO_SEARCH_PATHS | peco)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# http://qiita.com/naoty_k/items/93aa0f35aaa889f36d18
function prake () {
  local task=$(bundle exec rake -W -T | peco | cut -d " " -f 2)
  if [ -n "$task" ]; then
    echo "bundle exec rake ${task}"
    bundle exec rake ${task}
  fi
}

function b () {
  shift $((OPTIND-1))
  local QUERY="$*"
  echo $QUERY
  local selected_branch=$(git branch | cut -b 3- | peco --query "$QUERY")
  if [ -n "$selected_branch" ]; then
    echo "git checkout ${selected_branch}"
    git checkout ${selected_branch}
  fi
}

function cb () {
  local selected_branch=$(git branch -r | cut -b 3- | peco --query "$1")
  if [ -n "$selected_branch" ]; then
    local new_branch
    new_branch=(${(s:/:)selected_branch})
    echo "git checkout -b ${new_branch[2]} ${selected_branch}"
    git checkout -b ${new_branch[2]} ${selected_branch}
  fi
}

function ghistory () {
  # Usage: $ ghistory -f query1 query2
  local FORCE=false
  local UNIQ_HISTFILE=.uniq_zsh_history
  local FIND_CMD="tmp=$LC_ALL;
    export LC_ALL=C;
    find $HISTDIR/ -type f | xargs cat | sort | sed -e 's/	//g' -e 's/ *$//' -e '/^: /d' | uniq > $HOME/$UNIQ_HISTFILE;
    export LC_ALL=$tmp;"

  while getopts "f" opt; do
    case $opt in
      f)
        FORCE=true
        ;;
    esac
  done

  if [ ! -e "$HOME/$UNIQ_HISTFILE" ]; then
    FORCE=true
  fi

  echo -n "\033[5;37mLoading...\033[0;39m\n"

  if $FORCE ; then
    zsh -c "$FIND_CMD"
  else
    find ~/ -name "$UNIQ_HISTFILE" -maxdepth 1 -mmin +1440 -exec zsh -c "$FIND_CMD" \;
  fi

  shift $((OPTIND-1))
  local QUERY="$*"

  cat $HOME/$UNIQ_HISTFILE | peco --query "$QUERY"
}

# http://qiita.com/fmy/items/b92254d14049996f6ec3
function agvim () {
  vim $(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}

function rebuild-ssh-config()
{
  local backup=0
  local ssh_dir=$HOME/.ssh
  local ssh_config=$ssh_dir/config
  local ssh_config_backup=$ssh_config`date +%y%m%d%H%M`.bk
  if [ ! -e $ssh_config_backup ]; then
    backup=1
  else
    diff $ssh_config $ssh_config_backup
    if [ ! $? -eq 0 ]; then
      backup=1
    fi
  fi

  if [ ! $backup -eq 0 ]; then
    cp $ssh_config $ssh_config_backup
    echo "backup $ssh_config to $ssh_config_backup"
  fi

  local ssh_confd__dir=$ssh_dir/conf.d

  cat $ssh_confd__dir/config $ssh_confd__dir/*.config > $ssh_config
}

AWS_CLI_COMPLETION=/usr/local/share/zsh/site-functions/_aws && [ -e $AWS_CLI_COMPLETION ] && source $AWS_CLI_COMPLETION

# local settings
LOCAL_ZSHRC=~/.zshrc.local && [ -e $LOCAL_ZSHRC ] && source $LOCAL_ZSHRC

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
OH_MY_ZSH=$ZSH/oh-my-zsh.sh
if [ -e $OH_MY_ZSH ]; then
  source $ZSH/lib/completion.zsh
  plugins=(
    brew
    brew-cask
    xcode
    urltools
    vagrant
    gem
    pod
  )
  for plugin ($plugins); do
    local alias_plugin_name=$ZSH/plugins/$plugin/$plugin.plugin.zsh
    if [ -e $alias_plugin_name ]; then
      source $alias_plugin_name
    fi
    fpath=($ZSH/plugins/$plugin $fpath)
  done;
fi

fpath=($HOME/.zsh/functions $fpath)

autoload -U compinit
compinit -u

autoload -U colors
colors
