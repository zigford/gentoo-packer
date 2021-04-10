#!/usr/bin/env bash

base_url="http://distfiles.gentoo.org/releases/amd64/autobuilds/"

curl -o releases.txt $base_url/latest-stage3-amd64.txt

stage3=$(awk -F "/" '{print $1}' releases.txt | tail -n1)

rm releases.txt

iso_digest_url="http://distfiles.gentoo.org/releases/amd64/autobuilds/current-install-amd64-minimal/install-amd64-minimal-$stage3.iso.DIGESTS.asc"

curl -o digest.asc $iso_digest_url

iso_sha512="$(awk '/# SHA512 HASH/ { getline; print $0 }' digest.asc | awk '!/CONTENTS/{print $1}' )"

rm digest.asc

# curl -o releases.txt $base_url/latest-stage3-amd64.txt 

# cat | grep -v -e hardened -e uclib -e nomultilib -e systemd -e x32 -e vanilla| awk '{print $1}' | tail -n1)

# wget $base_url/$(curl $base_url/latest-stage3-amd64.txt | grep -v -e hardened -e uclib -e nomultilib -e systemd -e x32 -e vanilla| awk '{print $1}' | tail -n1)
if [ -z "$1" ] ; then
  packer build -var cpu_brand="generic"       \
  -var mem_size="4096"                        \
  -var num_cpus="4"                           \
  -var virt_type="vmware"                     \
  -var mem_size="4096"                        \
  -var march="native"                         \
  -var make_opts="3"                          \
  -var emerge_world="false"                   \
  -var build_type="base"                      \
  -var admin_user="$USER"                     \
  -var stage3="$stage3"                       \
  -var iso_checksum="$iso_sha512"             \
  -var iso_url="http://distfiles.gentoo.org/releases/amd64/autobuilds/current-install-amd64-minimal/install-amd64-minimal-$stage3.iso" \
  -var output_directory="$HOME/gentoo" ./vmware.json
fi
