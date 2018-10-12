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
brew cask install java
brew cask install smcfancontrol
brew cask install sublime-text
brew cask install google-chrome
brew cask install opera
brew cask install discord
brew cask install vlc
brew cask install dropbox
brew cask install teamspeak-client
brew cask install virtualbox
brew cleanup
