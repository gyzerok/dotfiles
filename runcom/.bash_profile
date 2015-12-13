# Load the shell dotfiles, and then some:
for file in `find ~/.dotfiles/system`; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;
