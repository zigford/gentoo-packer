#!/usr/bin/env bash

set -e

printf "Stage3 Configuration\n"

hwclock --systohc

tarball="stage3-amd64-systemd-$STAGE3.tar.xz"

printf "Mounting /mnt/gentoo\n"
mount /dev/vda5 /mnt/gentoo
printf "Creating /mnt/gentoo/var\n"
mkdir /mnt/gentoo/var
printf "Mounting /mnt/gentoo/var\n"
mount /dev/vda4 /mnt/gentoo/var

cd /mnt/gentoo
wget "https://gentoo.osuosl.org/releases/amd64/autobuilds/current-stage3-amd64/$tarball"
tar xpf $tarball
rm -f $tarball
