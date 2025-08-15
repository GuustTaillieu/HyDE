#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed zsh starship eza fzf zoxide curl unzip gzip man

if [ ! -d ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions ]; then
  git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
fi
