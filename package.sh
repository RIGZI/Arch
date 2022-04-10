
# Install aur
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --skipinteg --needed
cd ..
rm -rf yay-bin

# Install audio effect
yay -S easyeffects-git

# Install nvidia driver
yay -S nvidia-390xx nvidia-390xx-utils nvidia-390xx-settings