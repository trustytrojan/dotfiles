# Install yay if needed
if ! type yay &> /dev/null; then
	sudo pacman -S --needed git base-devel
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin
	makepkg -si
	cd ..
	rm -rf yay-bin
fi

# Install dependencies
yay -S --needed swayfx swayidle swaybg swaylock-effects waybar wofi pulseaudio pavucontrol foot grim slurp wl-clipboard dbus ttc-iosevka

# Copy config files
cd .config
cp foot/* ~/.config/foot
cp gammastep/* ~/.config/gammastep
cp nvim/* ~/.config/nvim
cp sway/* ~/.config/sway
cp swayidle/* ~/.config/swayidle
cp swaylock/* ~/.config/swaylock
cp waybar/* ~/.config/waybar
cp chrome-flags.conf ~/.config
cp code-flags.conf ~/.config
cd ..

# Copy wallpaper
cp .wallpaper.jpg ~
