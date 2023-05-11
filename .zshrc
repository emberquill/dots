# zshrc
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob histignorespace nomatch notify nopromptbang nopromptsubst promptpercent
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# ------------------
# Keyboard Shortcuts
# ------------------

typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# ---------------------------------
# Environment Variables and Aliases
# ---------------------------------

path=("$HOME/.local/bin" $path)

if (( $+commands[go] )); then
    export GOPATH="$XDG_DATA_HOME/go"
    export GOBIN="$GOPATH/bin"
    path=($GOBIN $path)
fi

export PATH

if (( $+commands[nvim] )); then
    export DIFFPROG="nvim -d"
    export EDITOR="nvim"
    alias vi="nvim"
    alias vim="nvim"
else
    export EDITOR="vim"
    alias vi="vim"
fi
export VISUAL="$EDITOR"

if (( $(less --version | head -n1 | cut -d' ' -f2) < 581 )); then
    man() {
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        command man "$@"
    }
else
    export MANPAGER="less -R --use-color -Dd+r -Du+b"
fi
export GPG_TTY=$(tty)
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"

if (( $+commands[exa] )); then
    alias ls="exa --git --group-directories-first"
else
    alias ls="ls --color=auto --group-directories-first"
fi

if (( $+commands[bat] )); then
    function cht() {
        curl -s "https://cht.sh/$1" | bat -p
    }
else
    function cht() {
        curl -s "https://cht.sh/$1" | less
    }
fi

alias la="ls -a"
alias ll="ls -al"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias dot="/usr/bin/git --git-dir=$XDG_CONFIG_HOME/dotfiles/ --work-tree=$HOME"
alias tf="terraform"

function dotupdate() {
    echo "$(tput bold)==> $(tput setaf 4)Updating dotfiles$(tput sgr0)"
    dot pull
    plugin-update
    echo "$(tput bold)==> $(tput setaf 4)Updating nvim plugins$(tput sgr0)"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'TSUpdateSync' -c 'PackerSync'
}

# Use GPG Agent to cache SSH Keys
if (( ! ${+SSH_TTY} )); then
    unset SSH_AGENT_PID
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    gpg-connect-agent -q /bye >/dev/null
    (( $(ssh-add -l | wc -l) == 0 )) && ssh-add
fi

if (( $+commands[aws_completer] )); then
    autoload -Uz bashcompinit && bashcompinit
    complete -C aws_completer aws
fi

# -------------------------
# Plugins and Local Scripts
# -------------------------

# Load Local Scripts
for scr in $XDG_CONFIG_HOME/zsh/scripts/*.zsh; do
    source $scr
done

# Load Plugins
plugins=(
    romkatv/gitstatus
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    zsh-users/zsh-syntax-highlighting
)

plugin-load $plugins

# ------
# Prompt
# ------

(( $EUID == 0 )) && PROMPT_USER="%F{red}%B%n%b " || PROMPT_USER=""
[[ -n "$SSH_TTY" ]] && PROMPT_HOST="%F{magenta}%B%m%b " || PROMPT_HOST=""

function my_prompt() {
    local LASTEXITCODE="$?"
    PROMPT="${PROMPT_USER}${PROMPT_HOST}"
    RPROMPT=" [%*]"

    # Window Title
    print -Pn '\e]2;%n@%m: %~\a'

    # Working Directory and Venv
    PROMPT+="%F{blue}%~"
    if [[ -n $VIRTUAL_ENV ]]; then
        PROMPT+=$' %F{yellow}\uf423'
        if [[ "$(dirname "$VIRTUAL_ENV")" == "$XDG_DATA_HOME/venvs" ]]; then
            PROMPT+=" $(basename "$VIRTUAL_ENV")"
        else
            PROMPT+=" $(basename "$(dirname "$VIRTUAL_ENV")")"
        fi
    fi

    # Git Status
    if gitstatus_query MY && [[ $VCS_STATUS_RESULT == ok-sync ]]; then
        prompt+=$' %F{cyan}\ue0a0'"${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%}"
        [[ -n $VCS_STATUS_TAG ]] && PROMPT+=$' \uf02b '"${VCS_STATUS_TAG}"
        (( $VCS_STATUS_COMMITS_AHEAD != 0 )) && PROMPT+=$' %F{green}\uf431'"${VCS_STATUS_COMMITS_AHEAD}%f"
        (( $VCS_STATUS_COMMITS_BEHIND != 0 )) && PROMPT+=$' %F{red}\uf433'"${VCS_STATUS_COMMITS_BEHIND}%f"
        (( $VCS_STATUS_HAS_STAGED != 0 )) && PROMPT+=$' %F{green}\uf111%f'
        (( $VCS_STATUS_HAS_UNSTAGED != 0 )) && PROMPT+=$' %F{yellow}\ueb59%f'
        (( $VCS_STATUS_HAS_UNTRACKED != 0 )) && PROMPT+=$' %F{magenta}\uf067%f'
        (( $VCS_STATUS_STASHES != 0 )) && PROMPT+=$' %F{blue}\U000f0403 '$VCS_STATUS_STASHES
    fi

    # Arrow color and exit code
    if (( $LASTEXITCODE == 0 )); then
        PROMPT+=$'\n%F{magenta}'
    else
        PROMPT+=$'\n%F{red}'
        RPROMPT=" %F{red}%B${LASTEXITCODE}%b%f${RPROMPT}"
    fi

    PROMPT+=$'%B\u276f%b%f '
}

autoload -Uz add-zsh-hook
(( $+functions[gitstatus_query] )) && gitstatus_stop MY && gitstatus_start MY
add-zsh-hook precmd my_prompt
