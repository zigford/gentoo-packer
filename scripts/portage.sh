#!/usr/bin/env bash

chroot /mnt/gentoo /bin/bash <<'EOF'
mkdir -p /etc/portage/repos.conf
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
mkdir -p /var/db/repos/gentoo
emerge-webrsync
EOF
