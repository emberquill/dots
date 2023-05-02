#!/usr/bin/env zsh

# Configures various tools to store files in XDG-specified directories

if (( $+commands[aws] )); then
    export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
    export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
fi

(( $+commands[pyenv] )) && export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
(( $+commands[sqlite3] )) && export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"
(( $+commands[oci] )) && export OCI_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/oci/config"

export LESSHISTFILE="$XDG_STATE_HOME/less/history"
