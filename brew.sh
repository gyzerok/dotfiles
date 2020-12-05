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
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install a modern version of ZSH.
brew install zsh
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Switch to using brew-installed zsh as default shell
if ! grep -Fq "$(brew --prefix)/bin/zsh" /etc/shells; then
  echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells;
  chsh -s "$(brew --prefix)/bin/zsh";
fi;

# Install more recent versions of some macOS tools.
brew install wget

# Install other useful binaries.
brew install nvm
brew install git
brew install git-lfs
git lfs install

# Install apps only for macOS as I don't need them on Linux VMs.
if [ "$(uname)" == "Darwin" ]; then
  brew tap homebrew/cask-versions
  brew install --cask firefox-developer-edition
  brew install --cask visual-studio-code
  brew install --cask hyper
  brew install --cask caffeine
  brew install --cask telegram

  # Install GnuPG to enable PGP-signing commits.
  # Doing it last as it might require sudo password.
  brew install --cask gpg-suite-no-mail
fi

# Remove outdated versions from the cellar.
brew cleanup
