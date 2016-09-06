#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

echo "${red}It is recommended to answer yes or y to all questions for everything to work properly!"
echo "${red}You may also need to type 'exit' after you got into the zsh shell to continue the installation"
read -p "${yellow}Press any key to continue..."

echo "${yellow}Installing ZSH${green}"

sudo apt-get install zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo chsh -s $(which zsh)

echo "${yellow}Installing ZSH plugins${green}"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "${yellow}Linking dotfiles${green}"

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

link() {
	from="$1"
	to="$2"
	echo "Linking '$to' -> '$from'"
	rm -f $to
	ln -s "$from" "$to"
}

for location in $dotfiles/home/*; do
	file="${location##*/}"
	file="${file}"
	link "$location" "$HOME/.$file"
done

echo "${yellow}Doing vim stuff${green}"

link "$dotfiles/vim/vimrc" "$HOME/.vimrc"
link "$dotfiles/vim/" "$HOME/.vim"

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

echo "${yellow}Installing CTags${green}"

sudo apt-get install exuberant-ctags

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
sudo apt-get install xclip

echo "${yellow}Doing tmuxifier stuff${green}"

git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
link "$dotfiles/tmuxlayouts/" "$HOME/.tmuxlayouts"

echo "${yellow}Doing colorscheme stuff${green}"

git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
source $HOME/.bashrc
base16_atelier-seaside

echo "${yellow}Installing the silver searcher (ag)${green}"

sudo apt-get install silversearcher-ag

echo "${yellow}Installing grip (to view MarkDown locally)${green}"

sudo pip install grip

echo "${yellow}Done!${reset}"
