#!/bin/bash

sudo rm /etc/apt/trusted.gpg.d/anydesk.asc
sudo rm /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update -y


sudo sed -i 's/WaylandEnable=false/#WaylandEnable=false/' /etc/gdm3/custom.conf




# إعادة التعديلات على ملف إعدادات AnyDesk
sudo sed -i 's/X11DisplayServer=true/#X11DisplayServer=true/' /etc/anydesk/anydesk.conf
sudo sed -i 's/X11DisplayServerTCP=false/#X11DisplayServerTCP=false/' /etc/anydesk/anydesk.conf



sudo apt remove --purge anydesk


# Step 6: Reinstall graphics drivers (NVIDIA or AMD)
echo "Reinstalling graphics drivers..."
if lspci | grep -i nvidia; then
    echo "NVIDIA graphics detected. Reinstalling NVIDIA drivers..."
    sudo apt install --reinstall -y nvidia-driver-460
elif lspci | grep -i amd; then
    echo "AMD graphics detected. Reinstalling AMD drivers..."
    sudo apt install --reinstall -y xserver-xorg-video-amdgpu
else
    echo "No NVIDIA or AMD graphics detected. Skipping driver reinstallation."
fi

# Step 7: Reboot the system to apply all changes
echo "Installation complete. Rebooting your system..."
sudo reboot

# Additional notes for the user:
echo "If the system was on Wayland, remember to log out and select 'Ubuntu on Xorg' on the login screen."
echo "Check if you are using Xorg after logging in by running: echo \$XDG_SESSION_TYPE"
echo "If it returns 'x11', you're using Xorg. If it returns 'wayland', make sure you've selected the Xorg session."
