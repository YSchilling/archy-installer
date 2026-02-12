# scripts/partition.sh

if [[ -z "${diskname:-}" ]]; then
    echo "Error: variable \$diskname is not set"
    exit 1
fi

# adds "p" if the diskname ends with a number (nvme0n1, ...)
suffix=""
[[ "$diskname" =~ [0-9]$ ]] && suffix="p"

part1="${diskname}${suffix}1"
part2="${diskname}${suffix}2"
part3="${diskname}${suffix}3"

# create partitions
echo "Partition: create partitions"
parted -s -- "$diskname" mklabel gpt

parted -s -- "$diskname" mkpart "EFI" fat32 1MiB 1025MiB
parted -s -- "$diskname" set 1 esp on

parted -s -- "$diskname" mkpart "root" ext4 1025MiB "-${swapsize}"
parted -s -- "$diskname" type 2 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709

parted -s -- "$diskname" mkpart "swap" linux-swap "-${swapsize}" 100%
parted -s -- "$diskname" type 3 0657FD6D-A4AB-43C4-84E5-0933C84B4F4F

# wait for kernel to catch on part creations
partprobe "$diskname" || true
udevadm settle

# create filesystems
echo "Partition: create filesystems"
mkfs.fat -F32 "$part1"
mkfs.ext4 -F "$part2"
mkswap "$part3"

# mount filesystems
echo "Partition: mount filesystems"
mkdir -p /mnt
mount "$part2" /mnt

mkdir -p /mnt/boot
mount "$part1" /mnt/boot

swapon "$part3"