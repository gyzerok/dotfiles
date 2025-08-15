#!/usr/bin/env bash

# Install command-line tools using Homebrew.

if ! which brew &> /dev/null; then
  echo "Homebrew installation not found"
  exit
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "$(brew --prefix)/bin/gsha256sum" "$(brew --prefix)/bin/sha256sum"

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install a modern version of Bash.
brew install bash
brew install bash-completion@2

# Switch to using brew-installed bash as default shell
if ! grep -Fq "$(brew --prefix)/bin/bash" /etc/shells; then
  echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "$(brew --prefix)/bin/bash";
fi;

# Install other useful binaries.
brew install wget
brew install telnet
brew install nvm
brew install git
brew install git-lfs
brew install scc
brew install yt-dlp

# Install nice prompt
brew install starship

# Insall NeoVim and related things
# brew install neovim
# brew install ripgrep
# brew install fd

brew install --cask firefox
brew install --cask visual-studio-code
brew install --cask keepingyouawake
brew install --cask betterdisplay
brew install --cask iina
brew install --cask wezterm
brew install --cask docker
brew install --cask raycast

# Add fonts tap
brew tap homebrew/cask-fonts
# Install Fira Code
brew install --cask font-fira-code
brew install --cask font-fira-code-nerd-font

# Install GnuPG to enable PGP-signing commits.
# Doing it last as it might require sudo password.
brew install --cask gpg-suite-no-mail

# Remove outdated versions from the cellar.
brew cleanup
