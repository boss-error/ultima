#!/bin/bash

# Step 1: Update system and install required dependencies
echo "Updating system and installing dependencies..."
sudo apt update -y
sudo apt install -y wget

# Step 2: Add AnyDesk repository and install AnyDesk
echo "Adding AnyDesk repository..."
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo tee /etc/apt/trusted.gpg.d/anydesk.asc
sudo sh -c 'echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list'
sudo apt update -y

echo "Installing AnyDesk..."
sudo apt install -y anydesk

# Step 3: Check if Xorg or Wayland is being used
SESSION_TYPE=$(echo $XDG_SESSION_TYPE)

if [[ "$SESSION_TYPE" == "wayland" ]]; then
    echo "You are using Wayland. Switching to Xorg..."

    # Force Xorg by modifying GDM3 config to disable Wayland
    sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
    echo "Please log out and select 'Ubuntu on Xorg' on the login screen."
    echo "After logging in again, you can rerun this script to continue."
    exit 0
else
    echo "You are using Xorg. No need to switch."
fi

# Step 4: Force X11 in AnyDesk Configuration
echo "Modifying AnyDesk configuration to use X11..."
sudo sed -i 's/#X11DisplayServer=true/X11DisplayServer=true/' /etc/anydesk/anydesk.conf
sudo sed -i 's/#X11DisplayServerTCP=false/X11DisplayServerTCP=false/' /etc/anydesk/anydesk.conf

# Step 5: Reinstall AnyDesk and restart the service
echo "Reinstalling AnyDesk and restarting service..."
sudo apt remove --purge anydesk
sudo apt install -y anydesk
sudo systemctl restart anydesk

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
