#!/usr/bin/env bash

chroot /mnt/gentoo /bin/bash <<'EOF'
grub-mkconfig -o /boot/grub/grub.cfg
cat > /etc/systemd/network/50-dhcp.network <<'NETWORK'
[Match]
Name=e*

[Network]
DHCP=yes
NETWORK
systemctl enable systemd-networkd
EOF
