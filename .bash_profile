# This is needed for tools which work with bash
# to find node and npm (for example Visual Studio Code)
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh

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