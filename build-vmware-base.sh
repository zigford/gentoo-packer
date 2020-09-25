#!/usr/bin/env bash

packer build -var cpu_brand="generic"   \
-var mem_size="4096"                    \
-var num_cpus="4"                       \
-var virt_type="vmware"                 \
-var march="native"                     \
-var make_opts="3"                      \
-var emerge_world="false"               \
-var build_type="base"                  \
-var admin_user="$USER"                 \
-var stage3="20200923T214503Z"          \
-var iso_checksum="ffa89c262856bd87a04ed1552820d6b2f7ed2cd31bdbe18faa9336a0df57da91cb0debcb9fbafe09f47e27070049e45585de2d7285f76d6cbd4ed5b179bd4a7b" \
-var iso_url="http://distfiles.gentoo.org/releases/amd64/autobuilds/current-install-amd64-minimal/install-amd64-minimal-20200920T214503Z.iso" \
-var output_directory="/Users/$USER/gentoo" ./vmware.json
