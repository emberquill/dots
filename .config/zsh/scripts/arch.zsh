if (( $+commands[rankmirrors] )); then
    alias mirrors="curl -s 'https://archlinux.org/mirrorlist/?country=US&country=CA&protocol=https&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 20 - | sudo tee /etc/pacman.d/mirrorlist"
fi
