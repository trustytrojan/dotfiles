# Installs Neovim, and copies a config file of the user's choice.

if ! type nvim &> /dev/null; then
	sudo pacman -Sy --needed neovim
fi

read -p "Which config would you like?
1: Hard 4-space tabs
2: VSCode-like experience
Enter choice: " choice

case "$choice" in
"1")
	cp .config/nvim/hard-tabs.vim ~/.config/nvim/init.vim
	;;
"2")
	cp .config/nvim/vscode.vim ~/.config/nvim/init.vim
	# Install vim-plug
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	# Install plugins
	nvim -c PlugInstall
*)
	echo "Choice not recognized. Skipping Neovim configuration."
esac
