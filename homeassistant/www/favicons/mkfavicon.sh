#!/bin/bash

convert ${1:-$(read -p "Image?")} -alpha off -resize 256x256 -define icon:auto-resize="256,128,96,64,48,32,16" favicon.ico
