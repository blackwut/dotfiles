#

SCRIPTFOLDER="~/.script"

###############################################################################
# PMSET                                                                       #
###############################################################################
# Disable Sudden Motion Sensor
sudo pmset -a sms 0
# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0

###############################################################################
# RamDisk                                                                     #
###############################################################################
sudo cp com.nullvision.ramdisk.plist /Library/LaunchDaemons/com.nullvision.ramdisk.plist
if [ -d $SCRIPTFOLDER ]; then
    mkdir $SCRIPTFOLDER
fi
cp ramdisk_deamon.sh $SCRIPTFOLDER
chmod +x $SCRIPTFOLDER/ramdisk_deamon.sh
sudo launchctl load -w /Library/LaunchDaemons/com.nullvision.ramdisk.plist

###############################################################################
# SSD Tweaks                                                                  #
###############################################################################
# Enable Trim on SSD
sudo trimforce enable
# Disable Creation of .DS_Store Files on Network Volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Disable Creation of .DS_Store Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Save screenshots to the RamDisk
defaults write com.apple.screencapture location -string "/Volumes/RamDisk"
# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"
# Set NOATIME
sudo cp com.nullvision.noatime /Library/LaunchDaemons/com.nullvision.noatime.plist


###############################################################################
# Time Machine                                                                #
###############################################################################
# Time machine backup disable
sudo tmutil disable
# Prevent Time Machine from Prompting to use new HD as backup
sudo defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Trackpad                                                                    #
###############################################################################
# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false


###############################################################################
# Keyboard                                                                    #
###############################################################################
# Keyboard Disable Auto-Correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false


###############################################################################
# Finder                                                                      #
###############################################################################
# Unhide User Library Folder
chflags nohidden ~/Library
# Desktop Show Internal Media
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# Desktop Show External Media
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist

# Don’t group windows by application in Mission Control
defaults write com.apple.dock expose-group-by-app -bool false
# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true
# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false
# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 7
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0


killall Finder


###############################################################################
# Spotlight                                                                   #
###############################################################################
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
#   MENU_DEFINITION
#   MENU_CONVERSION
#   MENU_EXPRESSION
#   MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
#   MENU_WEBSEARCH             (send search queries to Apple)
#   MENU_OTHER
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1; "name" = "APPLICATIONS";}' \
    '{"enabled" = 1; "name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1; "name" = "PDF";}' \
    '{"enabled" = 1; "name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 1; "name" = "MENU_DEFINITION";}' \
    '{"enabled" = 1; "name" = "SOURCE";}' \
    '{"enabled" = 0; "name" = "MENU_OTHER";}' \
    '{"enabled" = 0; "name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
    '{"enabled" = 0; "name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0; "name" = "DOCUMENTS";}' \
    '{"enabled" = 0; "name" = "DIRECTORIES";}' \
    '{"enabled" = 0; "name" = "PRESENTATIONS";}' \
    '{"enabled" = 0; "name" = "SPREADSHEETS";}' \
    '{"enabled" = 0; "name" = "MESSAGES";}' \
    '{"enabled" = 0; "name" = "CONTACT";}' \
    '{"enabled" = 0; "name" = "EVENT_TODO";}' \
    '{"enabled" = 0; "name" = "IMAGES";}' \
    '{"enabled" = 0; "name" = "BOOKMARKS";}' \
    '{"enabled" = 0; "name" = "MUSIC";}' \
    '{"enabled" = 0; "name" = "MOVIES";}' \
    '{"enabled" = 0; "name" = "FONTS";}'

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null


###############################################################################
# Textedit                                                                    #
###############################################################################
# Textedit PlainTextMode enable
defaults write com.apple.TextEdit RichText -int 0


###############################################################################
# Safari                                                                      #
###############################################################################
# Safari Developer and Debug menus
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true
# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"
# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false
# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false
# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
# Disable Java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true


###############################################################################
# Photos                                                                      #
###############################################################################
# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


###############################################################################
# Transmission.app                                                            #
###############################################################################
# Use `/Volumes/RamDisk` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "/Volumes/RamDisk"
# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false
# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false
# IP block list.
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
# Randomize port on launch
defaults write org.m0k.transmission RandomPort -bool true


###############################################################################
# Other                                                                       #
###############################################################################
# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 1
