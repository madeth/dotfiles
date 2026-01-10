if (( $+commands[fzf] )); then
  zsh-defer source <(fzf --zsh)
  export FZF_DEFAULT_OPTS='
    --height 80%
    --reverse
    --border
  '
  export FZF_DEFAULT_COMMAND='fd --type f'
  export FZF_CTRL_T_COMMAND='fd --type f'
  export FZF_ALT_C_COMMAND='fd --type d'
fi