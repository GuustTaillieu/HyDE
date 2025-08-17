#!/usr/bin/env bash

# THIS WILL BE THE DESCRIPTION

# TODO: WARNING - This is just an example


# TODO: Give this file a good name, it will be used as the name for the service!
FILE_NAME="${0%.*}"
SERVICE_NAME="${FILE_NAME#*-}"
#
# if [ -f /etc/systemd/system/$SERVICE_NAME.service ]; then
#   echo "Service: $SERVICE_NAME already exists. Skipping..."
#   exit 0
# fi


# TODO: Place a script with the same name in $HOME/HyDE/Scripts

# cp "$HOME/HyDE/Scripts/$SERVICE_NAME.sh" /usr/local/bin/
# sudo chown root:root "/usr/local/bin/$SERVICE_NAME.sh"
# sudo chmod 744 "/usr/local/bin/$SERVICE_NAME.sh"

# TODO: Make a service file to determine when to run the script

# sudo cp "$HOME/HyDE/Services/$SERICE_NAME.service" /etc/systemd/system/
# systemctl enable --now "$SERICE_NAME.service"
