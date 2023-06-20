# If yay is not installed, install it
if ! command -v yay >/dev/null 2>&1; then
        echo "'yay' is not installed. Checking for yay's build dependencies..."
 
        # If git is not installed, install it along with base-devel
        if ! command -v git >/dev/null 2>&1; then
                echo "git is not installed. Installing git and base-devel..."
                pacman -Sy --needed git base-devel
        fi
 
        # Install yay
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si

        # Remove folder when done
        cd ..
        rm -rf yay
fi      
 
# Install all required packages
yay -Sy sway foot waybar wofi swayidle swaylock-effects pulseaudio gammastep otf-font-awesome
