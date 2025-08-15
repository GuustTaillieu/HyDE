#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed auto-cpufreq
systemctl enable --now auto-cpufreq
