#!/usr/bin/env bash


chroot /mnt/gentoo /bin/bash <<'EOF'
USE="-sendmail" emerge app-admin/sudo
emerge net-fs/nfs-utils
useradd -m -s /bin/bash $ADMIN_USER
usermod -a -G adm $ADMIN_USER
usermod -a -G wheel $ADMIN_USER
usermod -a -G users $ADMIN_USER
usermod -a -G portage $ADMIN_USER
sed -i '
        s/enforce.*/enforce=none/;
        s/min=.*/min=4,4,4,4,4/;
        s/match=.*/match=0/;
        s/passphrase=.*/passphrase=0/;
' /etc/security/passwdqc.conf
echo $ADMIN_USER:$ADMIN_USER | chpasswd
echo "$ADMIN_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$ADMIN_USER
mkdir -p /home/$ADMIN_USER/.ssh
chmod 0700 /home/$ADMIN_USER/.ssh
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/$ADMIN_USER/.ssh/authorized_keys
chmod 0600 /home/$ADMIN_USER/.ssh/authorized_keys
chown -R $ADMIN_USER: /home/$ADMIN_USER/.ssh
systemctl enable sshd
EOF
