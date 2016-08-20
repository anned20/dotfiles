echo "Linking dotfiles"

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

echo "Doing vim stuff"

link "$dotfiles/vim/vimrc" "$HOME/.vimrc"
link "$dotfiles/vim/" "$HOME/.vim"

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

echo "Doing tmuxifier stuff"

git clone https://github.com/jimeh/tmuxifier.git $HOME/.tmuxifier
link "$dotfiles/tmuxlayouts/" "$HOME/.tmuxlayouts"

echo "Doing colorscheme stuff"

git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell

