#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim tmux

# Custom neovim config from github
git clone git@github.com:GuustTaillieu/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# TMUX package manager
if [ ! -d $HOME/.tmux/plugins/tpm/ ]; then
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi
