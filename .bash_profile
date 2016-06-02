# Helper function to prepend stuff to PATH
prepend-path() {
    [ -d $1 ] && PATH="$1:$PATH"
}

# Load the shell dotfiles, and then some:
for file in `find $HOME/.dotfiles/stuff`; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Load NVM
source $(brew --prefix nvm)/nvm.sh

# We need to add coreutils to the path
prepend-path "$(brew --prefix coreutils)/libexec/gnubin"

# Add tab completion for many Bash commands
if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  source $(brew --prefix)/share/bash-completion/bash_completion
fi

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;
