# Install yay if not currently available.

if type yay &> /dev/null; then
	echo "yay is already installed."
else
	sudo pacman -Sy --needed git base-devel
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin
	makepkg -si
	cd ..
	rm -rf yay-bin
fi
