function copy_config {
	for dir in $@; do
		echo "Copying $dir config"
		cp -r .config/$dir ~/.config
	done
}

PACMAN_OPTS="-Sy --needed"

echo "Installing system-wide bashrc"
sudo cp .bashrc /etc/bash.bashrc

copy_config nvim

read -p "Install pipewire and wireplumber? [Y/n] " pw
[[ $pw == "n" ]] || {
	echo "Installing pipewire and wireplumber"
	sudo pacman $PACMAN_OPTS pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
}

read -p "Sway, i3, or none? " wm
[[ $wm == "sway" || $wm == "i3" ]] || exit

# Install shared dependencies
sudo pacman $PACMAN_OPTS gammastep gnome-themes-extra ttc-iosevka dbus polkit-gnome libnotify qpwgraph pavucontrol

# Install shared configs
copy_config gammastep gtk-3.0
echo "export GTK_THEME=Adwaita-dark" >> ~/.bashrc

# Install window manager + dependencies
case $wm in
	sway)
		# Require yay installation
		if ! type yay >/dev/null; then
			echo "yay is not installed. Aborting."
			exit 1
		fi

		# Install sway dependencies
		yay $PACMAN_OPTS swayfx swayidle swaybg swaylock-effects wofi wl-clipboard foot waybar otf-font-awesome grim slurp

		# Copy sway configs
		copy_config foot sway swayidle swaylock waybar

		# Set dark theme
		gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

	i3)
		# Install i3 dependencies
		sudo pacman $PACMAN_OPTS i3 xorg-server xorg-drivers xorg-xinit feh xterm rofi

		# Copy configs and X files
		copy_config i3
		cp .Xdefaults ~
		cp .xinitrc ~
		chmod u+x ~/.xinitrc
esac

# Copy wallpaper
cp .wallpaper.jpg ~
