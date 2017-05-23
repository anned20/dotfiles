input=$(echo "Mobilox Members\nSibbenAPI\nOnderdelenZoeker\nEnter directory" | rofi -show -dmenu)
maincommand="vim"
misccommand=""

if [ "$input" = 'Mobilox Members' ]; then
	dir="/var/www/mobilox-members"
	misccommand="app/console a:w"
elif [ "$input" = 'SibbenAPI' ]; then
	dir="/var/www/sibbenapi"
elif [ "$input" = 'OnderdelenZoeker' ]; then
	dir="/var/www/onderdelenzoeker"
elif [ "$input" = 'Enter directory' ]; then
	dir=$(echo "" | rofi -show -dmenu)
fi

i3-msg 'append_layout ~/.i3/development.json' && termite -e "zsh -is eval 'cd $dir' && $maincommand" | termite -e "zsh -is eval 'cd $dir'" | termite -e "zsh -is eval 'cd $dir && $misccommand'"
