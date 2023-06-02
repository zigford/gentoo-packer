#!/usr/bin/env bash

set -e

printf "Stage3 Configuration\n"

hwclock --systohc

printf "Mounting /mnt/gentoo\n"
mount /dev/vda5 /mnt/gentoo
printf "Creating /mnt/gentoo/var\n"
mkdir /mnt/gentoo/var
printf "Mounting /mnt/gentoo/var\n"
mount /dev/vda4 /mnt/gentoo/var

cd /mnt/gentoo

tarball="stage3-amd64-$INIT_SYSTEM-$STAGE3.tar.xz"
subdir="current-stage3-amd64-$INIT_SYSTEM"
wget "https://gentoo.osuosl.org/releases/amd64/autobuilds/$subdir/$tarball"
tar xpf $tarball
rm -f $tarball
