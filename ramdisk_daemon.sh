#!/bin/sh

CACHEDIR="/Volumes/RamDisk/Cache"
ITUNES=$CACHEDIR"/Apple/iTunes"
CHROME=$CACHEDIR"/Google/Chrome/Default"
SPOTIFY=$CACHEDIR"/Spotify"

CHROMECACHE="~/Library/Caches/Google/Chrome/Default"
ITUNESCACHE="~/Library/Caches/com.apple.iTunes"
SPOTIFYCACHE="~/Library/Caches/com.spotify.client"

diskutil erasevolume HFS+ 'RamDisk' `hdiutil attach -nomount ram://15625000`
mkdir -pv $CHROME
mkdir -pv $ITUNES
mkdir -pv $SPOTIFY

if [ -f $CHROMECACHE ] && [ ! -L $CHROMECACHE ] ; then
    ln -v -s $CHROME $CHROMECACHE
fi

if [ -f $ITUNESCACHE ] && [ ! -L $ITUNESCACHE ] ; then
    ln -v -s $ITUNES $ITUNESCACHE
fi

if [ -f $SPOTIFYCACHE ] && [ ! -L $SPOTIFYCACHE ] ; then
    ln -v -s $SPOTIFY $SPOTIFYCACHE
fi

