#!/usr/bin/env bash

# ALWAYS UPDATE SYSTEM !!
sudo pacman -Syu --needed --noconfirm
sudo pacman -S --needed --noconfirm mkinitcpio-firmware
