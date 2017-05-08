#!/usr/bin/env sh

killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

if [ $(hostname) = 'annedouwe-pc' ]; then
	xrandr --output HDMI1 --auto --left-of HDMI3
	MONITOR=HDMI-1 polybar -c $HOME/.polybar.conf bar &
	MONITOR=HDMI-3 polybar -c $HOME/.polybar.conf bar &
else
	MONITOR=eDP-1-1 polybar -c $HOME/.polybar.conf bar &
fi
