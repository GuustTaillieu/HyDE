#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed zsh starship eza fzf curl unzip gzip

git clone https://github.com/zsh-users/zsh-completions.git \
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
