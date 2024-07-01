#!/bin/bash

# Set PS4 to print commands in bold green
export PS4='\e[1;32m+ \e[0m'

# Enable command tracing
set -x

sudo apt install -y fswebcam tig
sudo usermod -aG video $USER

# Enable the legacy camera support
sudo raspi-config nonint do_legacy 0
