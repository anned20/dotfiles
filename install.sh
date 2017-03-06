#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

link() {
	from="$1"
	to="$2"
	echo "Linking '$to' -> '$from'"
	rm -f $to
	ln -s "$from" "$to"
}

echo "${red}It is recommended to answer yes or y to all questions for everything to work properly!"
echo "${red}You may also need to type 'exit' after you got into the zsh shell to continue the installation"
read -p "${yellow}Press any key to continue..."

echo "${yellow}Installing Termite${green}"

wget -O - https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh | bash

echo "${yellow}Installing i3 deps and building${green}"

sudo add-apt-repository -y ppa:tjormola/i3-unstable
sudo apt-get update
sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-xinerama0-dev libxcb-xrm-dev
mkdir -p $HOME/tmp
git clone https://github.com/Airblader/i3.git $HOME/tmp/i3-gaps
cd $HOME/tmp/i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
cd $dotfiles

echo "${yellow}Installing polybar${green}"
sudo apt-get install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev
git clone --recursive https://github.com/jaagr/polybar ~/tmp/polybar
mkdir ~/tmp/polybar/build
cd ~/tmp/polybar/build
cmake ..
sudo make install
cd $dotfiles

echo "${yellow}Installing i3 addons${green}"

sudo apt-get install -y i3status i3lock xautolock scrot imagemagick feh thunar gvfs compton python-gtk2-dev rofi

echo "${yellow}Doing i3 stuff${green}"

link "$dotfiles/i3/" "$HOME/.i3"

echo "${yellow}Downloading and installing fonts${green}"

mkdir -p $HOME/tmp
wget https://www.fontsquirrel.com/fonts/download/roboto -P $HOME/tmp
mv $HOME/tmp/roboto $HOME/tmp/roboto.zip
sudo apt-get install -y unzip
sudo unzip $HOME/tmp/roboto.zip -d /usr/share/fonts
wget http://fontawesome.io/assets/font-awesome-4.7.0.zip -O ~/tmp/fontawesome.zip
unzip ~/tmp/fontawesome.zip
sudo cp font-awesome-4.7.0/fonts/fontawesome-webfont.ttf /usr/share/fonts/fontawesome.ttf
sudo fc-cache -f -v

echo "${yellow}Making it pretty${green}"

sudo apt-get install -y gtk2-engines-murrine gtk2-engines-pixbuf mate-terminal
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list"
wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
sudo apt-key add - < Release.key
sudo apt-get update && sudo apt-get install arc-theme
sudo npm install -g i3-style
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install-papirus-home-gtk.sh | sh
sudo cp $HOME/dotfiles/scripts/brightness /usr/bin/brightness

echo "${yellow}Add this to your crontab by using crontab -e${green}"
echo "*/15 * * * * ~/dotfiles/scripts/setbackground.sh"
read -p "${yellow}Press any key to continue..."

echo "${yellow}Music!${green}"

sudo apt-get install -y python-pip python3-pip ffmpeg cmus mpd ncmpcpp
sudo pip3 install setuptools mps-youtube youtube_dl
link "$dotfiles/mpd/" "$HOME/.mpd"
link "$dotfiles/ncmpcpp/" "$HOME/.ncmpcpp"

echo "${yellow}Installing ZSH${green}"

sudo apt-get install -y zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo chsh -s $(which zsh)

echo "${yellow}Installing ZSH plugins${green}"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "${yellow}Linking dotfiles${green}"

for location in $dotfiles/home/*; do
	file="${location##*/}"
	file="${file}"
	link "$location" "$HOME/.$file"
done
chmod +x $HOME/.lock.sh

link "$dotfiles/ssh/config" "$HOME/.ssh/config"

echo "${yellow}Doing vim stuff${green}"

sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt-get update
sudo apt-get install -y vim
link "$dotfiles/vim/vimrc" "$HOME/.vimrc"
link "$dotfiles/vim/" "$HOME/.vim"

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

echo "${yellow}Installing CTags${green}"

sudo apt-get install -y exuberant-ctags

echo "${yellow}Installing vim plugins${green}"

vim +PluginInstall +qall

read -r -p "${yellow}Clean up vim plugins in .vim/bundle? ${red}[y/N] ${green}" response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
	vim +PluginClean +qall
fi

echo "${yellow}Installing YouCompleteMe${green}"

cd $dotfiles/vim/bundle/YouCompleteMe
./install.py

echo "${yellow}Installing TPM (tmux plugin manager)${green}"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
sudo apt-get install -y xclip

echo "${yellow}Doing tmuxifier stuff${green}"

git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
link "$dotfiles/tmuxlayouts/" "$HOME/.tmuxlayouts"

echo "${yellow}Doing colorscheme stuff${green}"

git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
source $HOME/.bashrc
base16_atelier-seaside

echo "${yellow}Installing the silver searcher (ag)${green}"

sudo apt-get install -y silversearcher-ag

echo "${yellow}Installing grip (to view MarkDown locally)${green}"

sudo pip install grip

echo "${yellow}Cleaning up${green}"

rm -rf ~/tmp/fontawesome*

echo "${yellow}Done!${reset}"
