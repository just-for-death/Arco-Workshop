#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! "
echo "##########################################"
sleep 5
echo "Creating Backups of ~/.config folder"
echo "#####################################"
mv ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)
sleep 2
echo "Installing required Tools"
echo "#################################"
sudo pacman -S --needed --noconfirm kvantum latte-dock lolcat neofetch yakuake kde-wallpapers
sleep 2
echo "Installing Dracula Theme"
echo "#################################"
sudo pacman -S --noconfirm ant-dracula-gtk-theme ant-dracula-kvantum-theme-git konsole-dracula-git ant-dracula-kde-theme-git
git clone https://github.com/matheuuus/dracula-icons.git
mkdir ~/.local/share/icons
mv dracula-icons/ ~/.local/share/icons/
sleep 2
echo "Installing Fonts"
echo "#################################"
sudo pacman -S --needed --noconfirm nerd-fonts-hack nerd-fonts-fira-code nerd-fonts-meslo nerd-fonts-terminus noto-fonts-emoji
sleep 2
echo "Applying new Rice, hold on..."
echo "#################################"
cp -Rf Configs/Home/. ~
sudo rm /usr/share/defaultbg/XeroLinux.png
sudo cp -Rf Configs/System/. /
sleep 2
echo "Applying Grub Theme...."
echo "#################################"
chmod +x DraculGrub.sh
sudo ./DraculGrub.sh
sudo sed -i "s/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1920x1080/g" /etc/default/grub
sudo sed -i "s/#GRUB_GFXMODE=auto/GRUB_GFXMODE=1920x1080/g" /etc/default/grub
sudo sed -i "s/GRUB_GFXMODE=auto/GRUB_GFXMODE=1920x1080/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sleep 2
echo "RebootTo Apply Settings..."
echo "#################################"

