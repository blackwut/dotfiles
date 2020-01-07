#!/bin/sh

# Be sure to enable trim, then use this script
# sudo trimforce enable

echo "Installing brew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing brew cask..."
brew tap caskroom/cask

brew install bash
brew install bash-completion@2
brew install git
brew install gpg
brew install macvim
brew install htop
brew install duti
brew install python

# Utilities
brew cask install smcfancontrol
brew cask install gfxcardstatus
brew cask install the-unarchiver
brew cask install ifunbox
brew cask install coconutbattery
brew cask install unetbootin
brew cask install vlc
brew cask install dropbox
brew cask install spectacle
brew cask install microsoft-office
brew cask install appcleaner
brew cask install menumeters
brew cask install cyberduck

# Programming
brew cask install sublime-text
brew cask install typora

# Browsers
brew cask install google-chrome

# Socials
brew cask install telegram-desktop
brew cask install teamspeak-client
brew cask install discord
brew cask install skype
brew cask install ferdi

# Downloads
brew cask install transmission
brew cask install jdownloader

# Remote Control
brew cask install vnc-viewer
brew cask install teamviewer

# Virtualization
brew cask install virtualbox

# Games
brew cask install battle-net
brew cask install hstracker

# Cleanup
brew cleanup

# Extension files
duti ./hidden/.duti

# Configuration Files
HIDDENFOLDER=./hidden
mkdir -p ~/.config
mkdir -p ~/.config/htop
ln $HIDDENFOLDER/.config/htop/htoprc ~/.config/htop/htoprc
ln $HIDDENFOLDER/.aliases ~/.aliases
ln $HIDDENFOLDER/.bash_profile ~/.bash_profile
ln $HIDDENFOLDER/.bash_prompt ~/.bash_prompt
ln $HIDDENFOLDER/.bashrc ~/.bashrc
ln $HIDDENFOLDER/.duti ~/.duti
ln $HIDDENFOLDER/.editorconfig ~/.editorconfig
ln $HIDDENFOLDER/.exports ~/.exports
ln $HIDDENFOLDER/.functions ~/.functions
ln $HIDDENFOLDER/.gitignore ~/.gitignore
ln $HIDDENFOLDER/.inputrc ~/.inputrc
unset HIDDENFOLDER

# Add global git ignore
git config --global core.excludesfile ~/.gitignore

# Adding new bash shell
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change shell to current user
chsh -s /usr/local/bin/bash $USER

# Adding smcFanControl to login items
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/smcFanControl.app", hidden:false}' 

# List login itmes
# osascript -e 'tell application "System Events" to get the name of every login item'
# Add login item
# osascript -e 'tell application "System Events" to make login item at end with properties {path:"/path/to/item_name", hidden:false}' 
# Remove login item
# osascript -e 'tell application "System Events" to delete login item "ITEMNAME"'

