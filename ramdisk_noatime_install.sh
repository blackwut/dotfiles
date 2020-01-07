#!/bin/bash

NOATIME_PLIST="com.nullvision.noatime.plist"
RAMDISK_PLIST="com.nullvision.ramdisk.plist"
RAMDISK_DAEMON="ramdisk_daemon.sh"

DIR_FILES="./ramdisk_noatime"
DIR_SCRIPTS=~/".scripts"
DIR_AGENTS=~/"Library/LaunchAgents"

RAMDISK_RAW_PLIST="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:</string>
        </dict>
    <key>Label</key>
        <string>com.nullvision.ramdisk</string>
    <key>Program</key>
        <string>/Users/$USER/.scripts/ramdisk_daemon.sh</string>
    <key>ProgramArguments</key>
        <array>
            <string>/Users/$USER/.scripts/ramdisk_daemon.sh</string>
        </array>
    <key>KeepAlive</key>
        <false/>
    <key>RunAtLoad</key>
        <true/>
    <key>LaunchOnlyOnce</key>
        <true/>
    <key>StandardOutPath</key>
        <string>/tmp/ramdisk.stdout</string>
    <key>StandardErrorPath</key>
        <string>/tmp/ramdisk.stderr</string>
</dict>
</plist>"

echo "$RAMDISK_RAW_PLIST" > "$DIR_FILES/$RAMDISK_PLIST"

mkdir -pv "$DIR_SCRIPTS"
mkdir -pv "$DIR_AGENTS"

if [[ -d $DIR_SCRIPTS ]] && [[ -d $DIR_AGENTS ]]; then
	cp "$DIR_FILES/$RAMDISK_DAEMON" "$DIR_SCRIPTS/$RAMDISK_DAEMON"
	chmod +x "$DIR_SCRIPTS/$RAMDISK_DAEMON"
	sudo cp "$DIR_FILES/$RAMDISK_PLIST" "$DIR_AGENTS/$RAMDISK_PLIST"
	sudo cp "$DIR_FILES/$NOATIME_PLIST" "$DIR_AGENTS/$NOATIME_PLIST"
	sudo launchctl load -w "$DIR_AGENTS/$RAMDISK_PLIST"
fi

unset NOATIME_PLIST
unset RAMDISK_PLIST
unset RAMDISK_DAEMON
unset DIR_FILES
unset DIR_AGENTS
unset DIR_SCRIPTS
unset RAMDISK_RAW_PLIST

