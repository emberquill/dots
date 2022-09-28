#!/usr/bin/env zsh

#---------------------
# Virtual Environments
#---------------------

function venv {
    if (( $# == 0 )); then
        python -m venv .venv
    elif (( $# == 1 )); then
        if [[ "$1" == "create" ]]; then
            python -m venv .venv
        elif [[ "$1" == "activate" ]]; then
            if [[ -d .venv ]]; then
                source .venv/bin/activate
            else
                source ~/.local/share/venvs/default/bin/activate
            fi
        else
            echo >&2 "Subcommand must be 'create' or 'activate'"
            return 1
        fi
    elif (( $# == 2 )); then
        if [[ "$1" == "create" ]]; then
            python -m venv ~/.local/share/venvs/$2
            echo "Created venv: $2"
        elif [[ "$1" == "activate" ]]; then
            source ~/.local/share/venvs/$2/bin/activate
        fi
    fi
}

[[ -d "$HOME/.local/share/venvs" ]] || mkdir $HOME/.local/share/venvs
[[ -d "$HOME/.local/share/venvs/default" ]] || venv create default
alias activate="venv activate"

#---------------
# Plugin Manager
#---------------

export ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
[[ ! -d $ZPLUGINDIR ]] && mkdir -p $ZPLUGINDIR && plugin-load $plugins

function plugin-load {
    local plugrepo plugdir initfile
    for plugrepo in $@; do
        plugdir=$ZPLUGINDIR/${plugrepo:t}
        initfile=$plugdir/${plugrepo:t}.plugin.zsh
        if [[ ! -d $plugdir ]]; then
            echo "Cloning $plugrepo..."
            git clone -q --depth=1 --recursive --shallow-submodules git@github.com:$plugrepo $plugdir
        fi
        if [[ ! -e $initfile ]]; then
            local -a initfiles=($plugdir/*.plugin.{z,}sh(N) $plugdir/*.{z,}sh{-theme,}(N))
            (( $#initfiles )) || { echo >&2 "No init file found '$plugrepo'." && continue }
            ln -sf "${initfiles[1]}" "$initfile"
        fi
        args=("$@")
        set --
        (( $+functions[zsh-defer] )) && zsh-defer source $initfile || source $initfile
        set -- "${args[@]}"
    done
}

function plugin-update {
    for d in $ZPLUGINDIR/*/.git(/); do
        echo "Updating ${d:h:t}..."
        command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
    done
}

function plugin-clean {
    rm -rf $ZPLUGINDIR/*
}