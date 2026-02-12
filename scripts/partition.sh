#!/bin/bash

if [[ -z "${diskname:-}" ]]; then
    echo "Error: variable \$diskname is not set"
    exit 1
fi

parted -s "$diskname" mklabel gpt

parted -s "$diskname" mkpart "EFI" fat32 1MiB 1025MiB
parted -s "$diskname" set 1 esp on

parted -s "$diskname" mkpart "root" ext4 1025MiB 100%
parted -s "$diskname" type 2 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709