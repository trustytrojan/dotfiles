#!/bin/bash
set -e

usage() {
    echo 'usage: install-arch.sh <target partition> <hostname> <timezone> [efi system partition]'
    echo $'\n[efi system partition] is required when the current boot mode is UEFI'
    exit 1
}

prompt_yn() {
    read -rp "$1 [y/N] "
    [[ "$REPLY" == 'y' ]]
}

[ $2 ] || usage

ARCH_PART=$1 # Target for Arch Linux
HOSTNAME=$2 # Hostname of the new system
ESP=$3 # EFI system partition

[ -f /sys/firmware/efi/fw_platform_size ] && {
    BOOT_MODE='UEFI'
    [ $ESP ] || { echo 'efi system partition not specified!'; usage; }
} || BOOT_MODE='BIOS'

echo "current boot mode: $BOOT_MODE"
echo "target partition: $ARCH_PART"
[ $ESP ] && echo "efi system partition: $ESP"
echo -n 'testing internet connection... '
ping -c1 google.com >/dev/null || {
    echo 'not connected to the internet!'
    exit 1
}
echo 'done'

prompt_yn 'continue?' || exit

mount $ARCH_PART /mnt
pacstrap -K /mnt base linux linux-firmware sudo neovim networkmanager
genfstab -U /mnt >>/mnt/etc/fstab
arch-chroot /mnt <<<"
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo 'en_US.UTF-8 UTF-8' >/etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' >/etc/locale.conf
echo '$HOSTNAME' >/etc/hostname"
arch-chroot /mnt passwd

echo 'installation and basic setup complete! FYI no bootloader was installed!!'
