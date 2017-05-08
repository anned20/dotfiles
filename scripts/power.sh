input=$(echo "UREN LOGGEN\nLock\nLogout\nSuspend\nReboot\nShutdown\nCancel" | rofi -show -dmenu)

if [ $input = 'Shutdown' ]; then
	sm "UREN LOGGEN" && systemctl poweroff
elif [ $input = 'Reboot' ]; then
	systemctl reboot
elif [ $input = 'Suspend' ]; then
	sm "UREN LOGGEN" && systemctl suspend
elif [ $input = 'Logout' ]; then
	i3-msg exit	
elif [ $input = 'Lock' ]; then
	~/dotfiles/scripts/lock.sh
elif [ $input = 'Cancel' ]; then
	exit
fi
