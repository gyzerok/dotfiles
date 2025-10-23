#!/usr/bin/env bash

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init bash)"

###############################################################################
# Aliases                                                                     #
###############################################################################

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# List all files colorized in long format, including dot files
alias la="ls -laF ${colorflag}"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Flush DNS cache
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

###############################################################################
# Exports                                                                     #
###############################################################################

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty)

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1;

###############################################################################
# Misc                                                                        #
###############################################################################

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

if which brew &> /dev/null; then
	# This is needed for tools which work with bash
	# to find node and npm (for example Visual Studio Code)
	export NVM_DIR="${HOME}/.nvm"
	source "$(brew --prefix nvm)/nvm.sh"

	# Use GNU core utils on macOS if available.
	PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

	# Add tab completion for many Bash commands
	if [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
		# Ensure existing Homebrew v1 completions continue to work
		export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
		source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion;
	fi
fi

# * ~/.bash_extra can be used for other settings you don’t want to commit.
if [ -f "$HOME/.bash_extra" ]; then
	source "$HOME/.bash_extra";
fi

if [ -r "$HOME/.cargo/env" ]; then
	source "$HOME/.cargo/env"
fi
