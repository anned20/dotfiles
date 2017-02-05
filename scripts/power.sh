input=$(echo "Shutdown\nReboot\nSuspend\nCancel" | rofi -show -dmenu)

if [ $input = 'Shutdown' ]; then
	shutdown now
elif [ $input = 'Reboot' ]; then
	reboot
elif [ $input = 'Suspend' ]; then
	pm-suspend
elif [ $input = 'Cancel' ]; then
	exit
fi
