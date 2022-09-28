#!/usr/bin/env zsh

[[ "$(uname -s)" == "Darwin" ]] || return 0

unsetopt beep

# Update Homebrew and Dotfiles
function update() {
    echo "$(tput bold)==> $(tput setaf 4)Updating Homebrew$(tput sgr0)"
    brew update
    brew upgrade
    brew cleanup --prune=7
    dotupdate
}

# ------------
# iTerm2 Fixes
# ------------

# Fix delete key
bindkey "^[[3~" delete-char

# Word navigation
bindkey "[D" backward-word
bindkey "[C" forward-word

# Fix text encoding
export LC_ALL="en_US.UTF-8"

# Fix clear/reset commands
alias reset="reset && printf '\33c\e[3J'"
alias clear="clear && printf '\33c\e[3J'"
