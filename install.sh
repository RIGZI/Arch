
# Set RU language

## Load language
loadkeys ru

## Set font
setfont cyr-sun16

## Add RU locale
sed -i "s/#\(ru_RU\.UTF-8\)/\1/" /etc/locale.gen

## Generation
locale-gen

## Set language
export LANG=ru_RU.UTF-8

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

# Setup mkinitcpio
sed -i "s/^HOOKS=\(.*keyboard\)/HOOKS=\1 keymap/" /etc/mkinitcpio.conf
mkinitcpio -p linux-zen

# Clone script
mv settings.sh /mnt
chmod +x /mnt/settings.sh

# Chroot
arch-chroot /mnt /bin/bash -c /settings.sh

# Delete script
rm /mnt/settings.sh

# Umount
umount -R /mnt