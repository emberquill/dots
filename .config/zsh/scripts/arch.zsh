#!/usr/bin/env zsh

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
