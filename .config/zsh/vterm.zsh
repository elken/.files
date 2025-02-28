#!/usr/bin/env zsh

vterm_printf() {
    # update buffer title
    print -Pn "\e]2;%2~\a"

    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi

}

vterm_prompt_end() {
    prompt_end=$(vterm_printf "51;A$USER@$HOST:$PWD")
    PROMPT="$PROMPT%{$prompt_end%}"
}

autoload -U add-zsh-hook
add-zsh-hook precmd vterm_prompt_end
add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }

vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

find_file() {
    vterm_cmd find-file "$(realpath "${@:-.}")"
}

magit_current(){
    vterm_cmd magit-status "$(realpath "${@:-.}")"
}

woman () {
    vterm_cmd woman $1
}

dired () {
    vterm_cmd dired "$(realpath "${@:-.}")"
}

alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
alias mg='magit_current'
alias man='woman'
alias fm='dired'
