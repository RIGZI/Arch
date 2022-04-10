
# Enable internet | dhcpcd
systemctl enable dhcpcd && systemctl start dhcpcd

# Update pacman mirror list
reflector -c "Russia" -a 8 -l 8 --sort rate --save /etc/pacman.d/mirrorlist

## Update key
pacman-key --init
pacman-key --populate

## Add multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

## Update system
pacman -Syy --noconfirm --needed

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

# Logout rigzi
su rigzi

# Install package

## Xorg package
pacman -S --noconfirm --needed xorg-server xorg-server-common xorg-xrandr xorg-xinit

## Main package
pacman -S --noconfirm --needed firefox fish kitty

## BSPWM package
pacman -S --noconfirm --needed bspwm sxhkd picom dmenu nitrogen sddm

## Audio package
pacman -S --noconfirm --needed pulseaudio pulseaudio-alsa pavucontrol

## Other package
pacman -S --noconfirm --needed neofetch htop

# Enable service
systemctl enable sddm

# Install aur
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --skipinteg --noconfirm --needed
cd ..
rm -rf yay-bin

# Install nvidia driver
yay -S nvidia-390xx nvidia-390xx-utils nvidia-390xx-settings

# Install polybar
yay -S --needed polybar-git

# Setup config
mkdir -pv .config/{bspwm, sxhkd, polybar, picom}
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd
cp /usr/share/doc/picom/picom.conf.example ~/.config/picom.conf
cp /usr/share/doc/polybar/examples/config.ini ~/.config/polybar/config
chmod +x ~/.config/bspwm/bspwmrc
echo "exec bspwm" >> .xinitrc

## Edit bind
nano .config/sxhkd/sxhkdrc 
nano .config/sxhkd/bspwmrc

# Setup grub
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Exit
exit