#!/bin/bash
set -e

cleanup() {
  rm -f ClamXav_Current.pkg
}

# Clean Up Regardless of What Happens
trap cleanup EXIT

# Remove old downloads if they're present
[[ -f ClamXav_Current.pkg ]] && rm -f ClamXav_Current.pkg

# Download the latest ClamXAV Installer
echo -n "Downloading the latest ClamXav Installer ... "
curl -sSLO https://www.clamxav.com/downloads/ClamXav_Current.pkg
echo "DONE"

# Run the installer
echo -n "Please Enter Your "
sudo true

echo "Installing ClamXAV ... "
sudo /usr/sbin/installer -pkg ClamXav_Current.pkg -target /
echo "DONE"
