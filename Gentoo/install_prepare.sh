#!/usr/bin/env bash
# Stuff that must be done before running this script
# - Networking using wpa_supplicant(config must be in $HOME/wpa_supplicant.conf)
# - Date(use ntpd or manual)
# - Partitions(each one must be labeled)

# Default Labels
ROOT_LABEL="Gentoo"

# Tarball
STAGE3="https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20230101T164658Z/stage3-amd64-openrc-20230101T164658Z.tar.xz"

# Mount Root
mount "/dev/disk/by-label/$ROOT_LABEL" /mnt/gentoo
cp -r $HOME/Config /mnt/gentoo # Config Directory Expected to be in $HOME
cd /mnt/gentoo

# Install Tarball
wget $STAGE3
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

# Install Portage Configurations
cp -r $HOME/Config/Gentoo/portage/* /mnt/gentoo/etc/portage
mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

# Networking
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
cp $HOME/wpa_supplicant.conf /mnt/gentoo/etc/wpa_supplicant/wpa_supplicant.conf

# Mount System
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

echo "Run install_system.sh next!"
chroot /mnt/gentoo /bin/bash
