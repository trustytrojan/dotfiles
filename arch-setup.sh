#!/bin/sh
set -e

install_config() {
	for dir in $@; do
		echo "Installing ~/.config/$dir"
		cp -r ".config/$dir" ~/.config
	done
}

install_etc() {
	for file in $@; do
		echo "Installing /etc/$file"
		sudo cp "$file" /etc
	done
}

install_home() {
	for file in $@; do
		echo "Installing ~/$file"
		cp "$file" ~
	done
}

PACMAN_OPTS='-Sy --needed'

# Install non-WM-related stuff
if [[ "$(uname -m)" == "x86_64" ]]; then
	# only do this if we are on normal arch.
	# other architectures will not have the same package repos
	install_etc pacman.conf
else
	echo "Installation of pacman.conf skipped since this is not normal Arch Linux."
fi

install_etc bash.bashrc
install_home .bashrc
install_config nvim htop nvtop
sudo pacman $PACMAN_OPTS neovim htop nvtop

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
		SWAY_PACKAGES=(
			swayfx
			swayidle
			swaybg
			swaylock-effects
			wofi
			wl-clipboard
			foot
			waybar
			otf-font-awesome
			grim
			slurp
			xdg-desktop-portal-wlr
			xdg-desktop-portal-gtk
			wf-recorder
			qt5-wayland
			qt6-wayland
			idlehack-git
		)

		yay $PACMAN_OPTS "${SWAY_PACKAGES[@]}"

		# Copy sway configs
		install_config foot sway swayidle swaylock waybar mako
		install_home .screen-record.sh

		# Setup services
		sudo sed -i '/^method=/s/.*/method=reallyfreegeoip/' /etc/geoclue/geoclue.conf
		sudo systemctl enable --now geoclue
		systemctl --user enable --now gammastep mako idlehack
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

# Packages needed regardless of window manager
SHARED_PACKAGES=(
	gammastep
	geoclue
	gnome-themes-extra
	ttc-iosevka
	dbus
	polkit-gnome
	libnotify
	qpwgraph
	pavucontrol
	pipewire
	pipewire-alsa
	pipewire-pulse
	pipewire-jack
	wireplumber
	mpv
	xorg-xhost # for gparted
	xorg-xrandr
  	nemo
	gvfs-mtp
)

# Add Intel VA drivers if CPU is Intel
if lscpu | grep -q Intel; then
	SHARED_PACKAGES+=(intel-media-driver libva-intel-driver)
fi

# Install shared packages
sudo pacman $PACMAN_OPTS "${SHARED_PACKAGES[@]}"

# Install shared configs
install_config gammastep gtk-3.0 mpv vesktop

# Set dark theme
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Copy wallpaper
install_home .wallpaper.jpg

echo 'Setup complete! Only packages essential to your chosen window manager were installed. Install other things (browser, games, applications) yourself using yay.'
