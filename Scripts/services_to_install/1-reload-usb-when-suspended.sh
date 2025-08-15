#!/usr/bin/env bash

# This service is used to work around an apparent bug that freezes 
# keyboard and mouse inputs after waking from sleep.

SERVICE_NAME="reset-input-devices-after-sleep"

if [ -f /etc/systemd/system/$SERVICE_NAME.service ]; then
  echo "Service: $SERVICE_NAME already exists. Skipping..."
  exit 0
fi

cp $HOME/HyDE/Scripts/reset-input-devices.sh /usr/local/bin/
systemctl enable --now "$SERICE_NAME.service"
sudo chown root:root /usr/local/bin/reset-input-devices.sh
sudo chmod 744 /usr/local/bin/reset-input-devices.sh
sudo cp "$HOME/HyDE/Services/$SERICE_NAME.service" /etc/systemd/system/
