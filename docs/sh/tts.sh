#!/bin/bash
file=$(mktemp)
curl -sL -X POST --header "Content-Type: application/json" --header "Accept: audio/wav" --data '{"text":"'"$*"'"}' -u "apikey:$(jq -r '.apikey' ~/.watson.text-to-speech.json)" "$(jq -r '.url' ~/.watson.text-to-speech.json)/v1/synthesize?voice=en-US_MichaelVoice" --output ${file}.wav
rm -f output.wav
ffmpeg -i ${file}.wav -ar 44100 output.wav
rm -f ${file}.wav
