#!/usr/bin/env zsh

function venv() {
    if (( $# == 0 )); then
        python -m venv .venv
    elif (( $# == 1 )); then
        if [[ "$1" == "create" ]]; then
            python -m venv .venv
        elif [[ "$1" == "activate" ]]; then
            if [[ -d .venv ]]; then
                source .venv/bin/activate
            else
                source ~/.venvs/default/bin/activate
            fi
        else
            echo "Subcommand must be 'create' or 'activate'"
            return 1
        fi
    elif (( $# == 2 )); then
        if [[ "$1" == "create" ]]; then
            python -m venv ~/.venvs/$2
        elif [[ "$1" == "activate" ]]; then
            source ~/.venvs/$2/bin/activate
        fi
    fi
}

[[ -d "$HOME/.venvs" ]] || mkdir $HOME/.venvs
alias activate="venv activate"
