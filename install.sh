#!/usr/bin/env bash

DOTFILES_PATH=$HOME/.dotfiles


###############################################################################
# Install packages                                                            #
###############################################################################

# Make sure we are using latest Homebrew
brew update

# Install useful binaries
brew install git
brew install nvm
brew install shellcheck

# Install apps
brew cask install firefox
brew cask install visual-studio-code
brew cask install hyper
brew cask install slack
brew cask install caffeine
brew cask install istat-menus
brew cask install tunnelblick

# Install newer version of Bash
brew install bash
brew install bash-completion@2

if ! grep -Fq "$(brew --prefix)/bin/bash" /etc/shells; then
  echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "$(brew --prefix)/bin/bash";
fi

# Remove outdated versions from the cellar.
brew cleanup


###############################################################################
# Install dotfiles                                                            #
###############################################################################

# Cloning repo so it would be easy to keep in sync with repo later
git clone https://github.com/gyzerok/dotfiles.git "${DOTFILES_PATH}"

ln -sf "${DOTFILES_PATH}/.bash_profile" "${HOME}/.bash_profile"
ln -sf "${DOTFILES_PATH}/.inputrc" "${HOME}/.inputrc"
ln -sf "${DOTFILES_PATH}/.gitconfig" "${HOME}/.gitconfig"
ln -sf "${DOTFILES_PATH}/.hyper.js" "${HOME}/.hyper.js"


###############################################################################
# Configure macOS                                                             #
###############################################################################

bash "${DOTFILES_PATH}/macos.sh"