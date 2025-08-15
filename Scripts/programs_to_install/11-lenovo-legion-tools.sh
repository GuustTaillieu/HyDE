#!/usr/bin/env bash

sudo pacman -S linux-headers base-devel lm_sensors git dmidecode python-pyqt6 python-yaml python-argcomplete python-darkdetect
# Install the following for installation with DKMS
sudo pacman -S dkms openssl mokutil

sudo pacman -S --noconfirm --needed lenovolegionlinux-git lenovolegionlinux-dkms-git

# Check if tools already exist
if [ -d $HOME/temp/LenovoLegionLinux/ ]; then
  echo "Lenovo tools are already installed. Skipping..."
  exit 0
fi

# Build + Testing
mkdir -p $HOME/temp
git clone https://github.com/johnfanv2/LenovoLegionLinux.git $HOME/temp

pushd $HOME/temp/LenovoLegionLinux/kernel_module
make
sudo make reloadmodule
popd

pushd $HOME/temp/LenovoLegionLinux/
sudo mkdir -p /usr/src/LenovoLegionLinux-1.0.0
sudo cp ./kernel_module/* /usr/src/LenovoLegionLinux-1.0.0 -r
sudo dkms add -m LenovoLegionLinux -v 1.0.0
sudo dkms build -m LenovoLegionLinux -v 1.0.0
popd
