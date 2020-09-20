#!/usr/bin/env bash


chroot /mnt/gentoo /bin/bash <<'EOF'
USE="-sendmail" emerge app-admin/sudo
emerge net-fs/nfs-utils
useradd -m -s /bin/bash $ADMIN_USER
usermod -a -G adm $ADMIN_USER
usermod -a G wheel $ADMIN_USER
usermod -a G users $ADMIN_USER
usermod -a G portage $ADMIN_USER
echo $ADMIN_USER:$ADMIN_USER | chpasswd
echo "$ADMIN_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$ADMIN_USER
mkdir -p ~$ADMIN_USER/.ssh
chmod 0700 ~$ADMIN_USER/.ssh
chmod 0600 ~$ADMIN_USER/.ssh/authorized_keys
chown -R $ADMIN_USER: ~$ADMIN_USER/.ssh
rc-update add sshd default
EOF
