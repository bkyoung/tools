#!/bin/bash
set -e

LATEST=$(curl -sL https://download.virtualbox.org/virtualbox/LATEST.TXT)
DMG=$(curl -sSL https://download.virtualbox.org/virtualbox/${LATEST}/ | grep OSX | cut -d'"' -f2)
EXTPACK=$(curl -sSL https://download.virtualbox.org/virtualbox/6.1.0/ | grep Extension | cut -d'"' -f2 | head -n1)

cleanup() {
  rm -f $DMG
  rm -f $EXTPACK
}

trap cleanup EXIT

# Remove old downloads
[[ -f googlechrome.dmg ]] && rm -f googlechrome.dmg

# Download
echo -n "Downloading Virtualbox installer ... "
curl -sSL -o virtualbox.dmg https://download.virtualbox.org/virtualbox/${LATEST}/${DMG}
curl -sSLO https://download.virtualbox.org/virtualbox/${LATEST}/${EXTPACK}
echo "DONE"

# Mount DMG and Install It
echo -n "Installing Virtualbox ... "
/usr/bin/hdiutil attach -nobrowse -quiet -mountpoint /Volumes/Virtualbox virtualbox.dmg
sudo /usr/sbin/installer -pkg /Volumes/Virtualbox/VirtualBox.pkg -target /
/usr/bin/hdiutil eject -quiet "/Volumes/Virtualbox"
rm -f virtualbox.dmg
sudo VBoxManage extpack install $EXTPACK
rm $EXTPACK
echo "DONE"

