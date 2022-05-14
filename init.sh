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
    local rel_path=$1
    local recursive_call=${2:-0}

    verbose "Attempting to generate link for '$rel_path'"

    target="$(pwd)/$rel_path" link="$HOME/" link_dir="$HOME/"
    target_dir+=$(dirname $rel_path)
    in_subdir=0
    if [ ! $target_dir == "." ]; then
        verbose "Target '$rel_path' is in subdirectory"
        link_dir+="$target_dir"
        in_subdir=1
    fi

    link+=$rel_path

    if [ -f "$link" ] && [ ! -L "$link" ] && [ $force -eq 0 ]; then
        info "'$rel_path' already exists in home directory as regular file; refusing to overwrite. Re-run with -f to force overwrite."
        return
    fi

    overwrite_link=0
    if [ -L "$link" ] && [ $force -eq 0 ]; then
        if [ -d "$link" ] && [ $recursive_call -eq 1 ]; then
            verbose "'$rel_path' exists in home directory as directory symlink but we're running recursively; returning early"
            return
        fi

        verbose "'$rel_path' exists in home directory as symlink; overwriting."
        overwrite_link=1
    fi

    if [ -d "$target" ] && [ $force -eq 1 ]; then
        verbose "Force-removing existing directory '$target'"
        rm -rf "$target"
    fi

    if [ $in_subdir -eq 1 ]; then
        verbose "Recursively generating parent directories for link '$link'"
        mkdir -p "$link_dir"
    fi

    if [ $force -eq 1 ] || [[ $overwrite_link -eq 1 ]]; then
        verbose "Force-generating link '$link' to target '$target'"
        if [ -d "$link" ]; then
            ln -sf $target $link_dir
        else
            ln -sf $target $link
        fi
    else
        verbose "Generating link '$link' to target '$target'"
        if [ -d "$link" ]; then
            ln -s $target $link_dir
        else
            ln -s $target $link
        fi
    fi

    unset target target_dir link link_dir in_subdir

    verbose "Done generating link for '$rel_path'"
    verbose "------------------------------------------------"
}

make_links_recursively() {
    local rel_path=$1

    verbose "Recursively generating links for '$rel_path'"

    target="$(pwd)/$rel_path"
    link="$HOME/$rel_path"

    if [ -L "$link" ] && [ -d "$link" ]; then
        verbose "Skipping $target (already exists as a directory symlink)"
        return
    fi

    if [ -f "$target" ]; then
        make_link $rel_path 1
        return
    fi

    for child in $target/*; do
        [ -e "$child" ] || continue

        child_base=$(basename $child)
        verbose "Recursing with $rel_path/$child_base"
        make_links_recursively "$rel_path/$child_base"
    done
}

make_link .bashrc
make_link .zshrc
make_link .local/share/sd
make_link .local/share/zsh/plugins/powerlevel10k

make_links_recursively .config
make_links_recursively .local
