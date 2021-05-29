#!/usr/bin/env bash

chroot /mnt/gentoo /bin/bash <<'EOF'
cat > /etc/fstab <<'DATA'
# <fs>		<mount>	<type>	<opts>		<dump/pass>
/dev/vda1	/boot	ext2	noauto,noatime	1 2
/dev/vda4	/var	ext4	noatime		0 1
/dev/vda5	/   	ext4	noatime		0 1
/dev/vda3	none	swap	sw          0 0
DATA
EOF
