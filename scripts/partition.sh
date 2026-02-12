#!/bin/bash

if [[ -z "${diskname:-}" ]]; then
    echo "Error: variable \$diskname is not set"
    exit 1
fi

# create partitions
echo "Partition: create partitions\n"
parted -s "$diskname" mklabel gpt

parted -s "$diskname" mkpart "EFI" fat32 1MiB 1025MiB
parted -s "$diskname" set 1 esp on

parted -s "$diskname" mkpart "root" ext4 1025MiB 100%
parted -s "$diskname" type 2 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709

# create filesystems
echo "Partition: create filesystems\n"
mkfs.fat -F32 "${diskname}1"
mkfs.ext4 "${diskname}2"

# mount filesystems
echo "Partition: mount filesystems\n"
mkdir /mnt/boot

mount "${diskname}2 /mnt
mount "${diskname}1 /mnt/boot