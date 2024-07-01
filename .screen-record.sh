#!/bin/sh

NOTIF_TITLE='Screen recorder'
alias notify-send="notify-send '$NOTIF_TITLE' $@"

if pidof wf-recorder; then
	notify-send 'There is already an instance of wf-recorder running!'
	exit 1
fi

# Get currently focused output
OUTPUT="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"

# Get PulseAudio default sink monitor
AUDIO_DEVICE="$(pactl info | awk '/Default Sink:/ {print $3}').monitor"

# Output video file
FILE="$HOME/recording_$(date +'%Y-%m-%d_%H:%M:%S.mp4')"

# wf-recorder logfile
LOGFILE='/tmp/wf-recorder.log'

notify-send "Starting! Recording output $OUTPUT"

wf-recorder \
	--codec h264_vaapi \
	--framerate 60 \
	--output "$OUTPUT" \
	--audio="$AUDIO_DEVICE" \
	--file "$FILE" \
 	&>$LOGFILE

if [ $? -ne 0 ]; then
	notify-send "Failed to start! See $LOGFILE"
	exit 1
fi

notify-send "Finished! Video saved at $FILE"
