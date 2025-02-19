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
		while ! type yay >/dev/null; do
			read -rp 'yay is not installed, would you like to install it now? [y/n] '
			if [ $REPLY == y ]; then
				sh install-yay.sh
			else
				echo 'yay is required to install swayfx and swaylock-effects, exiting'
				return 1; exit 1
			fi
		done

		# Install sway packages
		yay $PACMAN_OPTS swayfx swayidle swaybg swaylock-effects wofi wl-clipboard foot waybar otf-font-awesome grim slurp xdg-desktop-portal-wlr wf-recorder mpvpaper

		# Copy sway configs
		install_config foot sway swayidle swaylock waybar mako
		install_home .screen-record.sh
		chmod u+x ~/.screen-record.sh
		;;

	i3)
		# Install i3 packages
		sudo pacman $PACMAN_OPTS i3 xorg-server xorg-drivers xorg-xinit feh xterm rofi

		# Copy configs and X files
		install_config i3
		install_home .Xdefaults .xinitrc
		chmod u+x ~/.xinitrc
		;;

	*)
		echo 'No window manager chosen. Exiting.'
		exit
esac

# Install shared packages (audio server, media player, hwaccel drivers, polkit frontend)
sudo pacman $PACMAN_OPTS gammastep gnome-themes-extra ttc-iosevka dbus polkit-gnome libnotify qpwgraph pavucontrol \
	libva-mesa-driver mesa-vdpau pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber mpv \
 	$(lscpu | grep Intel >/dev/null && echo 'intel-media-driver libva-intel-driver') xorg-xhost xorg-xrandr

# Install shared configs
install_config gammastep gtk-3.0 mpv vesktop

# Set dark theme
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Copy wallpaper
install_home .wallpaper.jpg

echo 'Setup complete! Only packages essential to your chosen desktop experience were installed. Install other things (browser, games, applications) yourself using yay.'
