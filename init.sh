#!/usr/bin/env bash

force=0
quiet=0
verbose=0

while getopts fqv opt; do
    case $opt in
        f ) force=1     ;;
        q ) quiet=1     ;;
        v ) verbose=1   ;;
        ? ) exit        ;;
    esac
done

info() {
    if [ $quiet -eq 0 ]; then
        echo $1
    fi
}

err() {
    >&2 echo $1
}

verbose() {
    if [ $verbose -eq 1 ]; then
        echo $1
    fi
}


if [ $quiet -eq 1 ] && [ $verbose -eq 1 ]; then
    err "Cannot specify quiet and verbose at the same time"
    exit 1
fi

make_link() {
    verbose "Attempting to generate link for '$1'"

    target="$(pwd)/$1" link="$HOME/" link_dir="$HOME/"
    target_dir+=$(dirname $1)
    in_subdir=0
    if [ ! $target_dir == "." ]; then
        verbose "Target '$1' is in subdirectory"
        link_dir+="$target_dir"
        in_subdir=1
    fi

    link+=$1

    if [ -f "$link" ] && [ ! -L "$link" ] && [ $force -eq 0 ]; then
        info "'$1' already exists in home directory as regular file; refusing to overwrite. Re-run with -f to force overwrite."
        return
    fi

    overwrite_link=0
    if [ -L "$link" ] && [ $force -eq 0 ]; then
        verbose "'$1' exists in home directory as symlink; overwriting."
        overwrite_link=1
    fi

    if [ -d "$target" ] && [ $force -eq 1 ]; then
        verbose "Force-removing existing directory '$target'"
        rm -rf "$link"
    fi

    if [ $in_subdir -eq 1 ]; then
        verbose "Recursively generating parent directories for link '$link'"
        mkdir -p "$link_dir"
    fi

    if [ $force -eq 1 ] || [[ $overwrite_link -eq 1 ]]; then
        verbose "Force-generating link '$link' to target '$target'"
        ln -sf $target $link
    else
        verbose "Generating link '$link' to target '$target'"
        ln -s $target $link
    fi

    unset target target_dir link link_dir in_subdir

    verbose "Done generating link for '$1'"
    verbose "------------------------------------------------"
}

make_link .alias
make_link .bashrc
make_link .dir_colors
make_link .export
make_link .gitconfig
make_link .nanorc
make_link .p10k.zsh
make_link .profile
make_link .sd
make_link .zplugins
make_link .zshrc

make_link .config/plasma-workspace/env/exports.sh
make_link .config/plasma-workspace/env/mixed_rr.sh

make_link .local/bin/sd
make_link .local/bin/completions/bash/_sd
make_link .local/bin/completions/zsh/_sd
make_link .local/share/applications/visual-studio-code.desktop
make_link .local/share/applications/visual-studio-code-url-handler.desktop
