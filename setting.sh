
# Enable internet | dhcpcd
systemctl enable dhcpcd && systemctl start dhcpcd

# Update pacman mirror list
reflector -c "Russia" -a 8 -l 8 --sort rate --save /etc/pacman.d/mirrorlist

## Add multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

## Update key
pacman-key --init
pacman-key --populate

## Update system
pacman -Syy --needed

# Set time
ln -svf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc

# Setting host
echo "pc" >> /etc/hostname
echo "
127.0.0.1	localhost
::1			localhost
127.0.1.1	pc.localdomain pc
" >> /etc/hosts

# Setup language

## Add US
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen

## Add RU
sed -i "s/#\(ru_RU\.UTF-8\)/\1/" /etc/locale.gen

## Generation language
locale-gen

## Add RU other file
echo "LANG=ru_RU.UTF-8" >> /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf
echo "KEYMAP=ru" >> /etc/vconsole.conf

# Set root password
echo "Set root password"
passwd

# Add user
useradd -m -g users -G wheel -s /bin/bash rigzi

## Set right user
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

## Set user password
echo "Set user password"
passwd rigzi

# Install package

## Gnome package
pacman -S gnome xorg gnome-terminal nautilus gnome-tweaks gnome-control-center gnome-backgrounds adwaita-icon-theme gnome-themes-extra gnome-keyring

## Main package
pacman -S --needed chromium fish gdm neofetch htop

# Enable service
systemctl enable gdm

# Enable fish
chsh -s /usr/bin/fish

# Setup grub
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
