# Load SSH/GPG keys
eval "$(keychain --eval --quiet --agents ssh,gpg ~/.ssh/git)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/prezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/prezto/init.zsh"
fi

# Command-not-found sucks

[ -e /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh

unset GREP_OPTIONS

# Customize to your needs...
setopt no_hist_verify
setopt HIST_IGNORE_DUPS

source $HOME/.aliases
export PANEL_FIFO="/tmp/panel-fifo"
export CHROOT="$HOME/chroot"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export PULSE_LATENCY_MSEC=120
export WEBKIT_FORCE_SANDBOX=0
export WEBKIT_DISABLE_COMPOSITING_MODE=1

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export ZSH_AUTOSUGGEST_USE_ASYNC=1

set ZLE_RPROPT_INDENT=1

eval `dircolors ~/.dircolors`
# eval "$(fasd --init zsh-hook zsh-ccomp auto)"
eval "$(direnv hook zsh)"

setopt no_hist_verify

for i in k.sh notifyosd.zsh; do
    [ -e $HOME/.config/zsh/$i ] && . $HOME/.config/zsh/$i
done

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/p10k.zsh.
[[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh

[[ "$INSIDE_EMACS" = 'vterm' ]] && . ~/.config/zsh/vterm.zsh

[ -e ~/.guix-profile ] && . ~/.guix-profile/etc/profile

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS="--height=40% --preview='bat {}' --preview-window=right:60%:wrap"

# NVM

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# opam configuration
[[ ! -r /home/elken/.opam/opam-init/init.zsh ]] || source /home/elken/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

if [[ -e ~/.config/zsh/autopair ]]; then
  source ~/.config/zsh/autopair/autopair.zsh
  autopair-init
fi

unalias p

fpath+=("${ZDOTDIR:-$HOME}/completions")

test -e ~/.rbenv/bin/rbenv && eval "$(~/.rbenv/bin/rbenv init - zsh)"
test -e $(which zoxide) && eval "$(zoxide init zsh)"
