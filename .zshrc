#!/usr/bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(dircolors ~/.config/dotfiles/dir_colors)"

FPATH="$(echo ~/.local/bin/completions/zsh):$FPATH"

HISTFILE=~/.local/share/zsh/histfile
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
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

backward-soft-delete-word () {
   local WORDCHARS='~!#$%^&*(){}[]<>?+;'
   zle backward-delete-word
}
zle -N backward-soft-delete-word

soft-delete-word () {
   local WORDCHARS='~!#$%^&*(){}[]<>?+;'
   zle delete-word
}
zle -N soft-delete-word

soft-backward-word () {
   local WORDCHARS='~!#$%^&*(){}[]<>?+;'
   zle backward-word
}
zle -N soft-backward-word

soft-forward-word () {
   local WORDCHARS='~!#$%^&*(){}[]<>?+;'
   zle forward-word
}
zle -N soft-forward-word

bindkey "^[[H"      beginning-of-line
bindkey "^[[F"      end-of-line
bindkey "^[[3~"     delete-char
bindkey "^[[1;3D"   backward-word
bindkey "^[[1;5D"   soft-backward-word
bindkey "^[[1;3C"   forward-word
bindkey "^[[1;5C"   soft-forward-word
bindkey "^H"        backward-soft-delete-word
bindkey "^[[3;5~"   soft-delete-word
#bindkey -M menuselect '^[[Z' reverse-menu-complete

# Lines configured by zsh-newuser-install
unsetopt notify
# End of lines configured by zsh-newuser-install

P10K_OS_ICON_COLOR=7
os_name="$(uname)"
if [[ $os_name == "Linux" ]]; then
    if [[ -r /etc/os-release ]]; then
        local lines=(${(f)"$(</etc/os-release)"})
        local id_lines=(${(@M)lines:#ID=*})
        if [ $#id_lines -eq 1 ]; then
            local os_release_id=${id_lines[1]#ID=}
            case $os_release_id in
                *manjaro*)      P10K_OS_ICON_COLOR=048;;
                *debian*)       P10K_OS_ICON_COLOR=160;;
                *linuxmint*)    P10K_OS_ICON_COLOR=154;;
                *ubuntu*)       P10K_OS_ICON_COLOR=202;;
                *arch*)         P10K_OS_ICON_COLOR=039;;
                *raspbian*)     P10K_OS_ICON_COLOR=197;;
                *)              ;;
            esac
        fi
    fi
fi

source ~/.config/dotfiles/aliases
source ~/.config/dotfiles/exports

source ~/.local/share/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.local/share/zsh/p10k.zsh.
[[ ! -f ~/.local/share/zsh/p10k.zsh ]] || source ~/.local/share/zsh/p10k.zsh
