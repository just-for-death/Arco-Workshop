sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf && sudo pacman -S --needed gamescope lib32-vulkan-icd-loader lib32-vulkan-radeon vul
kan-icd-loader vulkan-radeon && sudo pacman -S --needed lib32-libglvnd lib32-nvidia-ut
ils lib32-vulkan-icd-loader libglvnd nvidia vulkan-icd-loader && sudo pacman -S --need
ed giflib gnutls gst-plugins-bad gst-plugins-base gst-plugins-base-libs gst-plugins-go
od gst-plugins-ugly jq lib32-giflib lib32-gnutls lib32-gst-plugins-base-libs lib32-lib
jpeg-turbo lib32-libldap lib32-libpng lib32-libxcomposite lib32-libxinerama lib32-libx
slt lib32-mpg123 lib32-opencl-icd-loader lib32-sdl2 lib32-v4l-utils libgphoto2 libjpeg
-turbo libldap libpng libxcomposite libxinerama libxslt mono mpg123 opencl-icd-loader
sdl2 v4l-utils wine-staging && yay dxvk-bin && yay vkd3d-proton-bin && sudo pacman -S
--needed alsa-lib alsa-plugins lib32-alsa-lib lib32-alsa-plugins lib32-libpulse libpul
se fluidsynth openal lib32-openal && sudo  pacman -Syyu && sudo pacman -S chaotic-aur/
yuzu-mainline-git && yay tut && yay otp && yay electronm && yay criptext && yay lutris
- && yay wine- &&yay topgrade && yay cawbir && yay newsflas && yay trackma && yay fire
walld && yay opensnitch
