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
# Security                                                                    #
###############################################################################
# Disable remote apple events
# sudo systemsetup -setremoteappleevents off
# Disable remote login
sudo systemsetup -setremotelogin off
# Disable wake-on LAN
sudo systemsetup -setwakeonnetworkaccess off
# Do not show password hints
sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0
# Disable guest account login
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
osascript -e 'tell application "System Events" to set require password to wake of security preferences to true'


###############################################################################
# Dock                                                                        #
###############################################################################
# Set the icon size of Dock items to 32 pixels
defaults write com.apple.dock "tilesize" -int "48"
# Autohide the Dock when the mouse is out
defaults write com.apple.dock "autohide" -bool "true"
# Remove the autohide delay, the Dock appears instantly
defaults write com.apple.dock "autohide-delay" -float "0"
# Do not display recent apps in the Dock
defaults write com.apple.dock "show-recents" -bool "false"
#Change minimize/maximize window effect
defaults write com.apple.dock "mineffect" -string "scale"
# Minimize windows into their application’s icon
defaults write com.apple.dock "minimize-to-application" -bool "true"
# Enable spring loading for all Dock items
defaults write com.apple.dock "enable-spring-load-actions-on-all-items" -bool "true"
# Set Dock zoom size
defaults write com.apple.dock "magnification" -int "0"
# Lock dock size
defaults write com.apple.Dock "size-immutable" -bool "true"
# Disable bouncing
defaults write com.apple.dock "no-bouncing" -bool "true"

# Rearrange icons in dock
dockutil --remove all --no-restart
dockutil --add "/Applications/Safari.app" --no-restart
dockutil --add "/Applications/Telegram Desktop.app" --no-restart
dockutil --add "/Applications/WhatsApp.app" --no-restart
dockutil --add "/Applications/Discord.app" --no-restart
dockutil --add "/Applications/TextEdit.app" --no-restart
dockutil --add "/Applications/Notes.app" --no-restart
dockutil --add "/Applications/Calendar.app" --no-restart
dockutil --add "/Applications/Maps.app" --no-restart
dockutil --add "/Applications/App Store.app" --no-restart
dockutil --add "/Applications/System Preferences.app" --no-restart
dockutil --add "/Applications/Utilities/Terminal.app" --no-restart
dockutil --add "/Applications/MacDown.app" --no-restart
dockutil --add "/Applications/Sublime Text.app" --no-restart
dockutil --add "/Applications" --view grid --display folder --sort name --no-restart
dockutil --add "$HOME/Projects" --view grid --display folder --sort name --no-restart
dockutil --add "$HOME/Downloads" --view grid --display folder --sort dateadded


###############################################################################
# Screenshots                                                                 #
###############################################################################
defaults write com.apple.screencapture "disable-shadow" -bool "false"
defaults write com.apple.screencapture "include-date" -bool "false"
defaults write com.apple.screencapture "show-thumbnail" -bool "false"
defaults write com.apple.screencapture "type" -string "png"


###############################################################################
# Safari                                                                      #
###############################################################################
defaults write com.apple.safari "ShowFullURLInSmartSearchField" -bool "true"


###############################################################################
# Finder                                                                      #
###############################################################################
# Show all file extensions inside the Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
# Show path bar
defaults write com.apple.finder "ShowPathbar" -bool "true"

# Use list view in all Finder windows by default
# Flwv: Cover Flow View
# Nlsv: List View
# clmv: Column View
# icnv: Icon View
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

# Keep folders on top when sorting by name
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Do not display a warning when changing a file extension
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
# Hide icon from the title bar
defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "false"
# Remove the delay when hovering the toolbar title
defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0"
# Set a smaller size of Finder sidebar icons
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"

# Unhide User Library Folder
# chflags nohidden ~/Library
# Unhide Volumes Folder
# sudo chflags nohidden /Volumes
# Desktop Show Internal Media
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool "true"
# Desktop Show External Media
defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool "true"
# Desktop Show Mounted Server
defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool "false"
# Desktop Show Removable Media
defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool "true"
# Allow text selection in QuickLook
defaults write com.apple.finder "QLEnableTextSelection" -bool "true"

# Show status bar
defaults write com.apple.finder "ShowStatusBar" -bool "false"

# Set default Finder path
# For desktop, use `PfDe`
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder "NewWindowTarget" -string "PfHm"
defaults write com.apple.finder "NewWindowTargetPath" -string "file://${HOME}/"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
# Set grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 28" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 28" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 28" ~/Library/Preferences/com.apple.finder.plist
# Set the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
# Remove all tags from contextual menu
/usr/libexec/PlistBuddy -c "Delete :FavoriteTagNames" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FavoriteTagNames array" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add :FavoriteTagNames:0 string" ~/Library/Preferences/com.apple.finder.plist
# TODO:Configure Finder Toolbar
# /usr/libexec/PlistBuddy -c "Delete :NSToolbar\\ Configuration\\ Browser:TB\\ Item\\ Identifiers" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ Browser:TB\\ Item\\ Identifiers array" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ Browser:TB\\ Item\\ Identifiers:0 string com.apple.finder.BACK" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ Browser:TB\\ Item\\ Identifiers:1 string NSToolbarFlexibleSpaceItem" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ Browser:TB\\ Item\\ Identifiers:2 string com.apple.finder.SWCH" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ Browser:TB\\ Item\\ Identifiers:3 string NSToolbarFlexibleSpaceItem" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Add :NSToolbar\\ Configuration\\ Browser:TB\\ Item\\ Identifiers:4 string com.apple.finder.SRCH" ~/Library/Preferences/com.apple.finder.plist

mysides remove all
mysides add "Machintosh HD" "file:///"
mysides add "Home" "file:///Users/$USER"
mysides add "Applications" "file:///Applications"
mysides add "Desktop" "file:///Users/$USER/Desktop"
mysides add "Documents" "file:///Users/$USER/Documents"
mysides add "Downloads" "file:///Users/$USER/Downloads"
mysides add "Projects" "file:///Users/$USER/Projects"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Speed up Mission Control animations
defaults write com.apple.dock "expose-animation-duration" -float "0.1"
# Don’t group windows by application in Mission Control
defaults write com.apple.dock "expose-group-by-app" -bool "false"
# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock "mru-spaces" -bool "false"
# Don’t show recent applications in Dock
defaults write com.apple.dock "show-recents" -bool "false"
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
# defaults write com.apple.dock wvous-tr-corner -int 7
# defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom Right screen corner -> Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0


###############################################################################
# Menu Bar                                                                    #
###############################################################################
# The time separator stays solid continuously.
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "false"
# Setup the menu bar date format
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm:ss"
defaults write com.apple.menuextra.clock ShowSeconds -bool "true"
# 24 hour time
defaults write com.apple.menuextra.clock Show24Hour -bool "true"



###############################################################################
# General UI/UX                                                               #
###############################################################################
# Set computer name (as done via System Preferences -> Sharing)
# sudo scutil --set ComputerName "Blackwut"
# sudo scutil --set HostName "Blackwut"
# sudo scutil --set LocalHostName "Blackwut"
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "Blackwut"

# Set Dark Mode
defaults write NSGlobalDomain "AppleInterfaceStyle" -string "Dark"
# Show Bluetooth icon on Menu Bar
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool "true"


# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain "NSWindowResizeTime" -float "0.001"
# Expand save panel by default
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode" -bool "true"
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode2" -bool "true"
# Expand print panel by default
defaults write NSGlobalDomain "PMPrintingExpandedStateForPrint" -bool "true"
defaults write NSGlobalDomain "PMPrintingExpandedStateForPrint2" -bool "true"
# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool "true"
# Disable Resume system-wide
defaults write com.apple.systempreferences "NSQuitAlwaysKeepsWindows" -bool "false"
# Disable the system alert sound
defaults write NSGlobalDomain com.apple.sound.beep.volume -int 0
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0
# Enable volume change feedback
defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool true
# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true
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
# Activity Monitor                                                            #
###############################################################################
defaults write com.apple.ActivityMonitor "UpdatePeriod" -int "1"


###############################################################################
# TextEdit                                                                    #
###############################################################################
# TextEdit PlainTextMode enable
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


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
defaults write org.m0k.transmission IncompleteDownloadFolder -string "$HOME/Downloads"
# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false
# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool false
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
# PMSET - NVRAM - SYSTEMSETUP                                                 #
###############################################################################
# Set display sleep to 1 minute
sudo pmset -a displaysleep 1
# Disable wake on ethernet magic packet
sudo pmset -a womp 0
# Disable slightly turn down display brightness on battery
sudo pmset -a lessbright 0
# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "
# Never go into computer sleep mode
# sudo systemsetup -setcomputersleep Off > /dev/null


###############################################################################
# SSD Tweaks                                                                  #
###############################################################################
# Disable Creation of .DS_Store Files on Network Volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Disable Creation of .DS_Store Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


###############################################################################
# Time Machine                                                                #
###############################################################################
# Time machine backup disable
sudo tmutil disable
# Prevent Time Machine from Prompting to use new HD as backup
# sudo defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true



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
# defaults -currentHost write com.apple.universalaccess closeViewScrollWheelModifiersInt 1048576
# defaults -currentHost write com.apple.universalaccess closeViewScrollWheelPreviousToggle 1
# defaults -currentHost write com.apple.universalaccess closeViewScrollWheelToggle 1
# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15



# TODO: everything for trackpad
###############################################################################
# Trackpad                                                                    #
###############################################################################
# Map three finger tap to look-up dictionary
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerTapGesture" -int "2"
# Map bottom right corner to right-click
defaults write com.apple.AppleMultitouchTrackpad "TrackpadCornerSecondaryClick" -int "2"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadCornerSecondaryClick" -int "2"
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad "Clicking" -bool "true"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad  "Clicking" -bool "true"
# Click threshold
defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "0"
defaults write com.apple.AppleMultitouchTrackpad "SecondClickThreshold" -int "0"
# Trackpad Speed
defaults write NSGlobalDomain "com.apple.trackpad.scaling" -float "1.5"
# Swipe Scroll Direction (Lion-style)
defaults write NSGlobalDomain com.apple.swipescrolldirection -int "1"
# Mission Control with 3 and 4 firgers swiping up
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerVertSwipeGesture" -int "2"
defaults write com.apple.AppleMultitouchTrackpad "TrackpadFourFingerVertSwipeGesture" -int "2"
defaults write com.apple.dock "showMissionControlGestureEnabled" -bool "false";
# Disable Expose' and Launchpad gestures
defaults write com.apple.dock "showAppExposeGestureEnabled" -bool "false";
defaults write com.apple.dock "showLaunchpadGestureEnabled" -bool "false";
# Disable shake to magnify cursor
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true


defaults write com.apple.Spotlight orderedItems -array \
    '{ enabled = 1; name = APPLICATIONS; }' \
    '{ enabled = 0; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }' \
    '{ enabled = 1; name = "MENU_CONVERSION"; }' \
    '{ enabled = 1; name = "MENU_EXPRESSION"; }' \
    '{ enabled = 1; name = "MENU_DEFINITION"; }' \
    '{ enabled = 1; name = "SYSTEM_PREFS"; }' \
    '{ enabled = 1; name = DOCUMENTS; }' \
    '{ enabled = 0; name = DIRECTORIES; }' \
    '{ enabled = 0; name = PRESENTATIONS; }' \
    '{ enabled = 0; name = SPREADSHEETS; }' \
    '{ enabled = 1; name = PDF; }' \
    '{ enabled = 0; name = MESSAGES; }' \
    '{ enabled = 0; name = CONTACT; }' \
    '{ enabled = 0; name = "EVENT_TODO"; }' \
    '{ enabled = 0; name = IMAGES; }' \
    '{ enabled = 0; name = BOOKMARKS; }' \
    '{ enabled = 0; name = MUSIC; }' \
    '{ enabled = 0; name = MOVIES; }' \
    '{ enabled = 0; name = FONTS; }' \
    '{ enabled = 0; name = "MENU_OTHER"; }' \
    '{ enabled = 1; name = SOURCE; }'
# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null


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