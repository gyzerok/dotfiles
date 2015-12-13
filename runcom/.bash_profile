# Load the shell dotfiles, and then some:
for file in `find ~/.dotfiles/system`; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Add tab completion for many Bash commands
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;
