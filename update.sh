# Update App Store apps
sudo softwareupdate -i -a

# Update Homebrew (Cask) & packages
brew update
brew upgrade --all

# Remove outdated versions from the cellar.
brew cleanup
