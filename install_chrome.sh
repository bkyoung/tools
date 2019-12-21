#!/bin/bash
set -e

# Clean up on exit
cleanup() { 
    rm -f googlechrome.dmg
    /usr/bin/hdiutil unmount "/Volumes/Google Chrome"
}

trap cleanup EXIT

# Remove old downloads
[[ -f googlechrome.dmg ]] && rm -f googlechrome.dmg

# Download
echo -n "Downloading Chrome installer ... "
curl -sSLO https://dl.google.com/chrome/mac/stable/CHFA/googlechrome.dmg
echo "DONE"

# Mount DMG and Install It
echo -n "Installing Chrome ... "
/usr/bin/hdiutil attach -nobrowse -quiet googlechrome.dmg
sudo cp -R "/Volumes/Google Chrome/Google Chrome.app" /Applications
/usr/bin/hdiutil eject "/Volumes/Google Chrome"
rm -f googlechrome.dmg
echo "DONE"
