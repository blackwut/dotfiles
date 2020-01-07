#!/bin/sh

RAM_CACHE="/Volumes/RamDisk/Cache"
RAM_ITUNES="$RAM_CACHE/Apple/iTunes"
RAM_CHROME="$RAM_CACHE/Google/Chrome/Default"

DIR_ITUNES=~/"Library/Caches/com.apple.iTunes"
DIR_CHROME=~/"Library/Caches/Google/Chrome/Default"

diskutil erasevolume HFS+ 'RamDisk' `hdiutil attach -nomount ram://15625000`
mkdir -pv "$RAM_ITUNES"
mkdir -pv "$RAM_CHROME"

if [[ -d "$DIR_ITUNES" ]] && [[ ! -h "$DIR_ITUNES" ]]; then
	echo "Moving iTunes Cache to RamDisk..."
	rm -r "$DIR_ITUNES"
    ln -sv "$RAM_ITUNES" "$DIR_ITUNES"
fi


if [[ -d "$DIR_CHROME" ]] && [[ ! -h "$DIR_CHROME" ]]; then
	echo "Moving Chrome Cache to RamDisk..."
	rm -r "$DIR_CHROME"
    ln -sv "$RAM_CHROME" "$DIR_CHROME"
fi

unset RAM_CACHE
unset RAM_ITUNES
unset RAM_CHROME
unset DIR_ITUNES
unset DIR_CHROME
