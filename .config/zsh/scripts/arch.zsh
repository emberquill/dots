#!/usr/bin/env zsh

[[ -f "/etc/arch-release" ]] || return 0

if (( $+commands[rankmirrors] )); then
    function mirrors {
        local country
        if (( $# == 0 )); then
            country="US"
        else
            country=$1
        fi
        curl -s "https://archlinux.org/mirrorlist/?country=$country&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 20 - | sudo tee /etc/pacman.d/mirrorlist
    }
fi

alias aurto="ssh -t aurto aurto"
alias aur="ssh -t aurto aur"

function checkup {
    checkupdates
    (( $+commands[aur-check-updates] )) && aur-check-updates || echo "aur-check-updates not installed, skipping AUR" >&2
    (( $+commands[checkrebuild] )) && checkrebuild -v || echo "rebuild-detector not installed, skipping AUR rebuilds" >&2
}
