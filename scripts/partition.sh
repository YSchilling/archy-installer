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

# create partitions
echo "Partition: create partitions"
parted -s "$diskname" mklabel gpt

parted -s "$diskname" mkpart "EFI" fat32 1MiB 1025MiB
parted -s "$diskname" set 1 esp on

parted -s "$diskname" mkpart "root" ext4 1025MiB 100%
parted -s "$diskname" type 2 4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709

# create filesystems
echo "Partition: create filesystems"
mkfs.fat -F32 "$part1"
mkfs.ext4 -F "$part2"

# mount filesystems
echo "Partition: mount filesystems"
mkdir /mnt/boot -p

mount "$part2" /mnt
mount "$part1" /mnt/boot