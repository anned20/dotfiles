#!/usr/bin/env bash

killall -q i3bar
killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

MONITOR=HDMI-1 polybar -c ~/.polybar.conf bar &
MONITOR=HDMI-2 polybar -c ~/.polybar.conf bar &
