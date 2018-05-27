#!/bin/bash

# Initial startup script for macOS 10.14.4
# Owen McGill, created 26th of May 2018

setup () {

  /bin/echo "Great let's continue."

  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until `osx.sh` has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "

  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # Expand print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Automatically quit printer app once the print jobs complete
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable Time Machine's pop-up message when inserting an external drive
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


  #######
  # SSD #
  #######

  # Disable local Time Machine snapshots
  sudo tmutil disablelocal

  # Disable sudden motion sensor
  sudo pmset -a sms 0

  ####################################
  # Trackpad, keyboard and Bluetooth #
  ####################################

  # Enable tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Increase sound quality for Bluetooth headphones/headsets
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

  # Enable full keyboard access for all controls
  # (e.g. enable Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Stop iTunes from responding to the keyboard media keys
  launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

  ##########
  # Screen #
  ##########

  # Enable subpixel font rendering on non-Apple LCDs
  defaults write NSGlobalDomain AppleFontSmoothing -int 2

  # Enable HiDPI display modes (requires restart)
  sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

  ##########
  # Finder #
  ##########

  # Show icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  # Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Finder: allow text selection in Quick Look
  defaults write com.apple.finder QLEnableTextSelection -bool true

  # Display full POSIX path as Finder window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

  # Disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Avoid creating .DS_Store files on network volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  # Use list view in all Finder windows by default
  # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Show the ~/Library folder
  chflags nohidden ~/Library

  ########
  # Dock #
  ########

  # Wipe all (default) app icons from the Dock
  # This is only really useful when setting up a new Mac, or if you don’t use
  # the Dock to launch apps.
  defaults write com.apple.dock persistent-apps -array



  ##############################
  # Install Command Line Tools #
  ##############################

  echo -e "\nChecking to see if Apple Command Line Tools are installed."
      xcode-select -p &>/dev/null
      if [[ $? -ne 0 ]]
      then
          echo " Apple Command Line Utilities not installed. Installing..."
          echo "Please be patient. This process may take a while to complete."

          # Tell software update to also install OXS Command Line Tools without prompt
          ## As per https://sector7g.be/posts/installing-xcode-command-line-tools-through-terminal-without-any-user-interaction

          touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
          dsudo -v # extend sudo's timeout by 5 minutes
          wait

          /bin/rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

          # Check one last time for updates - TBD: refactor to do a test first.
          sudo /usr/sbin/softwareupdate -ia
          wait

          echo -e "\nFinished installing Apple Command Line Tools."
      else
          echo -e "\nApple Command Line Tools already installed."
      fi

}

brew() {

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew update
  brew upgrade

  brew bundle --file=Brewfile

}

dotfiles() {
  ln -sfv ~/.dotfiles/vim/.vim ~/.vim
  ln -sfv ~/.dotfiles/vim/.vimrc ~/.vimrc
  ln -sfv ~/.dotfiles/vim/viminfo ~/.viminfo

  ln -sfv ~/.dotfiles/hammerspoon/.hammerspoon ~/.hammerspoon

  ln -sfv ~/.dotfiles/git/.gitconfig ~/.gitconfig
  ln -sfv ~/.dotfiles/git/.gitignore_global ~/.gitignore_global

  ln -sv ~/.dotfiles/config/.config ~/.config
}

/bin/echo "Before continuing please reboot into recovery mode and run \"spctl kext-consent disable\" in the terminal."
/bin/echo "This disables the necessity of allowing new kexts everytime an application installs a new one."
/bin/echo "This can be re-enabled after the script has completed by running \"spctl kext-console enable\""
/bin/echo "in the recovery mode terminal. Once this is done rerun this script."

/bin/echo "Have you already disabled kext-consent or prefer not to?"

select yn in "Yes" "No"; do
  case $yn in
    Yes ) setup ; break;;
    No ) exit;;
  esac
done
