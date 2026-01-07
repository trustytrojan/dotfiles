#!/usr/bin/env bash
set -e

# Parse theme flag (default: main)
THEME="main"
for arg in "$@"; do
	case "$arg" in
		--theme=*)
			THEME="${arg#*=}"
			;;
		--theme)
			shift
			THEME="$1"
			;;
	esac
done

if [[ "$THEME" != "main" && "$THEME" != "yuuka" ]]; then
	echo "Error: Invalid theme '$THEME'. Must be 'main' or 'yuuka'."
	exit 1
fi

echo "Using theme: $THEME"

install_config() {
	# Usage: install_config dir [src:dest] [src:dest] ...
	# If only dir is given, copies entire .config/$dir to ~/.config/$dir
	# If src:dest pairs are given, copies .config/$dir/$src to ~/.config/$dir/$dest
	local dir="$1"
	shift
	
	if [[ $# -eq 0 ]]; then
		# No specific files, copy entire directory
		echo "Installing ~/.config/$dir"
		cp -r .config/$dir ~/.config
	else
		# Copy specific files with optional renaming
		mkdir -p ~/.config/$dir
		for mapping in "$@"; do
			if [[ "$mapping" == *:* ]]; then
				local src="${mapping%%:*}"
				local dest="${mapping##*:}"
				echo "Installing ~/.config/$dir/$dest (from $src)"
				cp .config/$dir/$src ~/.config/$dir/$dest
			else
				echo "Installing ~/.config/$dir/$mapping"
				cp .config/$dir/$mapping ~/.config/$dir/$mapping
			fi
		done
	fi
}

install_etc() {
	# Usage: install_etc file [file] ...
	for file in "$@"; do
		echo "Installing /etc/$file"
		sudo cp "$file" /etc
	done
}

install_home() {
	# Usage: install_home file [src:dest] [src:dest] ...
	# If no colon, copies file to ~/$file
	# If src:dest, copies $src to ~/$dest
	for mapping in "$@"; do
		if [[ "$mapping" == *:* ]]; then
			local src="${mapping%%:*}"
			local dest="${mapping##*:}"
			echo "Installing ~/$dest (from $src)"
			cp "$src" ~/$dest
		else
			echo "Installing ~/$mapping"
			cp "$mapping" ~
		fi
	done
}

PACMAN_OPTS='-Sy --needed'

# Install non-WM-related stuff
install_etc bash.bashrc
if [[ "$(uname -m)" == "x86_64" ]]; then
	# only do this if we are on normal arch.
	# other architectures will not have the same package repos
	install_etc pacman.conf
else
	echo "Installation of pacman.conf skipped since this is not normal Arch Linux."
fi
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

		# Copy sway configs (theme-aware)
		if [[ "$THEME" == "yuuka" ]]; then
			install_config sway config-yuuka:config
			install_config swaylock config-yuuka:config
			install_config waybar style-yuuka.css:style.css
			install_config nvim init-yuuka.vim:init.vim
		else
			install_config sway config:config
			install_config swaylock config:config
			install_config waybar style.css:style.css
			install_config nvim init.vim:init.vim
		fi
		install_config foot swayidle mako
		install_home .screen-record.sh
		chmod u+x ~/.screen-record.sh

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
