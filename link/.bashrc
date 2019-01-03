# Where the magic happens.
export DOTFILES=~/.dotfiles

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in $DOTFILES/source/*; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src

# FZF find all the things
# https://monades.roperzh.com/weekly-command-fuzzy-finding-everything-with-fzf/
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
