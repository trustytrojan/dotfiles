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

# Replace .config
rm -rf ~/.config
mv .config ~

# Move wallpaper
mv .wallpaper.jpg ~
