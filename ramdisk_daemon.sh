#!/bin/sh

CACHEDIR="/Volumes/RamDisk/Cache"
CHROMECACHE="~/Library/Caches/Google/Chrome/Default"
ITUNESCACHE="~/Library/Caches/com.apple.iTunes"

diskutil erasevolume HFS+ 'RamDisk' `hdiutil attach -nomount ram://15625000`
mkdir -pv $CACHEDIR/Google/Chrome/Default
mkdir -pv $CACHEDIR/Apple/iTunes

if [ -f $CHROMECACHE ] && [ ! -L $CHROMECACHE ] ; then
    ln -v -s $CACHEDIR/Google/Chrome/Default $CHROMECACHE
fi

if [ -f $ITUNESCACHE ] && [ ! -L $ITUNESCACHE ] ; then
    ln -v -s $CACHEDIR/Apple/iTunes $ITUNESCACHE
fi
