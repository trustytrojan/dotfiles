# Install yay if needed
source yay.sh

# Install apps that complete the desktop experience.
yay -Sy --needed google-chrome htop nvtop

# Chrome commandline flags to force usage of Wayland and GNOME Keyring
cp .config/chrome-flags.conf ~/.config
