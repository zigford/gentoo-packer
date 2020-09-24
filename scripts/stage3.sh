#!/usr/bin/env bash

set -e

printf "Stage3 Configuration\n"

hwclock --systohc

tarball="stage3-amd64-$STAGE3.tar.xz"

printf "Mounting /mnt/gentoo\n"
mount /dev/sda5 /mnt/gentoo
printf "Creating /mnt/gentoo/var\n"
mkdir /mnt/gentoo/var
printf "Mounting /mnt/gentoo/var\n"
mount /dev/sda4 /mnt/gentoo/var
# mount /dev/sda4 /mnt/gentoo

cd /mnt/gentoo
wget "https://gentoo.osuosl.org/releases/amd64/autobuilds/current-stage3-amd64/$tarball"
tar xvpf $tarball
rm -f $tarball
