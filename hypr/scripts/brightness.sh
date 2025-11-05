#!/bin/bash

# argument: +5% or -5%
brightnessctl set "$1"
VAL=$(brightnessctl g)
MAX=$(brightnessctl m)
PERC=$((VAL*100/MAX))
dunstify -r 2594 -u low "Brightness: $PERC%" -h int:value:$PERC -h string:synchronous:brightness
