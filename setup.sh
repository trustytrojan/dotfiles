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
yay -S --needed swayfx swayidle swaybg swaylock-effects waybar wofi pulseaudio pavucontrol foot grim slurp wl-clipboard dbus ttc-iosevka otf-font-awesome gnome-themes-extra gammastep

# Copy config files
cd .config
cp -r foot ~/.config
cp -r gammastep ~/.config
cp -r nvim ~/.config
cp -r sway ~/.config
cp -r swayidle ~/.config
cp -r swaylock ~/.config
cp -r waybar ~/.config
cp chrome-flags.conf ~/.config
cp code-flags.conf ~/.config
cd ..

# Copy wallpaper
cp .wallpaper.jpg ~

# Set GTK theme to Adwaita-dark
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
