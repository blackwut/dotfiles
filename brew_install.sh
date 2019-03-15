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
brew install duti
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
brew cask install skype
brew cask install teamviewer
brew cask install spectacle
brew cleanup

duti -s com.sublimetext.3 .h all
duti -s com.sublimetext.3 .c all
duti -s com.sublimetext.3 .cpp all
duti -s com.sublimetext.3 .hpp all
duti -s com.sublimetext.3 .sh all
duti -s org.videolan.vlc .avi all
duti -s org.videolan.vlc .flac all
duti -s org.videolan.vlc .flv all
duti -s org.videolan.vlc .m4a all
duti -s org.videolan.vlc .mkv all
duti -s org.videolan.vlc .mov all
duti -s org.videolan.vlc .mp3 all
duti -s org.videolan.vlc .mp4 all
duti -s org.videolan.vlc .mpg all
duti -s org.videolan.vlc .wav all
duti -s org.videolan.vlc .wmv all
