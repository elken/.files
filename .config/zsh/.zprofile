#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
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

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

fpath=(
  $fpath
)

if [[ "$INSIDE_EMACS" != 'vterm' ]]; then
  export VISUAL='hx'
  export EDITOR='hx'

  if [[ "$OSTYPE" == darwin* ]]; then
      path=(
          /usr/local/opt/coreutils/libexec/gnubin
          /opt/homebrew/opt/coreutils/libexec/gnubin
          /opt/homebrew/opt/openjdk/bin
          /Users/elken/flutter/sdk/bin
          /opt/homebrew/bin
          $path
      )
      export GPG_TTY=$(tty)
  fi

  # Set the list of directories that Zsh searches for programs.
  path=(
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
    /usr/local/{bin,sbin}
    /usr/bin
    $path
  )

  export GPG_TTY=$(tty)

fi
#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
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

function au(){
    AURA="$(aura "$@")"

    if echo "$AURA" | grep -q '^aura >>= .*You have to use `.*sudo.*` for that.*$'
    then
        sudo aura "$@"
    else
        echo "$AURA"
    fi
}
