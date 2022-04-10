
# Create 2 partition

## Set msdos disk
parted -s /dev/sda mktable msdos

## Create boot partition
parted -s /dev/sda mkpart primary 0% 200m

## Create root partition
parted -s /dev/sda mkpart primary 200m 100%

# Format partition

## Format boot
mkfs.ext2 /dev/sda1

## Format root
mkfs.ext4 /dev/sda2

# Mount partition

## Mount root
mount /dev/sda2 /mnt

## Create boot direction
mkdir /mnt/boot

## Mount boot
mount /dev/sda1 /boot

# Setup package

## Linux package
pacstrap -i /mnt base base-devel linux-firmware linux-zen linux-zen-headers --noconfirm --needed

## Main package 
pacstrap -i /mnt mkinitcpio grub dhcpcd ccache nano reflector intel-ucode wget curl git --noconfirm --needed

# Generation fstab
genfstab -Up /mnt >> /mnt/etc/fstab

# Clone script
cp arch/setting.sh /mnt
chmod +x /mnt/setting.sh

# Clear
clear

# Chroot
arch-chroot /mnt ./setting.sh

# Delete script
rm /mnt/setting.sh

# Umount
echo "umount -R /mnt"