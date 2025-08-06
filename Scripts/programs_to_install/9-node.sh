#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed nodejs

# install nvm (node version manager)
if ! command -v nvm > /dev/null 2>&1; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
	export NVM_DIR="$HOME/.config/nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# install nvm (node version manager)
if ! command -v npm > /dev/null 2>&1; then
	nvm install --lts
fi


# install pnpm
if ! command -v pnpm > /dev/null 2>&1; then
	curl -fsSL https://get.pnpm.io/install.sh | sh -
fi
