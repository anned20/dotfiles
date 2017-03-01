#!/usr/bin/env sh

killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

if [ $(hostname) = 'annedouwe-pc' ]; then
	MONITOR=VGA-0 polybar -c $HOME/.polybar.conf bar &
	MONITOR=DVI-0 polybar -c $HOME/.polybar.conf bar &
else
	polybar -c $HOME/.polybar.conf bar &
fi
