#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`
dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Functions
link() {
    from="$1"
    to="$2"
    echo "Linking '$to' -> '$from'"
    rm -f $to
    ln -s "$from" "$to"
}

command_exists () {
    type "$1" > /dev/null 2>&1
}

# Add used ppas
addppas() {
    sudo add-apt-repository -y ppa:nilarimogard/webupd8
    sudo add-apt-repository -y ppa:tjormola/i3-unstable
    sudo apt-get update
}

# Link all dotfiles from $dotfiles/home to the home folder
linkfiles () {
    echo "${yellow}Linking dotfiles${reset}"

    for location in $dotfiles/home/*; do
        file="${location##*/}"
        file="${file}"
        link "$location" "$HOME/.$file"
    done

    link "$dotfiles/termiteconf/config" "~/.config/termite/config"
}

# Install termite if not already installed
installtermite() {
    if ! command_exists termite; then
        echo "${yellow}Installing termite${green}"

        sudo apt-get install -y libgtk2.0-dev
        wget -P /tmp/ -O - https://raw.githubusercontent.com/Corwind/termite-install/master/termite-install.sh | bash
    else
        echo "${yellow}Termite is already installed${green}"
    fi

    if ! command_exists zsh; then
        echo "${yellow}Installing ZSH${green}"

        sudo apt-get install -y zsh

        echo "${yellow}Installing Oh-My-ZSH${green}"
        sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

        echo "${yellow}Installing custom Oh-My-ZSH plugins${green}"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

        echo "${yellow}Changing shell to ZSH${green}"
        sudo chsh -s $(which zsh)
    else
        echo "${yellow}ZSH is already installed${green}"
    fi
}

# Install i3 if not already installed
installi3() {
    if ! command_exists i3; then
        echo "${yellow}Installing i3 deps and building${green}"

        sudo apt-get install -y libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-xinerama0-dev libxcb-xrm-dev libanyevent-i3-perl
        git clone https://github.com/Airblader/i3.git /tmp/i3-gaps
        /tmp/i3-gaps
        autoreconf --force --install
        rm -rf build/
        mkdir -p build && cd build/
        ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
        make
        sudo make install

        link "$dotfiles/i3/" "$HOME/.i3"
    else
        echo "${yellow}i3 is already installed${green}"
    fi
}

# Install spacemacs if not already installed
installspacemacs() {
    sudo apt-get install -y emacs
    if [ -d ~/.emacs.d ]; then
        read -r -p "${yellow}Emacs directory already exists. Delete .emacs.d and clone again?${red}[y/N] ${reset}" response
        if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
        then
            echo "${yellow}Removing .emacs.d${reset}"
            rm -rf ~/.emacs.d
            echo "${yellow}Cloning spacemacs${reset}"
            git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
        else
            echo "${yellow}Didn't remove .emacs.d${reset}"
        fi
    else
        echo "${yellow}Cloning spacemacs${reset}"
        git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    fi
}

# Install polybar if not already installed
installpolybar() {
    if ! command_exists polybar; then
        echo "${yellow}Installing polybar${green}"
        sudo apt-get install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev
        git clone --recursive https://github.com/jaagr/polybar /tmp/polybar
        mkdir -p /tmp/polybar/build
        cd /tmp/polybar/build
        cmake ..
        sudo make install
    else
        echo "${yellow}Polybar is already installed${green}"
    fi
}

# Install fonts
installfonts() {
    git clone https://github.com/powerline/fonts.git /tmp/powerlinefonts
    bash /tmp/powerlinefonts/install.sh
    wget http://fontawesome.io/assets/font-awesome-4.7.0.zip -O /tmp/fontawesome.zip
    unzip /tmp/fontawesome.zip -d /tmp/
    sudo cp /tmp/font-awesome-4.7.0/fonts/fontawesome-webfont.ttf /usr/share/fonts/fontawesome.ttf
    sudo fc-cache -f -v
}

# Install theme
installtheme() {
    sudo apt-get install -y arc-theme lxappearance

    wget -P /tmp/ -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install-papirus-home-gtk.sh | sh

    echo "${yellow}Add this to your crontab by using crontab -e${green}"
    echo "*/15 * * * * ~/dotfiles/scripts/setbackground.sh"
    read -p "${yellow}Press any key to continue..."
}

# Misc things
misc() {
    echo "${yellow}Installing some addons and utilities${green}"
    sudo apt-get install -y i3status i3lock xautolock scrot imagemagick feh thunar gvfs compton rofi unzip exuberant-ctags silversearcher-ag

    echo "${yellow}Installing FZF${green}"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

# Actual program
read -r -p "${yellow}Continue? Your files might be overwritten. ${red}[y/N] ${reset}" response
if ! [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    exit 1
else
    addppas
    linkfiles
    installtermite
    installi3
    installpolybar
    installspacemacs
    installfonts
    installtheme
    misc
fi
