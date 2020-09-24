#!/usr/bin/env bash

set -e

printf "Prepare chroot enviornment\n"

cd /
mount /dev/sda1 /mnt/gentoo/boot
mount -t proc proc /mnt/gentoo/proc
mount --rbind /dev /mnt/gentoo/dev
mount --rbind /sys /mnt/gentoo/sys
