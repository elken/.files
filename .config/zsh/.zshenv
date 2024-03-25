#!/usr/bin/env zsh

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Zellij setup
#eval "$(zellij setup --generate-completion zsh | grep "^function")"
#echo "$(zellij setup --generate-completion zsh | grep -v "^function")" >! "${ZDOTDIR:-$HOME}/completions/_zellij"
