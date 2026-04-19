#!/usr/bin/env bash

# install command-line tools using homebrew.

if ! which brew &> /dev/null; then
  echo "Homebrew installation not found"
  exit
fi

# make sure we’re using the latest homebrew
brew update

# upgrade any already-installed formulae
brew upgrade

bins=(
  # install a modern version of bash
  bash
  bash-completion@2

  coreutils
  findutils

  git
  git-lfs

  # nvim
  neovim
  fd
  fzf
  ripgrep
  lazygit

  # other useful stuff
  starship
  wget
  telnet
  nvm
  scc
  FelixKratz/formulae/borders
)

brew install "${bins[@]}"

# switch to using brew-installed bash as default shell
if ! grep -Fq "$(brew --prefix)/bin/bash" /etc/shells; then
  echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "$(brew --prefix)/bin/bash";
fi;

# use sha256 from coreutils
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
  hyperkey
  nikitabobko/tap/aerospace
  font-fira-code
  font-fira-code-nerd-font
)

brew install --cask "${casks[@]}"

# remove outdated versions from the cellar
brew cleanup
