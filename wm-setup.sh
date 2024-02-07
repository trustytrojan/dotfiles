# Install options for pacman/yay
OPTS="-Sy --needed"

# Copies each provided config folder from .config to ~/.config
function copy_config {
	for arg in $@; do
		cp -r .config/$arg ~/.config
	done
}

# Install shared dependencies
sudo pacman $OPTS gammastep gnome-themes-extra ttc-iosevka dbus polkit-gnome libnotify pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber qpwgraph pavucontrol

# Copy shared configs
copy_config gammastep gtk-3.0

# Determine window manager
read -p "sway or i3? " wm

if [ $wm == "sway" ]; then
	# Require yay installation
	if ! type yay >/dev/null; then
		echo "yay is not installed. Aborting."
		exit 1
	fi

	# Install sway dependencies
	yay $OPTS swayfx swayidle swaybg swaylock-effects wofi wl-clipboard foot waybar otf-font-awesome grim slurp

	# Copy sway configs
	copy_config foot sway swayidle swaylock waybar

	# Set dark theme
	gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
elif [ $wm == "i3" ]; then
	# Install i3 dependencies
	sudo pacman $OPTS i3 xorg-server xorg-xinit feh xterm rofi

	# Copy configs and X files
	copy_config i3
 	cp .Xdefaults ~
  	cp .xinitrc ~
   	chmod u+x ~/.xinitrc
else
	echo "Unknown window manager '$wm'. Aborting."
	exit 1
fi

# Copy wallpaper
cp .wallpaper.jpg ~
