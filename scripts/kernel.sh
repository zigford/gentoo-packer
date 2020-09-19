#!/bin/bash

cp $SCRIPTS/scripts/kernel.config /mnt/gentoo/tmp/

chroot /mnt/gentoo /bin/bash <<'EOF'
echo 'ACCEPT_LICENSE="*"' >> /etc/portage/make.conf
echo 'MAKEOPTS="-j3"' >> /etc/portage/make.conf
cat /etc/portage/make.conf
# echo "" >> /etc/portage/make.conf
# echo "" >> /etc/portage/make.conf
emerge sys-kernel/gentoo-sources
emerge sys-kernel/genkernel
cd /usr/src/linux
mv /tmp/kernel.config .config
genkernel --install --symlink --no-zfs --no-btrfs --oldconfig all
emerge -c sys-kernel/genkernel
EOF
