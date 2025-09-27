#!/usr/bin/env bash

# Kvm switches are sometimes not working properly when the system starts
# This script will reset the keyboard and mouse inputs when the system starts

FILE_NAME="${0%.*}"
SERVICE_NAME="${FILE_NAME#*-}"

if [ -f /etc/systemd/system/$SERVICE_NAME.service ]; then
  echo "Service: $SERVICE_NAME already exists. Skipping..."
  exit 0
fi


sudo cp "$HOME/HyDE/Scripts/$SERVICE_NAME.sh" /usr/local/bin/
sudo chown root:root "/usr/local/bin/$SERVICE_NAME.sh"
sudo chmod 744 "/usr/local/bin/$SERVICE_NAME.sh"

sudo cp "$HOME/HyDE/Services/$SERVICE_NAME.service" /etc/systemd/system/
sudo systemctl enable --now "$SERVICE_NAME.service"
