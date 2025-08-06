#!/usr/bin/env bash

sudo pacman -Rns spotify
sudo pacman -S --noconfirm --needed spotify-launcher spicetify-cli

sudo chmod a+wr $HOME/.local/share/spotify-launcher/install/usr/share/spotify/
sudo chmod a+wr $HOME/.local/share/spotify-launcher/install/usr/share/spotify/Apps -R

spicetify update
