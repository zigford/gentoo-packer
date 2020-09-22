#!/usr/bin/env bash

chroot /mnt/gentoo /bin/bash <<'EOF'
if [[ $EMERGE_WORLD = "true" ]]; then
    emerge -e @world
else
    printf "The emerge_world variable not set to true - will not run emerge -e @world\n"
fi
EOF
