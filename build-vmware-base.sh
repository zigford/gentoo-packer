#!/usr/bin/env bash

packer build -var cpu_brand="generic" \
-var virt_type="vmware"         \
-var march="native"             \
-var make_opts="3"              \
-var build_type="base"          \
-var admin_user="$USER"         \
-var stage3="20200916T214503Z"  \
-var output_directory="/Users/$USER/gentoo" ./vmware.json
