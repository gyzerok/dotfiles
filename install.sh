#!/usr/bin/env bash
set -e

DOTFILES_PATH=$HOME/.dotfiles


main() {
  ask_for_sudo
  install_homebrew
  install_packages
  install_dotfiles
  configure_macos
  install_bash
}


function ask_for_sudo() {
  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until installation has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}


function install_homebrew() {
  # Unattended installation as described in https://github.com/Homebrew/legacy-homebrew/issues/46779#issuecomment-162819088
  echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}


function install_packages() {
  # Make sure we are using latest Homebrew
  brew update

  # Install GNU core utilities (those that come with OS X are outdated).
  # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
  brew install coreutils
  ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

  # Install some other useful utilities like `sponge`.
  brew install moreutils
  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
  brew install findutils

  # Install other useful binaries
  brew install git
  brew install nvm

  # Install apps
  # brew cask install firefox
  brew cask install visual-studio-code
  brew cask install hyper
  brew cask install slack
  brew cask install caffeine
  brew cask install istat-menus
  # brew cask install tunnelblick

  # Remove outdated versions from the cellar.
  brew cleanup
  brew cask cleanup
}


function install_dotfiles() {
  # Cloning repo so it would be easy to keep in sync with repo later
  git clone https://github.com/gyzerok/dotfiles.git $DOTFILES_PATH

  ln -sf $DOTFILES_PATH/.bash_profile $HOME/.bash_profile
  ln -sf $DOTFILES_PATH/.inputrc $HOME/.inputrc
  ln -sf $DOTFILES_PATH/.gitconfig $HOME/.gitconfig
  ln -sf $DOTFILES_PATH/.hyper.js $HOME/.hyper.js
}


function configure_macos() {
  bash $DOTFILES_PATH/defaults.sh
}


function install_bash() {
  brew install bash
  brew install bash-completion@2

  if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/bash;
  fi
}


main "$@"
