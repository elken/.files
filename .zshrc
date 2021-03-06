SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     setopt null_glob
     rm -rf "${SSH_ENV}"
     echo "Initialising new SSH agent..."
     ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     for i in ~/.ssh/*.pub; do
        ssh-add $(echo $i | cut -d. -f-2)
     done
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else     
     start_agent;
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Command-not-found sucks

[ -e /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh

unset GREP_OPTIONS

# Customize to your needs...
# autoload -Uz promptinit
# promptinit
# prompt pure
source ~/.zprofile
source $HOME/.aliases
export PANEL_FIFO="/tmp/panel-fifo"
export CHROOT="$HOME/chroot"
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export PULSE_LATENCY_MSEC=120
setopt no_hist_verify
setopt HIST_IGNORE_DUPS

set ZLE_RPROPT_INDENT=1

eval "$(fasd --init zsh-hook zsh-ccomp auto)"

eval `dircolors ~/.dircolors`

setopt no_hist_verify

vim_ins_mode="INSERT"
vim_cmd_mode="NORMAL"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
      zle reset-prompt

}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode

}
zle -N zle-line-finish

function TRAPINT() {
  vim_mode=$vim_ins_mode
    return $(( 128 + $1  ))

}

for i in artisan.zsh agnoster.zsh k.sh notifyosd.zsh; do
    [ -e $HOME/.zsh/$i ] && . $HOME/.zsh/$i
done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ "$INSIDE_EMACS" = 'vterm' ]] && . ~/.zsh/vterm.zsh

[ -e ~/.guix-profile ] && . ~/.guix-profile/etc/profile
