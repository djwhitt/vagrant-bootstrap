#!/bin/bash

# Update to latest packages
sudo apt-get update
sudo apt-get upgrade

# Install essentials + a couple useful extras
sudo apt-get -y install \
  autoconf \
  build-essential \
  curl \
  git-core \
  libreadline5-dev \
  libssl-dev \
  linux-headers-$(uname -r) \
  vim \
  zlib1g-dev

# Add insecure Vagrant key to authorized_keys
mkdir -p $HOME/.ssh
curl https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub > $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

# Disable generation of RI and Rdoc
sudo bash -c 'echo "gem: --no-ri --no-rdoc" > /etc/gemrc'

# Install RVM
sudo bash < <( curl -L http://bit.ly/rvm-install-system-wide )
sudo bash -c 'echo >> /etc/bash.bashrc'
sudo bash -c 'echo "source /usr/local/lib/rvm" >> /etc/bash.bashrc'
source /usr/local/lib/rvm

# Add Vagrant user to RVM groups
sudo usermod -a -G rvm vagrant

# Install REE
sudo rvm install ree

# Set default Ruby
sudo rvm --default ree

# Install Chef
sudo gem install chef
sudo gem install thin
sudo gem install fast_xs

# Create Chef Solo config
cat > /tmp/solo.rb <<EOF
file_cache_path "/tmp/chef-solo"
cookbook_path "/tmp/chef-solo/cookbooks"
recipe_url "http://s3.amazonaws.com/chef-solo/bootstrap-latest.tar.gz"
EOF

# Create Chef server bootstrap config
cat > /tmp/chef-server.json <<EOF
{
  "bootstrap": {
    "chef": {
      "server_url": "http://localhost:4000",
      "webui_enabled": true
    }
  },
  "run_list": [ "recipe[chef::bootstrap_server]" ]
}
EOF

# Bootstrap Chef server
cd /tmp
rvmsudo chef-solo -c /tmp/solo.rb -j /tmp/chef-server.json

# Do the following manually:
# 1. Change %admin line to:
#   %admin ALL=NOPASSWD: ALL
# 2. Install guest additions
#   - Devicek > Install Guest Additions...
#   - sudo mount /dev/cdrom /media/cdrom
#   - sudo sh /media/cdrom/VBoxLinuxAdditions.run
#   - sudo umount /media/cdrom
# 3. Set hostname
