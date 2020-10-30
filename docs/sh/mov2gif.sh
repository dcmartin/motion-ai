#!/bin/bash

ffmpeg -i "${1:-$(read -p "Image?")}" -filter_complex "[0:v] fps=12,scale=${2:-640}:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" "${1:-${REPLY}}.gif"
