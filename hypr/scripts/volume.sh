#!/bin/bash

# argument: +5% or -5%
pactl set-sink-volume @DEFAULT_SINK@ "$1"
VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1)
dunstify -r 2593 -u low "Volume: $VOL" -h int:value:${VOL%\%} -h string:synchronous:volume
