# This makes the "Raydium Touchscreen" work under Arch. Requires a restart.
echo "blacklist raydium_i2c_ts" | sudo tee /etc/modprobe.d/unneeded-modules.conf
