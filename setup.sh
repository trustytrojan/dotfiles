#!/bin/sh
set -e

function copy_config {
	for dir in $@; do
		echo "Copying $dir config"
		cp -r .config/$dir ~/.config
	done
}

PACMAN_OPTS="-Sy --needed"

echo "Installing /etc/bash.bashrc"
sudo cp bash.bashrc /etc/bash.bashrc

echo "Installing ~/.bashrc"
cp .bashrc ~

copy_config nvim

read -p "Sway or i3? " wm
[[ $wm == "sway" || $wm == "i3" ]] || exit

# Install shared packages
sudo pacman $PACMAN_OPTS gammastep gnome-themes-extra ttc-iosevka dbus polkit-gnome libnotify qpwgraph pavucontrol \
	libva-mesa-driver mesa-vdpau pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber mpv \
 	$(lscpu | grep Intel && echo intel-media-driver libva-intel-driver)

# Install shared configs
copy_config gammastep gtk-3.0 mpv

# Install window manager + dependencies
case $wm in
	sway)
		# Require yay installation
		if ! type yay >/dev/null; then
			echo "yay is not installed. Aborting."
			exit 1
		fi

		# Install sway packages
		yay $PACMAN_OPTS swayfx swayidle swaybg swaylock-effects wofi wl-clipboard foot waybar otf-font-awesome grim slurp xdg-desktop-portal-wlr wf-recorder

		# Copy sway configs
		copy_config foot sway swayidle swaylock waybar mako
  		cp .screen-record.sh ~
    		chmod u+x ~/.screen-record.sh

		# Set dark theme
		gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

	i3)
		# Install i3 packages
		sudo pacman $PACMAN_OPTS i3 xorg-server xorg-drivers xorg-xinit feh xterm rofi ffmpeg

		# Copy configs and X files
		copy_config i3
		cp .Xdefaults ~
		cp .xinitrc ~
		chmod u+x ~/.xinitrc
esac

# Copy wallpaper
cp .wallpaper.jpg ~
