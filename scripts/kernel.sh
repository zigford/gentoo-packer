#!/usr/bin/env bash

cp $SCRIPTS/scripts/kernel.config /mnt/gentoo/tmp/

chroot /mnt/gentoo /bin/bash <<'EOF'
sed -i "s/COMMON_FLAGS=\"-O2 -pipe\"/COMMON_FLAGS=\"-march=$MARCH -O2 -pipe\"/" /etc/portage/make.conf
echo 'ACCEPT_LICENSE="*"' >> /etc/portage/make.conf
echo "MAKEOPTS=\"-j$MAKE_OPTS\"" >> /etc/portage/make.conf
emerge --quiet-fail sys-kernel/gentoo-kernel-bin
EOF
