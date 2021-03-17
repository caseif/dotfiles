#!/usr/bin/env bash

force=0

while getopts f opt; do
    case $opt in
        f ) force=1 ;;
        ? ) exit    ;;
    esac
done

make_link() {
    wd=$(pwd)
    if [ $force -eq 1 ];
    then
        ln -sf $wd/$1 ~/$1
    else
        ln -s $wd/$1 ~/$1
    fi
}

make_link .alias
make_link .bashrc
make_link .export
make_link .gitconfig
make_link .local/bin/sd
make_link .local/bin/sd-completion.bash
make_link .nanorc
make_link .profile
make_link .sd
