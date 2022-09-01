#!/bin/sh

DIR_HIDDEN="$HOME/Projects/dotfiles/hidden"

echo "Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

chmod -R go-w '/opt/homebrew/share/zsh'
chmod -R 755 /opt/homebrew/share

echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install htop
brew install duti
brew install git
brew install python
# dockutil 3.0.2 is not available from brew/core up to now!
brew install hpedrorodrigues/tools/dockutil
# brew install dockutil
brew install tmux

# Utilities
brew install --cask mysides
brew install --cask the-unarchiver
brew install --cask vlc
brew install --cask dropbox
brew install --cask rectangle
brew install --cask microsoft-word
brew install --cask microsoft-excel
brew install --cask microsoft-powerpoint
brew install --cask appcleaner
# brew install menumeters

# Programming
brew install --cask sublime-text
brew install --cask hex-fiend
brew install --cask macdown

# Browsers
# brew cask install google-chrome

# Socials
brew install --cask telegram-desktop
brew install --cask whatsapp
brew install --cask discord
brew install --cask skype

# Downloads
brew install --cask transmission

# Remote Control
brew install --cask vnc-viewer
brew install --cask teamviewer

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
ln "$DIR_HIDDEN/.editorconfig" ~/".editorconfig"
ln "$DIR_HIDDEN/.exports" ~/".exports"
ln "$DIR_HIDDEN/.functions" ~/".functions"
ln "$DIR_HIDDEN/.gitignore" ~/".gitignore"
unset DIR_HIDDEN

ZSHRC_SOURCES='
# Source your files!
for file in ~/.{aliases,functions,exports}; do
        [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
'
echo $ZSHRC_SOURCES >> ~/.zshrc

# Add global git ignore
git config --global core.excludesfile ~/".gitignore"
# tell git to use symlinks if repo has symlinks (otherwise it DUPLICATES THE FILE ugh)
git config --global core.symlinks true


# Sublime Text 3 Settings
DIR_SUBLIMETEXT=~/"Library/Application Support/Sublime Text"
# DIR_INSTALLED_PACKAGES="$DIR_SUBLIMETEXT/Installed Packages"
DIR_USER="$DIR_SUBLIMETEXT/Packages/User"

# mkdir -p "$DIR_INSTALLED_PACKAGES"
mkdir -p "$DIR_USER"

echo "Downloading Package Control..."
# curl -fsSL "https://sublime.wbond.net/Package Control.sublime-package" -o "$DIR_INSTALLED_PACKAGES/Package Control.sublime-package"
# echo "Configuring desired packages"
cp "./preferences/Preferences.sublime-settings" "$DIR_USER/Preferences.sublime-settings" 2> /dev/null
# cp "./preferences/Package Control.sublime-settings" "$DIR_USER" 2> /dev/null
# echo "Done. Launch Sublime and press ctrl +\` for a status!"


# Disable Microsoft Update (Word, Excel, Powerpoint)
# disable the service
# launchctl disable gui/$(id -u)/com.microsoft.update.agent
# check that the service is disabled
# launchctl print-disabled gui/$(id -u) | grep microsoft

unset DIR_SUBLIMETEXT
# unset DIR_INSTALLED_PACKAGES
unset DIR_USER
