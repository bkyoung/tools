#!/bin/bash

LATEST_VERSION=$(curl -s http://download.virtualbox.org/virtualbox/LATEST.TXT)
INSTALLED_VERSION=$(vboxmanage --version | cut -dr -f1)

function download() {
    echo -n "Downloading $1 ... "
    curl -sL -o /tmp/VirtualBox.dmg http://download.virtualbox.org/virtualbox/${LATEST_VERSION}/$1
    echo "DONE"
}

function install_vbox() {
    echo -n "Mounting DMG ... "
    hdiutil attach /tmp/VirtualBox.dmg
    echo "DONE"
    echo -n "Running installer ... "
    sudo installer -package /Volumes/VirtualBox/VirtualBox.pkg -target /Volumes/Macintosh\ HD
    echo "DONE"
    echo -n "Unmounting DMG ... "
    hdiutil detach /Volumes/VirtualBox/
    echo "DONE"
}

function install_extension_pack() {
    curl -sL -o /tmp/VBoxExtensionPack.extpack http://download.virtualbox.org/virtualbox/${LATEST_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${LATEST_VERSION}.vbox-extpack
}

if [[ "$INSTALLED_VERSION" == "$LATEST_VERSION" ]];then
    echo "You have the latest version installed.  Nothing to do."
else
    FILENAME=$(xmllint http://download.virtualbox.org/virtualbox/${LATEST_VERSION}/ --html --xpath "string(//a[contains(@href, 'OSX')])")
    download $FILENAME
    install_vbox $FILENAME
    install_extension_pack
fi
