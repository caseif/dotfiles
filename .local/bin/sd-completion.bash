#!/usr/bin/env bash

_sd_completion() {
    wd="~/.sd/"

    start_index=1
    if [ "${COMP_WORDS[1]}" == "help" ]; then
        start_index=2
    fi

    for ((i=$start_index; i<${#COMP_WORDS[@]}-1; i++)); do
        arg=${COMP_WORDS[$i]}
        wd+="$arg/"
    done

    wd="$(eval echo "$wd")"

    local cur;
    local base="$wd"
    _get_comp_words_by_ref cur;
    orig_cur="$cur"
    cur="$base$cur"
    _filedir

    remove=()
    for i in "${!COMPREPLY[@]}"; do
        script="${COMPREPLY[$i]}"
        if [[ $script == */ ]]; then
            script=${script:0:${#script}-1}
            $COMPREPLY[$i]="$script"
        fi
        
        if [[ $script == *.help ]]; then
            remove+=("$script")
        fi
    done

    for del in "${remove[@]}"; do
        COMPREPLY=("${COMPREPLY[@]/$del}")
    done
    
    COMPREPLY=("${COMPREPLY[@]#$base}")

    if [ ${#COMP_WORDS[@]} -eq 2 ]; then
        COMPREPLY+=("help")
    fi
} && complete -F _sd_completion sd
