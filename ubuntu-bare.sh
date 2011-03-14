#!/bin/bash

# Update to latest packages
sudo apt-get update
sudo apt-get upgrade

# Install essentials + a couple useful extras
sudo apt-get -y install \
  build-essential \
  curl \
  linux-headers-$(uname -r) \
  vim

# Add insecure Vagrant key to authorized_keys
mkdir -p $HOME/.ssh
curl https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub > $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

# Do the following manually:
# 1. Change %admin line to:
#   %admin ALL=NOPASSWD: ALL
# 2. Install guest additions
#   - Devices > Install Guest Additions...
#   - sudo mount /dev/cdrom /media/cdrom
#   - sudo sh /media/cdrom/VBoxLinuxAdditions.run
#   - sudo umount /media/cdrom
# 3. Set hostname
