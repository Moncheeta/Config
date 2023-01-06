#!/usr/bin/env bash

# The rest of the labels
BOOT_LABEL="BOOT"
SWAP_LABEL="SWAP"

# Timezone
TIMEZONE="America/Chicago"

# Setup
source /etc/profile && export PS1="(chroot) ${PS1}"

# Mount boot
mount /dev/disk/by-label/BOOT /boot

# Continue configuring portage
emerge-webrsync
emerge --sync
emerge --verbose --update --deep --newuse @world

# Optimize
emerge app-portage/cpuid2cpuflags
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/cpu

# Locals
echo $TIMEZONE > /etc/timezone
emerge --config sys-libs/timezone-data
nano -w /etc/locale.gen
locale-gen
eselect locale list
read -p "Which Locale?(NUMBER) " locale
eselect locale set $locale
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

# System
emerge sys-kernel/linux-firmware emerge sys-kernel/gentoo-kernel-bin # Just so that the system gets running
eselect kernel list
eselect kernel set 1
emerge sys-kernel/gentoo-sources
# emerge x11-drivers/nvidia-drivers # if using a nvidia gpu
cp $HOME/Config/Gentoo/rc.conf /etc/rc.conf
cp $HOME/Config/Gentoo/conf.d/* /etc/conf.d
emerge @module-rebuild

# Filesystem
cp $HOME/Config/Gentoo/fstab /etc/fstab
nano /etc/fstab
emerge sys-fs/xfs-progs sys-fs/dosfstools

# Networking
nano /etc/conf.d/hostname
emerge net-misc/dhcpcd net-wireless/wpa_supplicant
rc-update add dhcpcd default
nano /etc/hosts # double check hosts

# Time
emerge net-misc/chrony
rc-update add chronyd default

# Other
emerge sys-apps/mlocate doas

# Users
echo "ROOT PASSWORD"
passwd
read -p "What would you like your username to be?" username
useradd -m -G users,wheel,audio -s /bin/bash $username
echo "$username's PASSWORD"
passwd $username

# Bootloader
# Guessing that it is a EFI system
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge --verbose sys-boot/grub sys-boot/osprober
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

echo "Now Reboot!"
exit

