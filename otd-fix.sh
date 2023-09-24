# Modified script from https://opentabletdriver.net/Wiki/FAQ/Linux#fail-device-streams
git clone https://github.com/OpenTabletDriver/OpenTabletDriver.git
cd OpenTabletDriver
if ! type dotnet >/dev/null; then
	sudo pacman -Sy dotnet-sdk
fi
./generate-rules.sh | sudo tee /etc/udev/rules.d/99-opentabletdriver.rules
sudo udevadm control --reload-rules
cd ..
# Doesn't delete the repo just in case the script did not work
