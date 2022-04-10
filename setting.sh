
# Enable internet | dhcpcd
systemctl enable dhcpcd && systemctl start dhcpcd

# Update pacman mirror list
reflector -c "Russia" -a 8 -l 8 --sort rate --save /etc/pacman.d/mirrorlist

## Add multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Clear
clear

## Update key
pacman-key --init
pacman-key --populate

## Update system
pacman -Syy --needed

# Clear
clear

# Set time
ln -svf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc --utc

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

## Clear
clear

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

## Xorg package
pacman -S --needed xorg-server xorg-server-common xorg-xrandr xorg-xinit

## Main package
pacman -S --needed firefox fish

## Audio package
pacman -S --needed pulseaudio pulseaudio-alsa pavucontrol

## Other package
pacman -S --needed neofetch htop

## Plasma package
pacman -S --needed sddm plasma konsole dolphin ark kwrite spectacle krunner partitionmanager audacious packagekit-qt5


# Clear
clear

# Enable service
systemctl enable sddm

# Enable fish
chsh -s /usr/bin/fish

# Setup grub
#grub-install --recheck /dev/sda
#grub-mkconfig -o /boot/grub/grub.cfg

# Exit
# exit