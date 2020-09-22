# Gentoo - VMware and VirtualBox Builds

This is a minimal VMware and VirtualBox Packer based installation of Gentoo.

It is based on the official
[Quick Install](https://www.gentoo.org/doc/en/gentoo-x86-quickinstall.xml)
guide, but avoids completing any of the optional steps.

> **Note:** Currently the VMWare version has no vmware-tools installed,
> but NFS mounts should work fine.
## Usage

This is a [Packer](https://packer.io/) template. Install the latest version of
Packer, then:

    chmod +x ./build-vmware-base.sh && ./build-vmware-base.sh

Or via command line:

    packer build -var cpu_brand="generic" \
    -var virt_type="vmware" \
    -var march="native" \
    -var make_opts="3" \
    -var emerge_world="false" \
    -var build_type="base"  \
    -var admin_user="$USER" \
    -var stage3="20200916T214503Z" \
    -var output_directory="/Users/$USER/gentoo" ./vmware.json

This will build Gentoo output a VMware VM in the root of your home directory. Your userid an password are set to your build system userid.

## On your first boot

Perform an initial `emerge-webrsync` to generate the portage tree.

    emerge-webrsync

**Do not** run `emerge --sync` before you do this, because you will add
unnecessary strain on the portage mirror.

## Disk size

The disk is a 60GB sparse disk.

## What's installed?

Short answer, nothing that's not in the stage3, with the exception of the
following things that are needed for Vagrant to work:

  - app-emulation/virtualbox-guest-additions
  - net-fs/nfs-utils
  - app-admin/sudo

## What's configured?

Everything is left as the defaults. The time zone is set to UTC.
