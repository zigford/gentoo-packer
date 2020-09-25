#!/usr/bin/env bash

chroot /mnt/gentoo /bin/bash <<'EOF'

set -e

USE="device-mapper" emerge --quiet-fail ">=sys-boot/grub-2.0"
echo "set timeout=0" >> /etc/grub.d/40_custom
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
EOF
