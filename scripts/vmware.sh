#!/usr/bin/env bash

# chroot /mnt/gentoo /bin/bash <<'EOF'
# set -e
# echo "app-emulation/open-vm-tools" >> /etc/portage/package.accept_keywords
# echo "x11-libs/libdrm" >> /etc/portage/package.accept_keywords
# echo ">=x11-libs/libdrm-2.4.102 video_cards_vmware" >> /etc/portage/package.use/libdrm
# echo "x11-drivers/xf86-video-vmware" >> /etc/portage/package.accept_keywords
# echo "x11-base/xorg-drivers" >> /etc/portage/package.accept_keywords
# # echo "sys-libs/pam -filecaps" >> /etc/portage/package.use/pam
# rc-update add vmware-tools default
# echo 'modules="vsock vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport"' >> /etc/conf.d/modules
# EOF
