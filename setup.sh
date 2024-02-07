sudo cp .bashrc /etc/bash.bashrc
cp -r .config/nvim ~/.config

read -p "Setup window manager? (y/n) " choice
[ $choice = 'y' ] && source wm-setup.sh
