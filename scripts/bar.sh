#!/usr/bin/env bash

# Colour names
WHITE=ffffff
GRAY=666666
RED=ff0000
GREEN=00ff00

IFS=$'\n'

function text { output+=$(echo -n '{"full_text": "'${1//\"/\\\"}'", "color": "#'${3-$WHITE}'", "name": "'${2}'", "separator": false, "separator_block_width": 1}, ') ;}
function sensor { echo "$SENSORS" | awk '/^'${1}'/' RS='\n\n' | awk -F '[:. ]' '/'${2}':/{print$5}' ;}

info () {
	echo -e '{ "version": 1, "click_events": true }\n['
	while :; do
		WINDOW=( $(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d\  -f5) _NET_WM_NAME | sed 's/.*\ =\ "\|\",\ \".*\|"$//g;s/\\\"/"/g') )
		VOLUME=$(amixer -D pulse get Master | egrep -o "[0-9]+%" -m 1)
		MUTED=$(amixer -D pulse get Master | egrep -o "off" -m 1)
		SENSORS="$(sensors -Au)"
		SONG=$(playerctl metadata artist 2> /dev/null; printf " - "; playerctl metadata title 2> /dev/null)
		SONGSTATUS=$(playerctl status)
		LOAD=$(cat /proc/loadavg | awk '{print $1 ", " $2}')
		CPU=$(sensor coretemp-isa-0000 temp1_input) # amdk10
		RAM=$(awk '/MemTotal:/{total=$2}/MemAvailable:/{free=$2;print int(100-100/(total/free))}' /proc/meminfo)
		DATE=$(date '+%F %T')

		output=''

		# Window name
		if [[ $WINDOW == '' ]]; then
			text "Desktop" 'window'
		else
			text "$WINDOW" 'window'
		fi
		text ' | ' 'sep' $GRAY

		# Music
		text ' SONG ' 'song' $GRAY
		if [[ $SONG != '' && $SONGSTATUS == 'Playing' ]]; then
			text "${SONG:0:40}" 'song' $GREEN
		elif [[ $SONG != '' && $SONGSTATUS == 'Paused' ]]; then
			text "${SONG:0:40}" 'song' $GRAY
		else
			text 'Not playing' 'song' $GRAY
		fi
		text ' | ' 'sep' $GRAY

		# Volume
		text ' VOL ' 'volume' $GRAY
		if [[ $MUTED == 'off' ]]; then
			text 'muted' 'volume' $GRAY
		else
			text $VOLUME 'volume'
		fi
		text ' | ' 'sep' $GRAY

		# CPU and Load
		text ' CPU ' 'cpu' $GRAY
		if [[ $CPU -ge 70 ]]; then
			text "$CPU°c" 'cpu' $RED
		else
			text "$CPU°c" 'cpu'
		fi
		text ' | ' 'sep' $GRAY
		text ' LOAD ' 'load' $GRAY
		if [[ $(echo $LOAD | awk '{print $2}' | cut -d. -f1) -ge 4 ]]; then
			text "$LOAD" 'load' $RED
		else
			text "$LOAD" 'load'
		fi
		text ' | ' 'sep' $GRAY

		# RAM
		text ' RAM ' 'ram' $GRAY
		if [[ $RAM -ge 80 ]]; then
			text "$RAM%" 'ram' $RED
		else
			text "$RAM%" 'ram'
		fi
		text ' | ' 'sep' $GRAY

		# Date and time
		text ' TIME ' 'time' $GRAY
		text "$DATE" 'time'
		text ' | ' 'sep' $GRAY

		# Output
		echo -e "[${output%??}],"
		sleep 0.5
	done
}

info &

while read input; do 
	# Do not register this
	if [[ $input != '[' ]]; then
		val=${input}

		if [[ ${val:0:1} == ',' ]]; then
			val=${val:1}
		fi

		name=$(echo ${val}   | cut -d, -f1 | cut -d: -f2)
		button=$(echo ${val} | cut -d, -f2 | cut -d: -f2)
		x=$(($(echo ${val}   | cut -d, -f3 | cut -d: -f2) - 50))

		case $name in
			'"volume"' )
				if [[ $button == 4 ]]; then
					amixer -D pulse sset Master 5%+ > /dev/null 2>&1
				elif [[ $button == 5 ]]; then
					amixer -D pulse sset Master 5%- > /dev/null 2>&1
				elif [[ $button == 1 ]]; then
					amixer -D pulse sset Master toggle > /dev/null 2>&1
				elif [[ $button == 3 ]]; then
					pavucontrol
				fi
				;;
			'"time"' )
				yad --no-buttons --class="YADWIN" --geometry=+$x+40 --calendar > /dev/null 2>&1
				;;
			'"song"')
				if [[ $button == 1 ]]; then
					playerctl play-pause
				elif [[ $button == 4 ]]; then
					playerctl next
				elif [[ $button == 5 ]]; then
					playerctl previous
				fi
				;;
			'"load"')
				termite -e htop > /dev/null 2>&1
				;;
		esac
	fi
done
