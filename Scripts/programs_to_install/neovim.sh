#!/usr/bin/env bash

# ALWAYS UPDATE SYSTEM !!
sudo pacman -Syu

sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim

git clone git@github.com:GuustTaillieu/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
