# Environment setup.

# Install yay if needed
source install-yay.sh

# Install dependencies
yay -Sy --needed swayfx swayidle swaybg swaylock-effects wofi wl-clipboard foot waybar otf-font-awesome grim slurp gnome-themes-extra ttc-iosevka pulseaudio pavucontrol dbus polkit-gnome gammastep qt5-wayland libnotify

# If this PC is a laptop, install brightnessctl
if [ -d /proc/acpi/button/lid ]; then
	yay -Sy --needed brightnessctl
fi

# Copy config files
cd .config
cp -r foot ~/.config
cp -r gammastep ~/.config
cp -r sway ~/.config
cp -r swayidle ~/.config
cp -r swaylock ~/.config
cp -r waybar ~/.config
cd ..

# Copy wallpaper
cp .wallpaper.jpg ~

# Set GTK theme to Adwaita-dark
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
