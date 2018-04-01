#!/usr/bin/env bash
set -e

main() {
  configure_system
  configure_dock
  configure_finder
}


function configure_system() {
  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "
  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false
  # Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  # Privacy: don’t send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true
  # Prevent Time Machine from prompting to use new hard drives as backup volume
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
  # Prevent Photos from opening automatically when devices are plugged in
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
}


function configure_dock() {
  quit "Dock"
  # Set the icon size of Dock items to 36 pixels
  defaults write com.apple.dock tilesize -int 36
  # Wipe all (default) app icons from the Dock
  defaults write com.apple.dock persistent-apps -array
  # Show only open applications in the Dock
  defaults write com.apple.dock static-only -bool true
  # Don’t animate opening applications from the Dock
  defaults write com.apple.dock launchanim -bool false
  # Disable Dashboard
  defaults write com.apple.dashboard mcx-disabled -bool true
  # Don’t show Dashboard as a Space
  defaults write com.apple.dock dashboard-in-overlay -bool true
  # Don’t automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false
  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true
  # Remove the auto-hiding Dock delay
  defaults write com.apple.dock autohide-delay -float 0
  # Disable the Launchpad gesture (pinch with thumb and three fingers)
  defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

  ## Hot corners
  ## Possible values:
  ##  0: no-op
  ##  2: Mission Control
  ##  3: Show application windows
  ##  4: Desktop
  ##  5: Start screen saver
  ##  6: Disable screen saver
  ##  7: Dashboard
  ## 10: Put display to sleep
  ## 11: Launchpad
  ## 12: Notification Center
  ## Top left screen corner → Mission Control
  defaults write com.apple.dock wvous-tl-corner -int 2
  defaults write com.apple.dock wvous-tl-modifier -int 0
  ## Top right screen corner → Desktop
  defaults write com.apple.dock wvous-tr-corner -int 4
  defaults write com.apple.dock wvous-tr-modifier -int 0
  ## Bottom left screen corner → Start screen saver
  defaults write com.apple.dock wvous-bl-corner -int 5
  defaults write com.apple.dock wvous-bl-modifier -int 0
  open "Dock"
}


function configure_finder() {
  # expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  # expand print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
  # set Downloads as the default location for new Finder windows
  defaults write com.apple.finder NewWindowTarget -string "PfLo"
  defaults write com.apple.finder NewWindowTargetPath -string \
      "file://${HOME}/Downloads/"
  # save screenshots to Downloads folder
  defaults write com.apple.screencapture location -string "${HOME}/Downloads"
  # save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"
  # require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0
  # allow quitting via ⌘ + q; doing so will also hide desktop icons
  defaults write com.apple.finder QuitMenuItem -bool true
  # disable window animations and Get Info animations
  defaults write com.apple.finder DisableAllAnimations -bool true
  # show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool false
  # show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # show status bar
  defaults write com.apple.finder ShowStatusBar -bool true
  # show path bar
  defaults write com.apple.finder ShowPathbar -bool true
  # display full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  # keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true
  # when performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  # disable disk image verification
  defaults write com.apple.frameworks.diskimages \
      skip-verify -bool true
  defaults write com.apple.frameworks.diskimages \
      skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages \
      skip-verify-remote -bool true
  # use list view in all Finder windows by default
  # four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  # disable the warning before emptying the Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
  # avoid creating .DS_Store files on network volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  # expand the following File Info panes:
  # “General”, “Open with”, and “Sharing & Permissions”
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true
}


function quit() {
  app=$1
  killall "$app" > /dev/null 2>&1
}


function open() {
  app=$1
  osascript << EOM
tell application "$app" to activate
EOM
}
