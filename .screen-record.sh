#!/bin/sh

if pidof wf-recorder; then
	notify-send 'Screen recorder' 'There is already an instance of wf-recorder running!'
	exit 1
fi

FILE="$HOME/recording_$(date +'%Y-%m-%d_%H:%M:%S.mp4')"
OUTPUT="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"
notify-send 'Screen recorder' "Starting! Recording output $OUTPUT"

wf-recorder \
	--codec h264_vaapi \
	--framerate 60 \
	--output "$OUTPUT" \
	--audio="$(pactl info | awk '/Default Sink:/ {print $3}').monitor" \
	--file "$FILE"

if [ $? -ne 0 ]; then
	notify-send 'Screen recorder' 'wf-recorder failed to start! See /tmp/wf-recorder.log'
	exit 1
fi

notify-send 'Screen recorder' "Finished! Video saved at $FILE"

