#!/usr/bin/env bash

if csrutil status | grep -q enabled; then
    echo "Please disable System Integrity Protection (SIP) by following sleepimage.sh script description."
    exit
fi

if command -v dockutil; then
    echo "Please install dockutil"
    exit
fi

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


###############################################################################
# General UI/UX                                                               #
###############################################################################
# Set computer name (as done via System Preferences -> Sharing)
sudo scutil --set ComputerName "BlackwutMac"
sudo scutil --set HostName "Blackwut"
sudo scutil --set LocalHostName "Blackwut"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "Blackwut"

# Set sidebar icon size to small
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1
# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user #
# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2
# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true
# Turn Bluetooth off.
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
# Disable the system alert sound
defaults write NSGlobalDomain com.apple.sound.beep.volume -int 0
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0
# Enable volume change feedback
defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool true
# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true
# Show menu extras
defaults write com.apple.systemuiserver menuExtras -array \
    "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
    "/System/Library/CoreServices/Menu Extras/Clock.menu" \
    "/System/Library/CoreServices/Menu Extras/Battery.menu"

# Setup the menu bar date format
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm:ss"
# Flash the : in the menu bar
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
# 24 hour time
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Shows ethernet connected computers in airdrop
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Disable all actions when inserting disks
defaults write com.apple.digihub com.apple.digihub.blank.bd.appeared -dict-add action -int 1
defaults write com.apple.digihub com.apple.digihub.blank.cd.appeared -dict-add action -int 1
defaults write com.apple.digihub com.apple.digihub.blank.dvd.appeared -dict-add action -int 1
defaults write com.apple.digihub com.apple.digihub.cd.music.appeared -dict-add action -int 1
defaults write com.apple.digihub com.apple.digihub.dvcamera.IIDC.appeared -dict-add action -int 1
defaults write com.apple.digihub com.apple.digihub.dvcamera.IIDC.irisopened -dict-add action -int 1
defaults write com.apple.digihub com.apple.digihub.dvd.video.appeared -dict-add action -int 1

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true


###############################################################################
# PMSET - NVRAM - SYSTEMSETUP                                                 #
###############################################################################
# Disable Sudden Motion Sensor
sudo pmset -a sms 0
# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0
# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400
# Disable sleep
sudo pmset -a sleep 0
# Disable disk spindown timer
sudo pmset -a disksleep 0
# Set display sleep to 1 minute
sudo pmset -a displaysleep 1
# Disable wake on ethernet magic packet
sudo pmset -a womp 0
# Disable autorestart on power loss
sudo pmset -a autorestart 0
# Disable  slightly turn down display brightness on battery
sudo pmset -a lessbright 0
# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "
# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null


###############################################################################
# SSD Tweaks                                                                  #
###############################################################################
# Disable Creation of .DS_Store Files on Network Volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Disable Creation of .DS_Store Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Save screenshots to the RamDisk
defaults write com.apple.screencapture location -string "/Volumes/RamDisk"
# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true


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
# Enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Disable three finger tap
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerTapGesture -int 0
# Trackpad: 'smart zoom' two finger double tap
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.twoFingerDoubleTapGesture -int 0
# Trackpad: disable swipe from right to show notification center
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 0
# Mouse: TwoButton mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseButtonMode -string "TwoButton"
# Map bottom right corner to right-click [To be checked]
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
# Disable “natural” (Lion-style) scrolling
defaults write -g com.apple.swipescrolldirection -bool false
# Disable El Capitan shake to magnify cursor
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true


###############################################################################
# Keyboard                                                                    #
###############################################################################
# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# Use scroll gesture with the Command modifier key to zoom
defaults -currentHost write com.apple.universalaccess closeViewScrollWheelModifiersInt 1048576
defaults -currentHost write com.apple.universalaccess closeViewScrollWheelPreviousToggle 1
defaults -currentHost write com.apple.universalaccess closeViewScrollWheelToggle 1
# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15


###############################################################################
# Finder                                                                      #
###############################################################################
# Unhide User Library Folder
chflags nohidden ~/Library
# Desktop Show Internal Media
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# Desktop Show External Media
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# Desktop Show Mounted Server
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
# Desktop Show Removable Media
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Allow text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true

# Don't use tabs in Finder
defaults write com.apple.finder AppleWindowTabbingMode -string "manual"

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Enable spring loading for directories
defaults write -g com.apple.springing.enabled -bool true
# Remove the spring loading delay for directories
defaults write -g com.apple.springing.delay -float 0

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true

# Set default Finder path
# For desktop, use `PfDe`
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
# Set grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 48" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 48" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 48" ~/Library/Preferences/com.apple.finder.plist
# Set the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
# Remove all tags from contextual menu
/usr/libexec/PlistBuddy -c "Delete :FavoriteTagNames" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FavoriteTagNames array" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FavoriteTagNames:0 string" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Flwv: Cover Flow View
# Nlsv: List View
# clmv: Column View
# icnv: Icon View
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Setting up Finder Sidebar
python - <<EOF
from FinderSidebarEditor import FinderSidebar
sidebar = FinderSidebar()
sidebar.removeAll()
sidebar.add("/Users/blackwut/Projects")
sidebar.add("/Users/blackwut/Dropbox")
sidebar.add("/Applications")
sidebar.add("/Users/blackwut")
sidebar.add("/Volumes/RamDisk")
sidebar.add("/Volumes/Mojave")
EOF

# Removing .DS_Store files
echo "Removing .DS_Store files everywhere to update PreferredViewStyle in all directories... (this may take a while)"
sudo find / -name .DS_Store -delete 2> /dev/null

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1
# Don’t group windows by application in Mission Control
defaults write com.apple.dock expose-group-by-app -bool false
# Show Dashboard as a Space
defaults write com.apple.dashboard db-enabled-state -int 3
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
# Top left screen corner -> Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner -> Dashboard
defaults write com.apple.dock wvous-tr-corner -int 7
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom Right screen corner -> Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

# Install iStatPro and configure it
cp -r iStatPro.wdgt ~/Library/Widgets/iStatPro.wdgt
plutil -convert binary1 -o - "./preferences/widget-com.iSlayer.iStatpro4.widget.plist" > ~/"Library/Preferences/widget-com.iSlayer.iStatpro4.widget.plist"
plutil -convert binary1 -o - "./preferences/com.apple.dashboard.plist" > ~/"Library/Preferences/com.apple.dashboard.plist"


###############################################################################
# Dock                                                                        #
###############################################################################
# Set the icon size of Dock items to 32 pixels
defaults write com.apple.dock tilesize -int 32
# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"
# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true
# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool false
# Set Dock zoom size
defaults write com.apple.dock magnification -int 0

# Rearrange icons in dock
dockutil --remove all
dockutil --add "/Applications/Safari.app"
dockutil --add "/Applications/Telegram Desktop.app"
dockutil --add "/Applications/Discord.app"
dockutil --add "/Applications/TextEdit.app"
dockutil --add "/Applications/Notes.app"
dockutil --add "/Applications/Calendar.app"
dockutil --add "/Applications/Maps.app"
dockutil --add "/Applications/iTunes.app"
dockutil --add "/Applications/App Store.app"
dockutil --add "/Applications/System Preferences.app"
dockutil --add "/Applications/Utilities/Terminal.app"
dockutil --add "/Applications/HSTracker.app"
dockutil --add "/Applications/Battle.net.app"
dockutil --add "/Applications/Sublime Text.app"
dockutil --add "/Applications" --view grid --display folder --sort name
dockutil --add "$HOME/Projects" --view grid --display folder --sort name
dockutil --add "$HOME/Downloads" --view grid --display folder --sort dateadded



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
    '{"enabled" = 0; "name" = "SOURCE";}' \
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
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


###############################################################################
# Safari [Doesn't Work]                                                       #
###############################################################################
# Tell Safari to open new window links in tabs
defaults write com.apple.Safari TargetedClicksCreateTabs -bool true
# Reduce delay when rendering pages
defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.1
# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
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
# Show Safari’s favorites bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool true
# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"
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
# iTunes                                                                      #
###############################################################################
# stop running an automatic backup when you plug in an iOS device
defaults write com.apple.iTunes AutomaticDeviceBackupsDisabled -bool true


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
# Updates                                                                     #
###############################################################################
# Disable automatic update & download
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool 


###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
    "cfprefsd" \
    "Dock" \
    "Finder" \
    "Photos" \
    "Safari" \
    "SystemUIServer"; do
    killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."