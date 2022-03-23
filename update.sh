sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf && sudo pacman -Syyu && sudo pacman -S --needed lib32-vulkan-icd-loader lib32-vulkan-radeon vulkan-icd-loader vulkan-radeon && sudo pacman -S --needed lib32-libglvnd lib32-nvidia-utils lib32-vulkan-icd-loader libglvnd nvidia vulkan-icd-loader && sudo pacman -S --needed giflib gnutls gst-plugins-bad gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-ugly jq lib32-giflib lib32-gnutls lib32-gst-plugins-base-libs lib32-libjpeg-turbo lib32-libldap lib32-libpng lib32-libxcomposite lib32-libxinerama lib32-libxslt lib32-mpg123 lib32-opencl-icd-loader lib32-sdl2 lib32-v4l-utils libgphoto2 libjpeg-turbo libldap libpng libxcomposite libxinerama libxslt mono mpg123 opencl-icd-loader sdl2 v4l-utils wine-staging libxcrypt-compat && git clone https://aur.archlinux.org/zpaq.git && cd zpaq && makepkg -si && yay -S dxvk-bin vkd3d-proton-bin && sudo pacman -S --needed alsa-lib alsa-plugins lib32-alsa-lib lib32-alsa-plugins lib32-libpulse libpulse fluidsynth openal lib32-openal && sudo pacman -S chaotic-aur/yuzu-mainline-git && yay tut && yay otp && yay electronm && yay criptext && yay lutris- && yay wine- && yay topgrade && yay cawbir && yay newsflas && yay trackma && yay firewalld && yay opensnitc && yay -S libinput-gestures && yay -S libinput_gestures_qt && yay -S fail2ban && bash && libinput-gestures-setup autostart start && exit 

bash &&
#!/bin/bash
#-----------------------
#--Required Packages-
#-ufw
#-fail2ban

# --- Setup UFW rules
sudo ufw limit 22/tcp  
sudo ufw allow 80/tcp  
sudo ufw allow 443/tcp  
sudo ufw default deny incoming  
sudo ufw default allow outgoing
sudo ufw enable

# --- Harden /etc/sysctl.conf
sudo sysctl kernel.modules_disabled=1
sudo sysctl -a
sudo sysctl -A
sudo sysctl mib
sudo sysctl net.ipv4.conf.all.rp_filter
sudo sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'

# --- PREVENT IP SPOOFS
cat <<EOF > /etc/host.conf
order bind,hosts
multi on
EOF

# --- Enable fail2ban
sudo cp fail2ban.local /etc/fail2ban/
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

echo "listening ports"
sudo netstat -tunlp 
&& exit
