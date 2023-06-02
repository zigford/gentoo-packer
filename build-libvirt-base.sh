#!/usr/bin/env bash

init_system="${1:-openrc}"

base_url="http://distfiles.gentoo.org/releases/amd64/autobuilds/"
curl -o releases.txt $base_url/latest-stage3-amd64-systemd.txt
stage3=$(awk -F "/" '{print $1}' releases.txt | tail -n1)
rm releases.txt
iso_digest_url="http://distfiles.gentoo.org/releases/amd64/autobuilds/current-install-amd64-minimal/install-amd64-minimal-$stage3.iso.DIGESTS"
curl -o digest.asc $iso_digest_url
iso_sha512="$(awk '/# SHA512 HASH/ { getline; print $0 }' digest.asc | awk '!/CONTENTS/{print $1}' )"
rm digest.asc
show_build() {
    echo "stage3 $stage3 build successfully with checksum \
    $(sha256sum ./gentoo-amd64-stage3-$init_system-libvirt.box)"
}

packer build \
  -var stage3="$stage3"                       \
  -var iso_checksum="$iso_sha512"             \
  -var init_system="$init_system"             \
  -var output_directory="$HOME/gentoo" ./libvirt.json && show_build ||
echo "Build failed."
