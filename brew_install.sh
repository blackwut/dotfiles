#!/bin/sh
echo "Installing brew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing brew cask..."
brew tap caskroom/cask

brew install bash
brew install bash-completion@2
brew install git
brew install gpg
brew install macvim
brew install tmux
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
# brew cask install cyberduck

# Programming
brew cask install sublime-text
brew cask install typora
# brew cask install netbeans

# Browsers
brew cask install google-chrome
brew cask install opera

# Socials
brew cask install teamspeak-client
brew cask install discord
brew cask install skype

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

# Cleanup
brew cleanup

# Association extension file to apps
duti ./hidden/.duti
