#!/usr/bin/env bash

tarball="stage3-amd64-$STAGE3.tar.xz"

mount /dev/sda5 /mnt/gentoo
mount /dev/sda4 /mnt/gentoo/var

cd /mnt/gentoo
wget "https://gentoo.osuosl.org/releases/amd64/autobuilds/current-stage3-amd64/$tarball"
tar xvpf $tarball
rm -f $tarball
