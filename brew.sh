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

bins=(
  # Install a modern version of Bash.
  bash
  bash-completion@2

  coreutils
  findutils

  git
  git-lfs

  # LazyVim requirements
  neovim
  fd
  fzf
  ripgrep
  lazygit

  # Other useful staff
  starship
  wget
  telnet
  nvm
  scc
)

brew install "${bins[@]}"

# Switch to using brew-installed bash as default shell
if ! grep -Fq "$(brew --prefix)/bin/bash" /etc/shells; then
  echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "$(brew --prefix)/bin/bash";
fi;

# Use sha256 from coreutils
ln -s "$(brew --prefix)/bin/gsha256sum" "$(brew --prefix)/bin/sha256sum"

casks=(
  firefox
  ghostty
  visual-studio-code
  docker
  raycast
  betterdisplay
  keepingyouawake
  iina
  font-fira-code
  font-fira-code-nerd-font
)

brew install --cask "${casks[@]}"

# Remove outdated versions from the cellar.
brew cleanup
