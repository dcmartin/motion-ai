#!/bin/bash

if [ ! -z $(command -v "xset") ]; then
  echo "Installing X Window System; $(sudo apt install --no-install-recommends -qq -y xserver-xorg xinit x11-xserver-utils)" >&2
  exit 1
fi

if [ ! -z $(command -v "matchbox-window-manager") ]; then
  echo "Installing matchbox window manager; $(sudo apt install -qq -y matchbox-window-manager xautomation)" >&2
  exit 1
fi

if [ ! -z $(command -v "unclutter") ]; then
  echo "Installing unclutter; $(sudo apt install -qq -y unclutter)" >&2
  exit 1
fi

if [ ! -z $(command -v "chromium-browser") ]; then
  echo "Installing Chromium browser; $(sudo apt install -qq -y chromium-browser)" >&2
  exit 1
fi

xset -dpms     # disable DPMS (Energy Star) features.
xset s off     # disable screen saver
xset s noblank # don't blank the video device
matchbox-window-manager -use_titlebar no &
unclutter &    # hide X mouse cursor unless mouse activated
chromium-browser --display=:0 --kiosk --incognito --window-position=0,0 http://reelyactive.github.io/diy/pi-kiosk/
