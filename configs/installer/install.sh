#!/bin/bash
SOURCE_IMAGE="/lib/live/mount/rootfs/image.squashfs"

#########
# Fixme - read config from /proc/cmdline if available
ROOT_SIZE="4G"
SWAP_SIZE="1G"

# FIXME: be able to read more advanced filesystem scheme from cmdline
# Using jq maybe?
# yaml -> json -> cmdline -> jq
#  - raid configuration (none, 0, 1, 5)
#  - logical volumes and sizes
#  - filesystem types and options
#  note: 4096 character max total cmdline size
FS_TYPE="ext4"
ROOT_BLOCKDEV=/dev/mapper/vg0-root
#########

# Create a single partition on a raw device
initialize_device()
{
  device=$1
  fdisk $device << EOF
o
n
p
1



w
y
EOF
}

# Setup LVM
prepare_lvm()
{
  device=$1

  lvremove -ff vg0
  vgremove -ff -y vg0
  pvremove -ff -y $device
  wipefs -f -a $device

  pvcreate ${device}
  vgcreate vg0 ${device}
  lvcreate -nroot -L ${ROOT_SIZE} vg0
  lvcreate -nswap -L ${SWAP_SIZE} vg0 # fixme - check if swap size greater than 0
  lvcreate -n u -l 100%FREE vg0
}

# Prepare the filesystems
initialize_filesystems()
{

# FIXME: allow reading fs options from /proc/cmdline
  mkfs.ext4 -F /dev/mapper/vg0-root
  mkfs.ext4 -F /dev/mapper/vg0-u
}

# Install system by copying image via tarpipe
install_system()
{
  mountpoint=$(mktemp -d)
  mount ${ROOT_BLOCKDEV} ${mountpoint}
  tar -C ${SOURCE_IMAGE} -cpf - . | tar -C ${mountpoint} -xpf -
  umount ${mountpoint}
}

chroot_exec()
{
  mountpoint=$(mktemp -d)
  mount ${ROOT_BLOCKDEV} ${mountpoint}
  mount -o bind /dev ${mountpoint}/dev
  mount -o bind /sys ${mountpoint}/sys
  mount -t proc none ${mountpoint}/proc
  cp /etc/resolv.conf ${mountpoint}/etc
  chroot ${mountpoint} $@
  umount -l ${mountpoint}/dev
  umount -l ${mountpoint}/sys
  umount -l ${mountpoint}/proc
  umount -l ${mountpoint}
}

finalize()
{
  chroot_exec apt-get update
  chroot_exec apt-get remove live-boot --purge -y
  chroot_exec /usr/bin/env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq grub-pc
  chroot_exec grub-install /dev/sda
  chroot_exec update-grub
}

install()
{
  initialize_device /dev/sda
  prepare_lvm /dev/sda1
  initialize_filesystems
  install_system
  finalize
}

install
