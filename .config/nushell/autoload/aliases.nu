alias make = make $"-j(sys cpu | length | $in + 1)" $"-l(sys cpu | length)"
alias c = clear
alias q = exit
def ll [] { ls -al | sort-by type name -i | grid -c -i }
def mkdcd [] { mkdir $in and cd $in }

alias yl = lazygit --work-tree ~ --git-dir ~/.local/share/yadm/repo.git
