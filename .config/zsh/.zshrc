# zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ -d $ZINIT_HOME ]] || git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
typeset -A ZINIT
ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
source "${ZINIT_HOME}/zinit.zsh"

# Nord-themed zinit output colors
ZINIT[col-note]=$'\e[38;5;110m'    # Nord8  frost blue
ZINIT[col-error]=$'\e[38;5;167m'   # Nord11 aurora red
ZINIT[col-success]=$'\e[38;5;150m' # Nord14 aurora green
ZINIT[col-pname]=$'\e[38;5;111m'   # Nord9  frost blue
ZINIT[col-uname]=$'\e[38;5;110m'   # Nord8  frost blue
ZINIT[col-rst]=$'\e[0m'

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# plugins
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1

zinit ice wait lucid \
  atclone"dircolors -b src/dir_colors > clrs.zsh" \
  atpull'%atclone' \
  pick"clrs.zsh" \
  nocompile'!' \
  atload'zstyle ":completion:*:default" list-colors "${(s.:.)LS_COLORS}"'
zinit light nordtheme/dircolors

zinit ice wait lucid light-mode \
  blockf atpull"zinit creinstall -q ."
zinit light zsh-users/zsh-completions

zinit ice from"gh-r" as"program"
zinit light junegunn/fzf-bin

zinit ice wait lucid light-mode
zinit light Aloxaf/fzf-tab

zinit ice wait lucid light-mode \
  atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid light-mode \
  atload'
    bindkey "^[[A" history-substring-search-up
    bindkey "^[OA" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
    bindkey "^[OB" history-substring-search-down
  '
zinit light zsh-users/zsh-history-substring-search

zinit ice wait lucid light-mode
zinit light hlissner/zsh-autopair

zinit ice wait lucid light-mode
zinit light MichaelAquilina/zsh-you-should-use

# programs
zinit ice wait lucid from"gh-r" as"command" \
  mv"bat-*/bat -> bat" \
  atclone"cp bat-*/autocomplete/bat.zsh _bat" \
  atpull'%atclone' \
  atload"fpath+=($PWD)"
zinit light sharkdp/bat

zinit ice wait lucid from"gh-r" as"command" \
  mv"fd-*/fd -> fd" \
  atclone"cp fd-*/autocomplete/_fd ." \
  atpull'%atclone' \
  atload"fpath+=($PWD)"
zinit light sharkdp/fd


zinit ice wait lucid as"program" \
  pick"yank" make
zinit light mptre/yank

zinit ice wait lucid light-mode \
  compile"*.zsh"
zinit light zdharma-continuum/fast-syntax-highlighting

# additional plugins
zinit ice wait lucid \
  pick"h.sh"
zinit light paoloantinori/hhighlighter

zinit ice wait lucid
zinit light voronkovich/gitignore.plugin.zsh

zinit ice wait lucid light-mode
zinit light jirutka/zsh-shift-select

zinit ice wait lucid light-mode
zinit light ael-code/zsh-colored-man-pages

zinit ice wait lucid light-mode
zinit light oz/safe-paste

zinit ice wait lucid light-mode
zinit light reegnz/jq-zsh-plugin

zinit ice wait lucid light-mode
zinit light le0me55i/zsh-extract

zinit ice wait lucid light-mode
zinit light 3v1n0/zsh-bash-completions-fallback

# completions
zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

zinit ice wait lucid; zinit snippet OMZP::rust
zinit ice wait lucid; zinit snippet OMZP::golang
zinit ice wait lucid; zinit snippet OMZP::yarn
zinit ice wait lucid; zinit snippet OMZP::flutter
zinit ice wait lucid; zinit snippet OMZP::dotnet
zinit ice wait lucid; zinit snippet OMZP::kubectl

zicompinit -C; zicdreplay

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
}

# zinit update indicator — RPROMPT shows ↻ (N) when updates are available.
# Checks weekly via background git fetch of all plugin repos; count is cached so
# the precmd hook is instant. Run `zup` to update and re-trigger a fresh check.
# Force reset: rm ~/.cache/zsh/zinit-last-check ~/.cache/zsh/zinit-update-count
typeset -g _zinit_check_triggered=0
_zinit_stamp="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zinit-last-check"
_zinit_count_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zinit-update-count"

_zinit_fetch_count() {
  local plugins_dir="${ZINIT[PLUGINS_DIR]:-${XDG_DATA_HOME:-$HOME/.local/share}/zinit/plugins}"
  local count=0 dir behind
  for dir in "$plugins_dir"/*(N/); do
    [[ -d "$dir/.git" ]] || continue
    git -C "$dir" fetch -q 2>/dev/null || continue
    behind=$(git -C "$dir" rev-list HEAD..@{u} --count 2>/dev/null)
    (( count += ${behind:-0} ))
  done
  zmodload zsh/datetime
  print "$count" >|"$_zinit_count_cache"
  print "$EPOCHSECONDS" >|"$_zinit_stamp"
}

zup() {
  zinit self-update && zinit update --all
  rm -f "$_zinit_stamp" "$_zinit_count_cache"
  _zinit_check_triggered=0
}

_zinit_update_indicator() {
  zmodload zsh/datetime
  local now=$EPOCHSECONDS last=0
  [[ -f "$_zinit_stamp" ]] && last=$(<"$_zinit_stamp")

  if (( now - last > 604800 )); then
    (( _zinit_check_triggered )) || { _zinit_check_triggered=1; _zinit_fetch_count &! }
  fi

  if [[ -f "$_zinit_count_cache" ]]; then
    local count=$(<"$_zinit_count_cache")
    (( count > 0 )) && RPROMPT="%F{222}↻ ($count)%f" || RPROMPT=''
  else
    RPROMPT=''
  fi
}
add-zsh-hook precmd _zinit_update_indicator

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
