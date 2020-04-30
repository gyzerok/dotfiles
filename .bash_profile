#!/usr/bin/env bash

# GPG key
export GPG_TTY=$(tty)

# This is needed for tools which work with bash
# to find node and npm (for example Visual Studio Code)
export NVM_DIR="${HOME}/.nvm"
source "$(brew --prefix nvm)/nvm.sh"

# Load the shell dotfiles, and then some:
while read -r file; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done <<< "$(find "${HOME}/.dotfiles/stuff")"
unset file;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Autocorrect typos in path names when using cd 
shopt -s cdspell;