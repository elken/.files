export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# sheldon — cached source, regenerate when plugins.toml changes
() {
  local f="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/sheldon.zsh"
  [[ -f "$f" && "$f" -nt ~/.config/sheldon/plugins.toml ]] || sheldon source >| "$f"
  source "$f"
}

autoload -Uz compinit
compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"

# options
autoload -Uz zmv
bindkey -e

setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt SHARE_HISTORY EXTENDED_HISTORY NO_HIST_VERIFY
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.config/zsh/.zsh_history"

setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt EXTENDED_GLOB NO_CASE_GLOB
unsetopt BEEP
unset GREP_OPTIONS

source ~/.config/zsh/completion.zsh
fpath+=("$HOME/.config/zsh/completions")

# tools
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS="--height=40% --preview='bat {}' --preview-window=right:60%:wrap"

zstyle ':fzf-tab:complete:*' fzf-preview 'bat --color=always --style=plain $realpath 2>/dev/null || ls --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'

# Cached hook outputs — regenerate only when source file/binary changes
# Force refresh: rm ~/.cache/zsh/*.zsh
() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  [[ -d "$cache_dir" ]] || mkdir -p "$cache_dir"

  local f

  f="$cache_dir/direnv-hook.zsh"
  if (( $+commands[direnv] )); then
    [[ -f "$f" && "$f" -nt "$commands[direnv]" ]] || direnv hook zsh >| "$f"
    source "$f" || { print -u2 "[zsh] direnv cache corrupt, regenerating"; rm -f "$f"; direnv hook zsh >| "$f" && source "$f"; }
  fi

  f="$cache_dir/zoxide-init.zsh"
  if (( $+commands[zoxide] )); then
    [[ -f "$f" && "$f" -nt "$commands[zoxide]" ]] || zoxide init zsh >| "$f"
    source "$f"
  fi

  f="$cache_dir/mise-activate.zsh"
  if (( $+commands[mise] )); then
    [[ -f "$f" && "$f" -nt "$commands[mise]" ]] || mise activate zsh >| "$f"
    source "$f"
  fi

  f="$cache_dir/gh-completion.zsh"
  if (( $+commands[gh] )); then
    [[ -f "$f" && "$f" -nt "$commands[gh]" ]] || gh completion -s zsh >| "$f"
    source "$f"
  fi

  f="$cache_dir/nord-dircolors.zsh"
  local nord_src="${XDG_DATA_HOME:-$HOME/.local/share}/sheldon/repos/github.com/nordtheme/dircolors/src/dir_colors"
  if (( $+commands[dircolors] )) && [[ -f "$nord_src" ]]; then
    [[ -f "$f" && "$f" -nt "$nord_src" ]] || dircolors -b "$nord_src" >| "$f"
    source "$f"
    zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}"
  fi
}

# local
source "$HOME/.aliases"

source ~/.config/zsh/notifyosd.zsh
alias p > /dev/null 2>&1 && unalias p

# terminal title — show running command during execution, directory at prompt
if [[ $TERM != (dumb|linux) && -z $INSIDE_EMACS ]]; then
  function _title_preexec() {
    local cmd="${${1[(w)1]}:t}"
    print -Pn "\e]2;${cmd}\a"
  }
  function _title_precmd() {
    print -Pn "\e]2;%~\a"
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _title_preexec
  add-zsh-hook precmd _title_precmd
fi

# conditional
[[ -e ~/.guix-profile ]] && source ~/.guix-profile/etc/profile
[[ -r ~/.opam/opam-init/init.zsh ]] && source /home/elken/.opam/opam-init/init.zsh > /dev/null 2>&1
[[ -e /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
[[ -e ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh
[[ "$INSIDE_EMACS" == vterm ]] && source ~/.config/zsh/vterm.zsh
