#!/bin/sh
set -e

install_config() {
	for dir in $@; do
		echo "Installing ~/.config/$dir"
		cp -r .config/$dir ~/.config
	done
}

install_etc() {
	for file in $@; do
		echo "Installing /etc/$file"
		sudo cp $file /etc
	done
}

install_home() {
	for file in $@; do
		echo "Installing ~/$file"
		cp $file ~
	done
}

PACMAN_OPTS='-Sy --needed'

# Install non-WM-related stuff
install_etc bash.bashrc pacman.conf
install_home .bashrc
install_config nvim htop
sudo pacman $PACMAN_OPTS neovim htop

# Install window manager + dependencies
case $(read -rp 'Sway or i3? '; echo $REPLY) in
	sway)
		# Require yay installation
		if ! type yay >/dev/null; then
			echo 'error: yay is not installed. Exiting.'
			exit 1
		fi

		# Install sway packages
		yay $PACMAN_OPTS swayfx swayidle swaybg swaylock-effects wofi wl-clipboard foot waybar otf-font-awesome grim slurp xdg-desktop-portal-wlr wf-recorder

		# Copy sway configs
		install_config foot sway swayidle swaylock waybar mako
		install_home .screen-record.sh
		chmod u+x ~/.screen-record.sh
		;;

	i3)
		# Install i3 packages
		sudo pacman $PACMAN_OPTS i3 xorg-server xorg-drivers xorg-xinit feh xterm rofi ffmpeg

		# Copy configs and X files
		install_config i3
		install_home .Xdefaults xinitrc
		chmod u+x ~/.xinitrc
		;;

	*)
		echo 'No window manager chosen. Exiting.'
		exit
esac

# Install shared packages
sudo pacman $PACMAN_OPTS gammastep gnome-themes-extra ttc-iosevka dbus polkit-gnome libnotify qpwgraph pavucontrol \
	libva-mesa-driver mesa-vdpau pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber mpv \
 	$(lscpu | grep Intel >/dev/null && echo 'intel-media-driver libva-intel-driver')

# Install shared configs
install_config gammastep gtk-3.0 mpv

# Set dark theme
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Copy wallpaper
install_home .wallpaper.jpg
