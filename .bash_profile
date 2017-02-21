# Helper function to prepend stuff to PATH
prepend-path() {
    [ -d $1 ] && PATH="$1:$PATH"
}

# Load NVM
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh

# We need to add coreutils to the path
prepend-path "$(brew --prefix coreutils)/libexec/gnubin"

# Add fastlane
prepend-path "$HOME/.fastlane/bin"

# Add android
export ANDROID_HOME=/usr/local/opt/android-sdk

# Load the shell dotfiles, and then some:
for file in `find $HOME/.dotfiles/stuff`; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Add tab completion for many Bash commands
if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  source $(brew --prefix)/share/bash-completion/bash_completion
fi

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

dotfiles() {
  if [ $# -lt 1 ]; then
    dotfiles --help
    return
  fi

  local COMMAND
  COMMAND="${1-}"
  shift

  case $COMMAND in
    'help' | '--help' )
      echo 'This is no reserved for some stuff. Lets see if I can do something useful with it.'
    ;;
  esac
}

function light() {
  if [ -z "$2" ]
    then src="pbpaste"
  else
    src="cat $2"
  fi
  $src | highlight -O rtf --syntax $1 --font Inconsolata --style solarized-dark --font-size 24 | pbcopy
}

# Fix previous terminal input
eval "$(thefuck --alias)"
