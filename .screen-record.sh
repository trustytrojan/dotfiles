#!/bin/sh
# Script to make usage of wf-recorder more enjoyable using notify-send.

NOTIF_TITLE='Screen recorder'
LOGFILE='/tmp/screen-recorder.log'

output() {
	notify-send -t 3000 "Screen recorder" "$@"
	echo "$@" >>$LOGFILE
}

if pidof wf-recorder; then
	output 'There is already an instance of wf-recorder running!'
	exit 1
fi

# Get currently focused output
OUTPUT="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"

# Get PulseAudio default sink monitor
AUDIO_DEVICE="$(pactl info | awk '/Default Sink:/ {print $3}').monitor"

# Output video file
FILE="$HOME/recording_$(date +'%Y-%m-%d_%H:%M:%S.mp4')"

output "Starting! Recording output $OUTPUT"

# Record at 720p60 using VA-API for scaling and encoding
# Change this if your GPU does not support VA-API
wf-recorder \
	--codec h264_vaapi \
	--framerate 60 \
	--filter scale_vaapi=format=nv12,scale_vaapi=1280:720 \
	--output "$OUTPUT" \
	--audio="$AUDIO_DEVICE" \
	--file "$FILE" \
 	&>>"$LOGFILE"

if [ $? -ne 0 ]; then
	output "Failed to start wf-recorder! See $LOGFILE"
	exit 1
fi

output "Finished! Video saved at $FILE"
