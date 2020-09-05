#!/bin/sh

# Check if trim is enabled
if system_profiler SPSerialATADataType | grep -q 'TRIM Support: Yes'; then
	echo "Trim is enabled!"
else
	echo "Pleaase enable Trim using: sudo trimforce enable"
	exit
fi

DIR_HIDDEN="./hidden"

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
brew install dockutil

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
brew cask install microsoft-word
brew cask install microsoft-excel
brew cask install microsoft-powerpoint
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
brew cask install whatsapp
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
brew cask install hstracker

# Cleanup
brew cleanup

# Extension files
duti "$DIR_HIDDEN/.duti"

# Configuration Files
mkdir -p ~/".config"
mkdir -p ~/".config/htop"
chmod 0700 "$DIR_HIDDEN/.*"
ln "$DIR_HIDDEN/.config/htop/htoprc" ~/".config/htop/htoprc"
ln "$DIR_HIDDEN/.aliases" ~/".aliases"
ln "$DIR_HIDDEN/.bash_profile" ~/".bash_profile"
ln "$DIR_HIDDEN/.bash_prompt" ~/".bash_prompt"
ln "$DIR_HIDDEN/.bashrc" ~/".bashrc"
ln "$DIR_HIDDEN/.duti" ~/".duti"
ln "$DIR_HIDDEN/.editorconfig" ~/".editorconfig"
ln "$DIR_HIDDEN/.exports" ~/".exports"
ln "$DIR_HIDDEN/.functions" ~/".functions"
ln "$DIR_HIDDEN/.gitignore" ~/".gitignore"
ln "$DIR_HIDDEN/.inputrc" ~/".inputrc"
ln "$DIR_HIDDEN/.editrc" ~/".editrc"
mkdir -p ~/".scripts"
chmod +x "wowfi.sh"
ln "wowfi.sh" ~/".scripts/wowfi.sh"
unset DIR_HIDDEN

# Add global git ignore
git config --global core.excludesfile ~/".gitignore"

# Adding new bash shell
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change shell to current user
chsh -s /usr/local/bin/bash $USER

# List login itmes
# osascript -e 'tell application "System Events" to get the name of every login item'
# Add login item
# osascript -e 'tell application "System Events" to make login item at end with properties {path:"/path/to/item_name", hidden:false}' 
# Remove login item
# osascript -e 'tell application "System Events" to delete login item "ITEMNAME"'

# Adding smcFanControl to login items
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/smcFanControl.app", hidden:false}'
# Adding Spectacle to login items
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Spectacle.app", hidden:false}'
# Adding MenuMeters to login items
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/MenuMeters.app", hidden:false}'
# Adding gfxCardStatus to login items
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/gfxCardStatus.app", hidden:false}'

# smcFanControl Settings
cp "./preferences/com.eidac.smcFanControl2.plist" ~/"Library/Preferences/com.eidac.smcFanControl2.plist"
# MenuMeters Settings
cp "./preferences/com.ragingmenace.MenuMeters.plist" ~/"Library/Preferences/com.ragingmenace.MenuMeters.plist"
# gfxCardStatus Settings
cp "./preferences/com.codykrieger.gfxCardStatus-Preferences.plist" "./preferences/com.codykrieger.gfxCardStatus.plist" ~/"Library/Preferences/."

# Sublime Text 3 Settings
DIR_SUBLIMETEXT=~/"Library/Application Support/Sublime Text 3"
DIR_INSTALLED_PACKAGES="$DIR_SUBLIMETEXT/Installed Packages"
DIR_USER="$DIR_SUBLIMETEXT/Packages/User"

mkdir -p "$DIR_INSTALLED_PACKAGES"
mkdir -p "$DIR_USER"

echo "Downloading Package Control..."
curl -fsSL "https://sublime.wbond.net/Package Control.sublime-package" -o "$DIR_INSTALLED_PACKAGES/Package Control.sublime-package"
echo "Configuring desired packages"
cp "./preferences/Preferences.sublime-settings" "$DIR_USER/Preferences.sublime-settings" 2> /dev/null
cp "./preferences/Package Control.sublime-settings" "$DIR_USER" 2> /dev/null
echo "Done. Launch Sublime and press ctrl +\` for a status!"

unset DIR_SUBLIMETEXT
unset DIR_INSTALLED_PACKAGES
unset DIR_USER
