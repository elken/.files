#
# Executes commands at login pre-zshrc.
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export VISUAL='edit'
export EDITOR='visual'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_GB.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

fpath=(
  $fpath
)

if [[ "$INSIDE_EMACS" != 'vterm' ]]; then
  if [[ "$OSTYPE" == darwin* ]]; then
      path=(
          /Applications/Emacs.app/Contents
          /Applications/Emacs.app/Contents/bin
          /usr/local/opt/coreutils/libexec/gnubin
          /opt/homebrew/opt/coreutils/libexec/gnubin
          /opt/homebrew/opt/openjdk/bin
          /Users/elken/flutter/sdk/bin
          /opt/homebrew/bin
          $path
      )
      # Hardcoded to avoid brew --prefix subprocess at every login
      export DYLD_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_LIBRARY_PATH"
      export JAVA_HOME="/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
      export CFLAGS="$CFLAGS -I/opt/homebrew/opt/libmps/include"
      export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/libmps/lib"
  fi

  # Set the list of directories that Zsh searches for programs.
  path=(
    $HOME/.ghcup/bin
    $HOME/.local/share/nvim/mason/bin
    /home/linuxbrew/.linuxbrew/lib/ruby/gems/3.3.0/bin
    $HOME/.babashka/bbin/bin
    $HOME/.qlot/bin
    $HOME/.config/emacs/bin
    $HOME/.cargo/bin
    $HOME/bin
    $HOME/.local/bin
    $HOME/.config/yarn/global/node_modules/.bin
    $HOME/.dotnet/tools
    $HOME/spicetify-cli
    $HOME/.luarocks/bin
    $HOME/build/phpactor/bin
    $HOME/go/bin
    $HOME/.local/share/mise/shims
    /usr/local/{bin,sbin}
    /usr/bin
    $path
  )

fi
export GPG_TTY=$(tty)
() {
  local kc_dir="$HOME/.keychain"
  local kc_env="$kc_dir/${HOST}-sh"
  [[ -f "$kc_env" ]] && source "$kc_env"
  ssh-add -l &>/dev/null
  if (( $? != 0 )); then
    # Prune stale files from old hostnames before re-initialising
    local f
    for f in "$kc_dir"/*(N); do
      [[ "$f" != "$kc_dir/${HOST}"* ]] && rm -f "$f"
    done
    eval "$(keychain --eval --quiet --ssh-allow-gpg ~/.ssh/git)"
  fi
}

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export RUBY_YJIT_ENABLE=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

#
# Less
#

export LESS='-F -g -i -M -R -S -w -X -z-4'

if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
  mkdir -p "$TMPPREFIX"
fi
