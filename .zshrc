# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(dircolors ~/.dir_colors)"

FPATH="$(echo ~/.local/bin/completions/zsh):$FPATH"

# The following lines were added by compinstall

#zstyle ':completion:*' insert-unambiguous false
#zstyle ':completion:*' original true
#zstyle :compinstall filename '/home/max/.zshrc'

#autoload -Uz compinit
#compinit
# End of lines added by compinstall

HISTFILE=~/.zhistfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

setopt extendedglob

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors $LS_COLORS

zmodload -a colors
zmodload -a autocomplete
zmodload -a complist

autoload -Uz compinit
compinit

bindkey "^[[H"      beginning-of-line
bindkey "^[[F"      end-of-line
bindkey "^[[3~"     delete-char
bindkey "^[[1;3D"   backward-word
bindkey "^[[1;5D"   backward-word
bindkey "^[[1;3C"   forward-word
bindkey "^[[1;5C"   forward-word
bindkey "^H"        backward-kill-word
bindkey "^[[3;5~"   kill-word
#bindkey -M menuselect '^[[Z' reverse-menu-complete

# Lines configured by zsh-newuser-install
unsetopt notify
# End of lines configured by zsh-newuser-install

source ~/.alias
source ~/.export

source ~/.zplugins/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
