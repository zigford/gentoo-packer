#!/usr/bin/env bash

chroot /mnt/gentoo /bin/bash <<'EOF'
emerge --depclean
df -k
mount -l
cat /etc/fstab
EOF

rm -rf /mnt/gentoo/var/cache/distfiles
rm -rf /mnt/gentoo/var/db/repos
rm -rf /mnt/gentoo/tmp/*
rm -rf /mnt/gentoo/var/log/*
rm -rf /mnt/gentoo/var/tmp/*

chroot /mnt/gentoo /bin/bash <<'EOF'
wget https://frippery.org/uml/zerofree-1.1.1.tgz
tar xvzf zerofree-*.tgz
cd zerofree*/
make
EOF

mv /mnt/gentoo/zerofree* ./
cd zerofree*/

umount --recursive /mnt/gentoo
./zerofree /dev/vda4
swapoff /dev/vda3
dd if=/dev/zero of=/dev/vda3
mkswap /dev/vda3
